part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class ListInventoryLoad extends InventoryEvent {
  int page;
  int perPage;
  String search;
  bool nextPage;

  ListInventoryLoad(
      {required this.page,
      required this.perPage,
      required this.search,
      required this.nextPage});

  @override
  List<Object> get props => [];
}

class ListInventoryById extends InventoryEvent {
  String id;
  ListInventoryById({required this.id});

  @override
  List<Object> get props => [];
}

class InventorySaved extends InventoryEvent {
  final Inventory inventory;

  const InventorySaved({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventoryUpdate extends InventoryEvent {
  final Inventory inventory;

  const InventoryUpdate({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventoryDelete extends InventoryEvent {
  final String id;

  const InventoryDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
