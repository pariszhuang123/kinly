part of 'shopping_item_bloc.dart';

class ShoppingItemState extends Equatable {
  const ShoppingItemState._({
    required this.isEditing,
    required this.name,
    required this.quantity,
    required this.details,
    required this.referencePhotoPath,
    required this.referencePhotoUrl,
    required this.hasPhotoChanged,
    required this.isSubmitting,
    required this.isUploadingPhoto,
    required this.showValidationErrors,
    required this.submissionErrorMessage,
    required this.submissionErrorTick,
    required this.photoErrorMessage,
    required this.photoErrorTick,
    required this.cameraPermissionPermanentlyDenied,
    required this.successItemId,
    required this.paywallRequestTick,
    required this.paywallAction,
    required this.paywallRequest,
    required this.paywallInFlightRequestId,
  });

  factory ShoppingItemState.initial({
    required ShoppingListItem? item,
    required bool isEditing,
    required String? referencePhotoUrl,
  }) {
    return ShoppingItemState._(
      isEditing: isEditing,
      name: item?.name ?? '',
      quantity: item?.quantity ?? '',
      details: item?.details ?? '',
      referencePhotoPath: item?.referencePhotoPath,
      referencePhotoUrl: referencePhotoUrl,
      hasPhotoChanged: false,
      isSubmitting: false,
      isUploadingPhoto: false,
      showValidationErrors: false,
      submissionErrorMessage: null,
      submissionErrorTick: 0,
      photoErrorMessage: null,
      photoErrorTick: 0,
      cameraPermissionPermanentlyDenied: false,
      successItemId: null,
      paywallRequestTick: 0,
      paywallAction: null,
      paywallRequest: null,
      paywallInFlightRequestId: null,
    );
  }

  final bool isEditing;
  final String name;
  final String quantity;
  final String details;
  final String? referencePhotoPath;
  final String? referencePhotoUrl;
  final bool hasPhotoChanged;
  final bool isSubmitting;
  final bool isUploadingPhoto;
  final bool showValidationErrors;
  final String? submissionErrorMessage;
  final int submissionErrorTick;
  final String? photoErrorMessage;
  final int photoErrorTick;
  final bool cameraPermissionPermanentlyDenied;
  final String? successItemId;
  final int paywallRequestTick;
  final PaywallRetryAction? paywallAction;
  final PaywallGateRequest? paywallRequest;
  final String? paywallInFlightRequestId;

  ShoppingItemState copyWith({
    String? name,
    String? quantity,
    String? details,
    String? referencePhotoPath,
    String? referencePhotoUrl,
    bool? hasPhotoChanged,
    bool? isSubmitting,
    bool? isUploadingPhoto,
    bool? showValidationErrors,
    String? submissionErrorMessage,
    int? submissionErrorTick,
    bool clearSubmissionError = false,
    String? photoErrorMessage,
    int? photoErrorTick,
    bool clearPhotoError = false,
    bool? cameraPermissionPermanentlyDenied,
    String? successItemId,
    bool clearSuccess = false,
    int? paywallRequestTick,
    PaywallRetryAction? paywallAction,
    PaywallGateRequest? paywallRequest,
    String? paywallInFlightRequestId,
  }) {
    return ShoppingItemState._(
      isEditing: isEditing,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      details: details ?? this.details,
      referencePhotoPath: referencePhotoPath ?? this.referencePhotoPath,
      referencePhotoUrl: referencePhotoUrl ?? this.referencePhotoUrl,
      hasPhotoChanged: hasPhotoChanged ?? this.hasPhotoChanged,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      submissionErrorMessage: clearSubmissionError
          ? null
          : submissionErrorMessage ?? this.submissionErrorMessage,
      submissionErrorTick: submissionErrorTick ?? this.submissionErrorTick,
      photoErrorMessage: clearPhotoError
          ? null
          : photoErrorMessage ?? this.photoErrorMessage,
      photoErrorTick: photoErrorTick ?? this.photoErrorTick,
      cameraPermissionPermanentlyDenied:
          cameraPermissionPermanentlyDenied ??
          this.cameraPermissionPermanentlyDenied,
      successItemId: clearSuccess ? null : successItemId ?? this.successItemId,
      paywallRequestTick: paywallRequestTick ?? this.paywallRequestTick,
      paywallAction: paywallAction ?? this.paywallAction,
      paywallRequest: paywallRequest ?? this.paywallRequest,
      paywallInFlightRequestId:
          paywallInFlightRequestId ?? this.paywallInFlightRequestId,
    );
  }

  bool get hasExistingPhoto => (referencePhotoPath ?? '').trim().isNotEmpty;

  @override
  List<Object?> get props => [
    isEditing,
    name,
    quantity,
    details,
    referencePhotoPath,
    referencePhotoUrl,
    hasPhotoChanged,
    isSubmitting,
    isUploadingPhoto,
    showValidationErrors,
    submissionErrorMessage,
    submissionErrorTick,
    photoErrorMessage,
    photoErrorTick,
    cameraPermissionPermanentlyDenied,
    successItemId,
    paywallRequestTick,
    paywallAction,
    paywallRequest,
    paywallInFlightRequestId,
  ];
}
