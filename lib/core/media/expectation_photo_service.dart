import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinly/contracts/media/ports/media_repository.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';

class CameraPermissionException implements Exception {
  CameraPermissionException({required this.permanentlyDenied});

  final bool permanentlyDenied;
}

class CameraCaptureCancelled implements Exception {}

class ExpectationPhotoService {
  ExpectationPhotoService({
    ImagePicker? picker,
    required MediaRepository mediaRepository,
    Logger? logger,
  }) : _picker = picker ?? ImagePicker(),
       _mediaRepository = mediaRepository,
       _logger = logger ?? const DebugLogger();

  final ImagePicker _picker;
  final MediaRepository _mediaRepository;
  final Logger _logger;
  String? _lastRecoveredPath;
  int _captureAttempt = 0;
  static const String _pendingCaptureKey = 'expectation_photo.pending_capture_v1';
  static const Duration _pendingCaptureTtl = Duration(hours: 1);

  Future<MediaUploadResult> captureAndUpload({
    required String homeId,
    String? choreId,
    String rootSegment = 'flow',
    String featureSegment = 'expectations',
  }) async {
    final captureAttempt = ++_captureAttempt;
    _logger.info(
      'Photo capture started. attempt=$captureAttempt homeId=$homeId entityId=$choreId '
      'root=$rootSegment feature=$featureSegment',
      tag: 'PhotoCapture',
    );
    final recovered = await recoverLostAndUploadIfPending(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
    );
    if (recovered != null) {
      return recovered;
    }
    final hasPermission = await _ensureCameraPermission();
    if (!hasPermission) {
      _logger.warn(
        'Photo capture denied due to camera permission request result. '
        'attempt=$captureAttempt homeId=$homeId entityId=$choreId',
        tag: 'PhotoCapture',
      );
      throw CameraPermissionException(permanentlyDenied: false);
    }

    await _persistPendingCapture(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
    );
    XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        maxHeight: 1200,
        imageQuality: 75,
        requestFullMetadata: false,
      );
    } finally {
      await _clearPendingCapture();
    }

    if (picked == null) {
      _logger.info(
        'Photo capture cancelled by user. attempt=$captureAttempt '
        'homeId=$homeId entityId=$choreId',
        tag: 'PhotoCapture',
      );
      throw CameraCaptureCancelled();
    }

    final result = await _upload(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
      picked: picked,
      captureAttempt: captureAttempt,
      source: 'capture',
    );
    return result;
  }

  Future<MediaUploadResult?> recoverLostAndUploadIfPending({
    required String homeId,
    String? choreId,
    String rootSegment = 'flow',
    String featureSegment = 'expectations',
  }) async {
    final pending = await _readPendingCapture();
    if (pending == null) return null;

    if (!pending.matches(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
    )) {
      _logger.info(
        'Ignoring pending capture for different context. '
        'pendingHomeId=${pending.homeId} pendingEntityId=${pending.choreId} '
        'pendingRoot=${pending.rootSegment} pendingFeature=${pending.featureSegment} '
        'homeId=$homeId entityId=$choreId root=$rootSegment feature=$featureSegment',
        tag: 'PhotoCapture',
      );
      return null;
    }

    final captureAttempt = ++_captureAttempt;
    final recovered = await _recoverLostCapture(
      homeId: homeId,
      choreId: choreId,
      captureAttempt: captureAttempt,
    );
    if (recovered == null) {
      await _clearPendingCapture();
      return null;
    }

    try {
      final result = await _upload(
        homeId: homeId,
        choreId: choreId,
        rootSegment: rootSegment,
        featureSegment: featureSegment,
        picked: recovered,
        captureAttempt: captureAttempt,
        source: 'lost',
      );
      return result;
    } finally {
      await _clearPendingCapture();
    }
  }

  Future<MediaUploadResult> _upload({
    required String homeId,
    String? choreId,
    required String rootSegment,
    required String featureSegment,
    required XFile picked,
    required int captureAttempt,
    required String source,
  }) async {
    final bytes = await picked.readAsBytes();
    final result = await _mediaRepository.uploadExpectationPhoto(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
      bytes: Uint8List.fromList(bytes),
    );
    _logger.info(
      'Photo capture uploaded successfully. attempt=$captureAttempt source=$source '
      'homeId=$homeId entityId=$choreId '
      'storagePath=${result.storagePath}',
      tag: 'PhotoCapture',
    );
    return result;
  }

  Future<XFile?> _recoverLostCapture({
    required String homeId,
    String? choreId,
    required int captureAttempt,
  }) async {
    try {
      final lostData = await _picker.retrieveLostData();
      if (lostData.isEmpty) return null;

      final files = lostData.files;
      if (files != null && files.isNotEmpty) {
        final first = files.first;
        if (_lastRecoveredPath == first.path) {
          _logger.warn(
            'Ignoring duplicate lost camera capture data. attempt=$captureAttempt '
            'homeId=$homeId entityId=$choreId '
            'path=${first.path}',
            tag: 'PhotoCapture',
          );
          return null;
        }
        _lastRecoveredPath = first.path;
        _logger.warn(
          'Recovered lost camera capture data. attempt=$captureAttempt '
          'homeId=$homeId entityId=$choreId '
          'files=${files.length}',
          tag: 'PhotoCapture',
        );
        return first;
      }

      if (lostData.exception != null) {
        _logger.warn(
          'Lost camera capture had exception. attempt=$captureAttempt '
          'homeId=$homeId entityId=$choreId',
          tag: 'PhotoCapture',
          error: lostData.exception,
        );
      }
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to check lost camera capture data. attempt=$captureAttempt '
        'homeId=$homeId entityId=$choreId',
        tag: 'PhotoCapture',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      throw CameraPermissionException(permanentlyDenied: true);
    }
    final requested = await Permission.camera.request();
    if (requested.isGranted) return true;
    if (requested.isPermanentlyDenied) {
      throw CameraPermissionException(permanentlyDenied: true);
    }
    return false;
  }

  Future<void> _persistPendingCapture({
    required String homeId,
    String? choreId,
    required String rootSegment,
    required String featureSegment,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = _PendingCaptureContext(
        homeId: homeId,
        choreId: choreId,
        rootSegment: rootSegment,
        featureSegment: featureSegment,
        createdAtMs: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
      await prefs.setString(_pendingCaptureKey, jsonEncode(payload.toJson()));
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to persist pending photo capture context.',
        tag: 'PhotoCapture',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<_PendingCaptureContext?> _readPendingCapture() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_pendingCaptureKey);
      if (raw == null || raw.trim().isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        await prefs.remove(_pendingCaptureKey);
        return null;
      }
      final pending = _PendingCaptureContext.fromJson(
        decoded.cast<String, dynamic>(),
      );
      if (pending == null) {
        await prefs.remove(_pendingCaptureKey);
        return null;
      }
      final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
      if (nowMs - pending.createdAtMs > _pendingCaptureTtl.inMilliseconds) {
        _logger.info(
          'Dropping stale pending photo capture context.',
          tag: 'PhotoCapture',
        );
        await prefs.remove(_pendingCaptureKey);
        return null;
      }
      return pending;
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to read pending photo capture context.',
        tag: 'PhotoCapture',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _clearPendingCapture() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingCaptureKey);
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to clear pending photo capture context.',
        tag: 'PhotoCapture',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

class _PendingCaptureContext {
  const _PendingCaptureContext({
    required this.homeId,
    required this.choreId,
    required this.rootSegment,
    required this.featureSegment,
    required this.createdAtMs,
  });

  final String homeId;
  final String? choreId;
  final String rootSegment;
  final String featureSegment;
  final int createdAtMs;

  bool matches({
    required String homeId,
    required String? choreId,
    required String rootSegment,
    required String featureSegment,
  }) {
    return this.homeId == homeId &&
        this.choreId == choreId &&
        this.rootSegment == rootSegment &&
        this.featureSegment == featureSegment;
  }

  Map<String, dynamic> toJson() => {
    'homeId': homeId,
    'choreId': choreId,
    'rootSegment': rootSegment,
    'featureSegment': featureSegment,
    'createdAtMs': createdAtMs,
  };

  static _PendingCaptureContext? fromJson(Map<String, dynamic> json) {
    final homeId = json['homeId'];
    final choreId = json['choreId'];
    final rootSegment = json['rootSegment'];
    final featureSegment = json['featureSegment'];
    final createdAtMs = json['createdAtMs'];
    if (homeId is! String ||
        rootSegment is! String ||
        featureSegment is! String ||
        createdAtMs is! int) {
      return null;
    }
    if (choreId != null && choreId is! String) {
      return null;
    }
    return _PendingCaptureContext(
      homeId: homeId,
      choreId: choreId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
      createdAtMs: createdAtMs,
    );
  }
}
