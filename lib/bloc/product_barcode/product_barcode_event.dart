part of 'product_barcode_bloc.dart';

abstract class ProductBarcodeEvent extends Equatable {
  const ProductBarcodeEvent();

  @override
  List<Object> get props => [];
}

class ProductBarcodeGet extends ProductBarcodeEvent {
  final String guid;

  const ProductBarcodeGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class ProductBarcodeLoadList extends ProductBarcodeEvent {
  final int limit;
  final int offset;
  final String search;

  const ProductBarcodeLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class ProductBarcodeDelete extends ProductBarcodeEvent {
  final String guid;

  const ProductBarcodeDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class ProductBarcodeDeleteMany extends ProductBarcodeEvent {
  final List<String> guid;

  const ProductBarcodeDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class ProductBarcodeSave extends ProductBarcodeEvent {
  final ProductBarcodeModel productBarcodeModel;

  const ProductBarcodeSave({
    required this.productBarcodeModel,
  });

  @override
  List<Object> get props => [productBarcodeModel];
}

class ProductBarcodeUpdate extends ProductBarcodeEvent {
  final String guid;
  final ProductBarcodeModel productBarcodeModel;

  const ProductBarcodeUpdate({
    required this.guid,
    required this.productBarcodeModel,
  });

  @override
  List<Object> get props => [productBarcodeModel];
}
class ProductBarcodeWithImageSave extends ProductBarcodeEvent {
  final File imageFile;
  final ProductBarcodeModel productBarcodeModel;
  final Uint8List? imageWeb;
  const ProductBarcodeWithImageSave({
    required this.imageWeb,
    required this.imageFile,
    required this.productBarcodeModel,
  });

  @override
  List<Object> get props => [productBarcodeModel, imageFile];
}

class ProductBarcodeWithImageUpdate extends ProductBarcodeEvent {
  final String guid;
  final ProductBarcodeModel productBarcodeModel;
  final File imageFile;
  final Uint8List imageWeb;
  const ProductBarcodeWithImageUpdate({
    required this.guid,
    required this.imageFile,
    required this.imageWeb,
    required this.productBarcodeModel,
  });

  @override
  List<Object> get props =>
      [productBarcodeModel, imageWeb, productBarcodeModel];
}

