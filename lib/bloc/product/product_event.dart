part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductGet extends ProductEvent {
  final String guid;

  const ProductGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class ProductLoadList extends ProductEvent {
  final int limit;
  final int offset;
  final String search;

  const ProductLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class ProductDelete extends ProductEvent {
  final String guid;

  const ProductDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class ProductDeleteMany extends ProductEvent {
  final List<String> guid;

  const ProductDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class ProductSave extends ProductEvent {
  final ProductModel productModel;

  const ProductSave({
    required this.productModel,
  });

  @override
  List<Object> get props => [ProductModel];
}

class ProductUpdate extends ProductEvent {
  final String guid;
  final ProductModel productModel;

  const ProductUpdate({
    required this.guid,
    required this.productModel,
  });

  @override
  List<Object> get props => [ProductModel];
}

class ProductWithImageSave extends ProductEvent {
  final List<File> imageFile;
  final ProductModel productModel;
  final List<Uint8List> imageWeb;
  const ProductWithImageSave({
    required this.imageWeb,
    required this.imageFile,
    required this.productModel,
  });

  @override
  List<Object> get props => [ProductModel, imageFile];
}

class ProductWithImageUpdate extends ProductEvent {
  final String guid;
  final ProductModel productModel;
  final List<File> imageFile;
  final List<Uint8List> imageWeb;
  final List<ImagesModel> imagesUri;

  const ProductWithImageUpdate({
    required this.guid,
    required this.productModel,
    required this.imageFile,
    required this.imageWeb,
    required this.imagesUri,
  });

  @override
  List<Object> get props => [productModel];
}
