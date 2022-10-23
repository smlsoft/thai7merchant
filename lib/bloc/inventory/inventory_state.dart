part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

//Load

class InventoryInitial extends InventoryState {}

class InventoryInProgress extends InventoryState {}

class InventoryLoadSuccess extends InventoryState {
  List<Inventory> inventory;
  final Page? page;

  InventoryLoadSuccess({required this.inventory, required this.page});

  InventoryLoadSuccess copyWith({
    List<Inventory>? inventory,
    final Page? page,
  }) =>
      InventoryLoadSuccess(
        inventory: inventory ?? this.inventory,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [inventory];
}

class InventoryLoadFailed extends InventoryState {
  final String message;
  InventoryLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//Search

class InventorySearchInProgress extends InventoryState {}

class InventorySearchLoadSuccess extends InventoryState {
  Inventory inventory;

  InventorySearchLoadSuccess({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventorySearchLoadFailed extends InventoryState {
  final String message;
  InventorySearchLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//save
class InventoryFormInitial extends InventoryState {}

class InventoryFormSaveInProgress extends InventoryState {}

class InventoryFormSaveSuccess extends InventoryState {}

class InventoryFormSaveFailure extends InventoryState {
  final String message;
  const InventoryFormSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// upgrade
class InventoryUpdateInitial extends InventoryState {}

class InventoryUpdateInProgress extends InventoryState {}

class InventoryUpdateSuccess extends InventoryState {}

class InventoryUpdateFailure extends InventoryState {
  final String message;
  const InventoryUpdateFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Delete
class InventoryDeleteInitial extends InventoryState {}

class InventoryDeleteInProgress extends InventoryState {}

class InventoryDeleteSuccess extends InventoryState {}

class InventoryDeleteFailure extends InventoryState {
  final String message;
  const InventoryDeleteFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
