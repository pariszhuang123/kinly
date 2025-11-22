import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'media_repository.dart';

class CameraPermissionException implements Exception {
  CameraPermissionException({required this.permanentlyDenied});

  final bool permanentlyDenied;
}

class CameraCaptureCancelled implements Exception {}

class ExpectationPhotoService {
  ExpectationPhotoService({
    ImagePicker? picker,
    required MediaRepository mediaRepository,
  }) : _picker = picker ?? ImagePicker(),
       _mediaRepository = mediaRepository;

  final ImagePicker _picker;
  final MediaRepository _mediaRepository;

  Future<MediaUploadResult> captureAndUpload({
    required String homeId,
    String? choreId,
  }) async {
    final hasPermission = await _ensureCameraPermission();
    if (!hasPermission) {
      throw CameraPermissionException(permanentlyDenied: false);
    }

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1200,
      imageQuality: 75,
    );

    if (picked == null) {
      throw CameraCaptureCancelled();
    }

    final bytes = await picked.readAsBytes();
    return _mediaRepository.uploadExpectationPhoto(
      homeId: homeId,
      choreId: choreId,
      bytes: Uint8List.fromList(bytes),
    );
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
}
