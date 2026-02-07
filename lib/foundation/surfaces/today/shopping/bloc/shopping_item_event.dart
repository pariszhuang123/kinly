part of 'shopping_item_bloc.dart';

abstract class ShoppingItemEvent extends Equatable {
  const ShoppingItemEvent();

  @override
  List<Object?> get props => [];
}

class ShoppingItemNameChangedEvent extends ShoppingItemEvent {
  const ShoppingItemNameChangedEvent(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ShoppingItemQuantityChangedEvent extends ShoppingItemEvent {
  const ShoppingItemQuantityChangedEvent(this.quantity);

  final String quantity;

  @override
  List<Object?> get props => [quantity];
}

class ShoppingItemDetailsChangedEvent extends ShoppingItemEvent {
  const ShoppingItemDetailsChangedEvent(this.details);

  final String details;

  @override
  List<Object?> get props => [details];
}

class ShoppingItemPhotoCaptureRequestedEvent extends ShoppingItemEvent {
  const ShoppingItemPhotoCaptureRequestedEvent();
}

class SubmitShoppingItemEvent extends ShoppingItemEvent {
  const SubmitShoppingItemEvent();
}

class DeleteShoppingItemEvent extends ShoppingItemEvent {
  const DeleteShoppingItemEvent();
}

class ShoppingItemPaywallOpenedEvent extends ShoppingItemEvent {
  const ShoppingItemPaywallOpenedEvent(this.requestId);

  final String requestId;

  @override
  List<Object?> get props => [requestId];
}

class ShoppingItemPaywallResolvedEvent extends ShoppingItemEvent {
  const ShoppingItemPaywallResolvedEvent(this.outcome);

  final PaywallGateOutcome outcome;

  @override
  List<Object?> get props => [outcome];
}
