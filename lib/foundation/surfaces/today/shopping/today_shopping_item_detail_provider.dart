import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

import 'today_shopping_item_detail_screen.dart';

class TodayShoppingItemDetailProvider extends StatefulWidget {
  const TodayShoppingItemDetailProvider({
    super.key,
    required this.homeId,
    required this.itemId,
    required this.shoppingListRepository,
  });

  final String homeId;
  final String itemId;
  final ShoppingListRepository shoppingListRepository;

  @override
  State<TodayShoppingItemDetailProvider> createState() =>
      _TodayShoppingItemDetailProviderState();
}

class _TodayShoppingItemDetailProviderState
    extends State<TodayShoppingItemDetailProvider> {
  late Future<ShoppingListItem?> _itemFuture;

  @override
  void initState() {
    super.initState();
    _itemFuture = _resolveItem();
  }

  @override
  void didUpdateWidget(covariant TodayShoppingItemDetailProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.homeId != widget.homeId || oldWidget.itemId != widget.itemId) {
      _itemFuture = _resolveItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ShoppingListItem?>(
      future: _itemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _ShoppingItemDetailLoadingScreen();
        }
        if (snapshot.hasError) {
          return _ShoppingItemDetailErrorScreen(onRetry: _retryResolveItem);
        }
        final item = snapshot.data;
        if (item == null) {
          return const _ShoppingItemDetailNotFoundScreen();
        }
        final photoUrl =
            widget.shoppingListRepository.toPublicPhotoUrl(
              item.referencePhotoPath,
            ) ??
            '';
        return TodayShoppingItemDetailScreen(
          item: item,
          photoUrl: photoUrl,
          onMarkComplete: () => _markComplete(item.id),
        );
      },
    );
  }

  Future<ShoppingListItem?> _resolveItem() async {
    final snapshot = await widget.shoppingListRepository.getForHome(
      homeId: widget.homeId,
    );
    for (final item in snapshot.items) {
      if (item.id == widget.itemId) return item;
    }
    return null;
  }

  Future<void> _markComplete(String itemId) async {
    await widget.shoppingListRepository.updateItem(
      itemId: itemId,
      isCompleted: true,
    );
  }

  void _retryResolveItem() {
    setState(() {
      _itemFuture = _resolveItem();
    });
  }
}

class _ShoppingItemDetailLoadingScreen extends StatelessWidget {
  const _ShoppingItemDetailLoadingScreen();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingDetailTitle)),
      body: const SafeArea(child: Center(child: KinlyLoader())),
    );
  }
}

class _ShoppingItemDetailErrorScreen extends StatelessWidget {
  const _ShoppingItemDetailErrorScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingDetailTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.profileGenericError,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.md),
                KinlyFilledButton.text(
                  onPressed: onRetry,
                  label: s.profileIdentityRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShoppingItemDetailNotFoundScreen extends StatelessWidget {
  const _ShoppingItemDetailNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingDetailTitle)),
      body: SafeArea(
        child: Center(
          child: Text(
            s.shoppingEmptyTitle,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
