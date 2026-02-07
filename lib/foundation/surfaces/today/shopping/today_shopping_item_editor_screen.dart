import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/media/kinly_photo_capture.dart';
import 'package:kinly/core/ui/paywall/paywall_gate_listener.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/shopping_item_bloc.dart';

class TodayShoppingItemEditorScreen extends StatefulWidget {
  const TodayShoppingItemEditorScreen({super.key, required this.homeId, this.item});

  final String homeId;
  final ShoppingListItem? item;

  @override
  State<TodayShoppingItemEditorScreen> createState() =>
      _TodayShoppingItemEditorScreenState();
}

class _TodayShoppingItemEditorScreenState
    extends State<TodayShoppingItemEditorScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _hydrated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final paywallStrings = PaywallStrings(
      title: s.paywallTitle,
      subtitle: s.paywallSubtitle,
      bulletMembers: s.paywallBulletMembers,
      bulletFlows: s.paywallBulletFlows,
      bulletPhotos: s.paywallBulletPhotos,
      bulletShares: s.paywallBulletShares,
      unlimitedLabel: s.paywallSubtitle,
      priceCaption: s.paywallPriceCaption,
      priceUnavailableLabel: s.paywallPriceUnavailable,
      priceFormatter: (price) => s.paywallPricePerMonth(price),
      primaryCta: s.paywallPrimaryCta,
      secondaryCta: s.paywallSecondaryCta,
      purchaseFailed: s.paywallPurchaseFailed,
      purchaseSuccess: s.paywallPurchaseSuccess,
      restoreCta: s.paywallRestoreCta,
      errorTitle: s.paywallErrorTitle,
      retryLabel: s.paywallRetryLabel,
    );

    return PaywallGateListener<ShoppingItemBloc, ShoppingItemState>(
      strings: paywallStrings,
      requestSelector: (state) => state.paywallRequest,
      inFlightRequestIdSelector: (state) => state.paywallInFlightRequestId,
      onOpened:
          (requestId) => context.read<ShoppingItemBloc>().add(
            ShoppingItemPaywallOpenedEvent(requestId),
          ),
      onOutcome:
          (outcome) => context.read<ShoppingItemBloc>().add(
            ShoppingItemPaywallResolvedEvent(outcome),
          ),
      child: BlocConsumer<ShoppingItemBloc, ShoppingItemState>(
        listenWhen:
            (prev, curr) =>
                prev.submissionErrorTick != curr.submissionErrorTick ||
                prev.photoErrorTick != curr.photoErrorTick ||
                prev.successItemId != curr.successItemId,
        listener: (context, state) {
          if (state.photoErrorTick > 0) {
            final isPermission = state.photoErrorMessage == 'permission';
            final label =
                isPermission
                    ? s.flowChorePhotoPermissionDenied
                    : s.flowChorePhotoUploadError;
            KinlySnackBar.showInfo(
              context,
              label,
              actionLabel:
                  state.cameraPermissionPermanentlyDenied
                      ? s.flowChorePhotoPermissionOpenSettings
                      : null,
              onAction: state.cameraPermissionPermanentlyDenied ? openAppSettings : null,
            );
          }
          if (state.submissionErrorTick > 0 &&
              state.submissionErrorMessage != null) {
            KinlySnackBar.showError(context, state.submissionErrorMessage!);
          }
          if (state.successItemId != null) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          _hydrateOnce(state);
          final isEditing = state.isEditing;
          final title = isEditing ? s.shoppingEditTitle : s.shoppingCreateTitle;
          final submitLabel =
              isEditing ? s.shoppingSubmitEdit : s.shoppingSubmitAdd;
          final photoLabel =
              state.hasExistingPhoto ? s.shoppingPhotoReplaceLabel : s.shoppingPhotoLabel;
          final initial = widget.item;
          final canDelete =
              initial != null &&
              initial.name.trim() == state.name.trim() &&
              (initial.quantity ?? '').trim() == state.quantity.trim() &&
              (initial.details ?? '').trim() == state.details.trim() &&
              (initial.referencePhotoPath ?? '').trim() ==
                  (state.referencePhotoPath ?? '').trim();

          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(title)),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsetsDirectional.all(spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KinlyTextField(
                              controller: _nameController,
                              labelText: s.shoppingNameLabel,
                              hintText: s.shoppingNameHint,
                              errorText:
                                  state.showValidationErrors &&
                                          state.name.trim().isEmpty
                                      ? s.shoppingValidationName
                                      : null,
                              onChanged:
                                  (value) => context.read<ShoppingItemBloc>().add(
                                    ShoppingItemNameChangedEvent(value),
                                  ),
                            ),
                            SizedBox(height: spacing.md),
                            KinlyTextField(
                              controller: _quantityController,
                              labelText: s.shoppingAmountLabel,
                              hintText: s.shoppingAmountHint,
                              onChanged:
                                  (value) => context.read<ShoppingItemBloc>().add(
                                    ShoppingItemQuantityChangedEvent(value),
                                  ),
                            ),
                            SizedBox(height: spacing.md),
                            KinlyTextField(
                              controller: _detailsController,
                              labelText: s.shoppingContextLabel,
                              hintText: s.shoppingContextHint,
                              maxLines: 4,
                              minLines: 3,
                              onChanged:
                                  (value) => context.read<ShoppingItemBloc>().add(
                                    ShoppingItemDetailsChangedEvent(value),
                                  ),
                            ),
                            SizedBox(height: spacing.md),
                            KinlyPhotoCapture(
                              photoUrl: state.referencePhotoUrl,
                              label: photoLabel,
                              placeholderText: s.shoppingPhotoPlaceholder,
                              isUploading: state.isUploadingPhoto,
                              onTap:
                                  () => context.read<ShoppingItemBloc>().add(
                                    const ShoppingItemPhotoCaptureRequestedEvent(),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.lg),
                    KinlyFilledButton.text(
                      onPressed:
                          state.isSubmitting
                              ? null
                              : () => context.read<ShoppingItemBloc>().add(
                                const SubmitShoppingItemEvent(),
                              ),
                      label: submitLabel,
                      fullWidth: true,
                    ),
                    if (isEditing && canDelete) ...[
                      SizedBox(height: spacing.md),
                      KinlyFilledButton.destructiveText(
                        onPressed:
                            state.isSubmitting ? null : () => _confirmDelete(context),
                        label: s.shoppingDelete,
                        fullWidth: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _hydrateOnce(ShoppingItemState state) {
    if (_hydrated) return;
    _nameController.text = state.name;
    _quantityController.text = state.quantity;
    _detailsController.text = state.details;
    _hydrated = true;
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = S.of(context);
    final shouldDelete = await showKinlyConfirmDialog(
      context,
      title: s.shoppingDeleteConfirmTitle,
      message: s.shoppingDeleteConfirmBody,
      confirmLabel: s.shoppingDelete,
      destructive: true,
    );
    if (shouldDelete != true || !context.mounted) return;
    context.read<ShoppingItemBloc>().add(const DeleteShoppingItemEvent());
  }
}
