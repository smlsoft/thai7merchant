part of 'customer_group_bloc.dart';


abstract class CustomerGroupEvent extends Equatable {
  const CustomerGroupEvent();

  @override
  List<Object> get props => [];
}

class CustomerGroupGet extends CustomerGroupEvent {
  final String guid;

  const CustomerGroupGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class CustomerGroupLoadList extends CustomerGroupEvent {
  final int limit;
  final int offset;
  final String search;

  const CustomerGroupLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class CustomerGroupDelete extends CustomerGroupEvent {
  final String guid;

  const CustomerGroupDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CustomerGroupDeleteMany extends CustomerGroupEvent {
  final List<String> guid;

  const CustomerGroupDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CustomerGroupSave extends CustomerGroupEvent {
  final CustomerGroupModel customerGroupModel;

  const CustomerGroupSave({
    required this.customerGroupModel,
  });

  @override
  List<Object> get props => [customerGroupModel];
}

class CustomerGroupUpdate extends CustomerGroupEvent {
  final String guid;
  final CustomerGroupModel customerGroupModel;

  const CustomerGroupUpdate({
    required this.guid,
    required this.customerGroupModel,
  });

  @override
  List<Object> get props => [customerGroupModel];
}
