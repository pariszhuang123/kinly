import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

import 'bloc/shopping_item_bloc.dart';
import 'today_shopping_item_editor_screen.dart';

class TodayShoppingItemProvider extends StatefulWidget {
  const TodayShoppingItemProvider({
    super.key,
    required this.homeId,
    required this.homeUnitsRepository,
    required this.shoppingListRepository,
    this.editItemId,
    this.item,
  });

  final String homeId;
  final HomeUnitsRepository homeUnitsRepository;
  final ShoppingListRepository shoppingListRepository;
  final String? editItemId;
  final ShoppingListItem? item;

  @override
  State<TodayShoppingItemProvider> createState() =>
      _TodayShoppingItemProviderState();
}

class _TodayShoppingItemProviderState extends State<TodayShoppingItemProvider> {
  late Future<ShoppingListItem?> _itemFuture;

  @override
  void initState() {
    super.initState();
    _itemFuture = _resolveItem();
  }

  @override
  void didUpdateWidget(covariant TodayShoppingItemProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.homeId != widget.homeId ||
        oldWidget.editItemId != widget.editItemId ||
        oldWidget.item?.id != widget.item?.id) {
      _itemFuture = _resolveItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    final directItem = widget.item;
    if (directItem != null || widget.editItemId == null) {
      return _buildEditor(item: directItem);
    }

    return FutureBuilder<ShoppingListItem?>(
      future: _itemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _ShoppingItemLoadingScreen();
        }
        if (snapshot.hasError) {
          return _ShoppingItemLoadErrorScreen(
            onRetry: _retryResolveItem,
          );
        }
        final loaded = snapshot.data;
        if (loaded == null) {
          return const _ShoppingItemNotFoundScreen();
        }
        return _buildEditor(item: loaded);
      },
    );
  }

  Future<ShoppingListItem?> _resolveItem() async {
    final fromArgs = widget.item;
    if (fromArgs != null) {
      return fromArgs;
    }
    final itemId = widget.editItemId;
    if (itemId == null || itemId.isEmpty) {
      return null;
    }
    final snapshot = await widget.shoppingListRepository.getForHome(
      homeId: widget.homeId,
    );
    for (final item in snapshot.items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  void _retryResolveItem() {
    setState(() {
      _itemFuture = _resolveItem();
    });
  }

  Widget _buildEditor({required ShoppingListItem? item}) {
    return BlocProvider(
      create: (_) {
        final bloc = ShoppingItemBloc(
          homeId: widget.homeId,
          item: item,
          homeUnitsRepository: widget.homeUnitsRepository,
          shoppingListRepository: widget.shoppingListRepository,
        );
        bloc.add(const ShoppingItemUnitContextRequestedEvent());
        bloc.add(const ShoppingItemPhotoRecoveryRequestedEvent());
        return bloc;
      },
      child: TodayShoppingItemEditorScreen(homeId: widget.homeId, item: item),
    );
  }
}

class _ShoppingItemLoadingScreen extends StatelessWidget {
  const _ShoppingItemLoadingScreen();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingEditTitle)),
      body: const SafeArea(child: Center(child: KinlyLoader())),
    );
  }
}

class _ShoppingItemLoadErrorScreen extends StatelessWidget {
  const _ShoppingItemLoadErrorScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingEditTitle)),
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

class _ShoppingItemNotFoundScreen extends StatelessWidget {
  const _ShoppingItemNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingEditTitle)),
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
