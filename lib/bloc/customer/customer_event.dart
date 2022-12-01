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

class CustomerWithImageSave extends CustomerEvent {
  final List<File> imageFile;
  final CustomerModel customerModel;
  final List<Uint8List> imageWeb;
  const CustomerWithImageSave({
    required this.imageWeb,
    required this.imageFile,
    required this.customerModel,
  });

  @override
  List<Object> get props => [customerModel, imageFile];
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

class CustomerWithImageUpdate extends CustomerEvent {
  final String guid;
  final CustomerModel customerModel;
  final List<File> imageFile;
  final List<Uint8List> imageWeb;
  final List<ImagesModel> imagesUri;

  const CustomerWithImageUpdate({
    required this.guid,
    required this.customerModel,
    required this.imageFile,
    required this.imageWeb,
    required this.imagesUri,
  });

  @override
  List<Object> get props => [customerModel];
}
