import '../fit_check_models.dart';

abstract class FitCheckRepository {
  Future<FitCheckClaimResult> claimDraft({required String claimToken});

  Future<FitCheckAttachResult> attachDraftToHome({
    required String draftId,
    required String homeId,
  });

  Future<FitCheckOwnerReview> getOwnerReview({
    required String draftId,
    required String locale,
  });

  Future<FitCheckOwnerBriefing> getOwnerBriefing({
    required String submissionId,
    required String locale,
  });

  Future<FitCheckPrefillPayload> getPrefillPayload({required String draftId});

  Future<FitCheckShareTokenActionResult> rotateShareToken({
    required String draftId,
  });

  Future<FitCheckShareTokenActionResult> revokeShareToken({
    required String draftId,
  });
}
