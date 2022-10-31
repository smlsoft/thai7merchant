part of 'product_barcode_bloc.dart';

abstract class ProductBarcodeState extends Equatable {
  const ProductBarcodeState();

  @override
  List<Object> get props => [];
}

class ProductBarcodeInitial extends ProductBarcodeState {}

class ProductBarcodeInProgress extends ProductBarcodeState {}

class ProductBarcodeLoadSuccess extends ProductBarcodeState {
  final List<ProductBarcodeModel> productbarcodes;

  const ProductBarcodeLoadSuccess({required this.productbarcodes});

  ProductBarcodeLoadSuccess copyWith({
    List<ProductBarcodeModel>? productbarcodes,
  }) =>
      ProductBarcodeLoadSuccess(productbarcodes: productbarcodes ?? this.productbarcodes);

  @override
  List<Object> get props => [productbarcodes];
}

class ProductBarcodeLoadFailed extends ProductBarcodeState {
  final String message;

  const ProductBarcodeLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ProductBarcodeSaveInitial extends ProductBarcodeState {}

class ProductBarcodeSaveInProgress extends ProductBarcodeState {}

class ProductBarcodeSaveSuccess extends ProductBarcodeState {}

class ProductBarcodeSaveFailed extends ProductBarcodeState {
  final String message;

  const ProductBarcodeSaveFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ProductBarcodeDeleteInProgress extends ProductBarcodeState {}

class ProductBarcodeDeleteSuccess extends ProductBarcodeState {}

class ProductBarcodeDeleteFailed extends ProductBarcodeState {}

class ProductBarcodeDeleteManyInProgress extends ProductBarcodeState {}

class ProductBarcodeDeleteManySuccess extends ProductBarcodeState {}

class ProductBarcodeDeleteManyFailed extends ProductBarcodeState {}

class ProductBarcodeGetInProgress extends ProductBarcodeState {}

class ProductBarcodeGetSuccess extends ProductBarcodeState {
  final ProductBarcodeModel productbarcode;

  const ProductBarcodeGetSuccess({required this.productbarcode});

  ProductBarcodeGetSuccess copyWith({
    ProductBarcodeModel? productbarcode,
  }) =>
      ProductBarcodeGetSuccess(productbarcode: productbarcode ?? this.productbarcode);

  @override
  List<Object> get props => [productbarcode];
}

class ProductBarcodeGetFailed extends ProductBarcodeState {
  final String message;

  const ProductBarcodeGetFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ProductBarcodeUpdateInitial extends ProductBarcodeState {}

class ProductBarcodeUpdateInProgress extends ProductBarcodeState {}

class ProductBarcodeUpdateSuccess extends ProductBarcodeState {}

class ProductBarcodeUpdateFailed extends ProductBarcodeState {
  final String message;

  const ProductBarcodeUpdateFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
