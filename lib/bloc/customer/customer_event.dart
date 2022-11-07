part of 'customer_bloc.dart';


abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class CustomerGet extends CustomerEvent {
  final String guid;

  const CustomerGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class CustomerLoadList extends CustomerEvent {
  final int limit;
  final int offset;
  final String search;

  const CustomerLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class CustomerDelete extends CustomerEvent {
  final String guid;

  const CustomerDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CustomerDeleteMany extends CustomerEvent {
  final List<String> guid;

  const CustomerDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CustomerSave extends CustomerEvent {
  final CustomerModel customerModel;

  const CustomerSave({
    required this.customerModel,
  });

  @override
  List<Object> get props => [customerModel];
}

class CustomerUpdate extends CustomerEvent {
  final String guid;
  final CustomerModel customerModel;

  const CustomerUpdate({
    required this.guid,
    required this.customerModel,
  });

  @override
  List<Object> get props => [customerModel];
}
