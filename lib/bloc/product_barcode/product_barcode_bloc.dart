import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:thai7merchant/model/product_barcode_struct.dart';
import 'package:thai7merchant/model/upload_image_model.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/repositories/product_barcode_repository.dart';

part 'product_barcode_event.dart';
part 'product_barcode_state.dart';

class ProductBarcodeBloc
    extends Bloc<ProductBarcodeEvent, ProductBarcodeState> {
  final ProductBarcodeRepository _productBarcodeRepository;

  ProductBarcodeBloc(
      {required ProductBarcodeRepository productBarcodeRepository})
      : _productBarcodeRepository = productBarcodeRepository,
        super(ProductBarcodeInitial()) {
    on<ProductBarcodeLoadList>(onProductBarcodeLoad);
    on<ProductBarcodeSave>(onProductBarcodeSave);
    on<ProductBarcodeUpdate>(onProductBarcodeUpdate);
    on<ProductBarcodeDelete>(productbarcodeDelete);
    on<ProductBarcodeDeleteMany>(productbarcodeDeleteMany);
    on<ProductBarcodeGet>(onProductBarcodeGet);
    on<ProductBarcodeWithImageSave>(onProductBarcodeWithImageSave);
  }

  void onProductBarcodeLoad(
      ProductBarcodeLoadList event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeInProgress());

    try {
      final results = await _productBarcodeRepository.getProductBarcodeList(
          offset: event.offset, limit: event.limit, search: event.search);

      if (results.success) {
        List<ProductBarcodeModel> productbarcodes = (results.data as List)
            .map((productbarcode) =>
                ProductBarcodeModel.fromJson(productbarcode))
            .toList();
        emit(ProductBarcodeLoadSuccess(productbarcodes: productbarcodes));
      } else {
        emit(const ProductBarcodeLoadFailed(
            message: 'ProductBarcode Not Found'));
      }
    } catch (e) {
      emit(ProductBarcodeLoadFailed(message: e.toString()));
    }
  }

  void productbarcodeDelete(
      ProductBarcodeDelete event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeDeleteInProgress());
    try {
      await _productBarcodeRepository.deleteProductBarcode(event.guid);

      emit(ProductBarcodeDeleteSuccess());
    } catch (e) {
      // emit(ProductBarcodeDeleteFailure(message: e.toString()));
    }
  }

  void productbarcodeDeleteMany(
      ProductBarcodeDeleteMany event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeDeleteManyInProgress());
    try {
      await _productBarcodeRepository.deleteProductBarcodeMany(event.guid);

      emit(ProductBarcodeDeleteManySuccess());
    } catch (e) {
      // emit(ProductBarcodeDeleteFailure(message: e.toString()));
    }
  }

  void onProductBarcodeSave(
      ProductBarcodeSave event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeSaveInProgress());
    try {
      await _productBarcodeRepository
          .saveProductBarcode(event.productBarcodeModel);
      emit(ProductBarcodeSaveSuccess());
    } catch (e) {
      emit(ProductBarcodeSaveFailed(message: e.toString()));
    }
  }

  void onProductBarcodeUpdate(
      ProductBarcodeUpdate event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeUpdateInProgress());
    try {
      await _productBarcodeRepository.updateProductBarcode(
          event.guid, event.productBarcodeModel);
      emit(ProductBarcodeUpdateSuccess());
    } catch (e) {
      emit(ProductBarcodeUpdateFailed(message: e.toString()));
    }
  }

  void onProductBarcodeGet(
      ProductBarcodeGet event, Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeGetInProgress());
    try {
      final result =
          await _productBarcodeRepository.getProductBarcode(event.guid);
      if (result.success) {
        ProductBarcodeModel productbarcode =
            ProductBarcodeModel.fromJson(result.data);
        emit(ProductBarcodeGetSuccess(productbarcode: productbarcode));
      } else {
        emit(
            const ProductBarcodeGetFailed(message: 'ProductBarcode Not Found'));
      }
    } catch (e) {
      // emit(ProductBarcodeDeleteFailure(message: e.toString()));
    }
  }

  void onProductBarcodeWithImageSave(ProductBarcodeWithImageSave event,
      Emitter<ProductBarcodeState> emit) async {
    emit(ProductBarcodeSaveInProgress());
    try {
      ApiResponse result = await _productBarcodeRepository.uploadImage(
          event.imageFile, event.imageWeb!);
      if (result.success) {
        UploadImageModel uploadImage = UploadImageModel.fromJson(result.data);
        ProductBarcodeModel productBarcodeModel = event.productBarcodeModel;
        productBarcodeModel.imageuri = uploadImage.uri;
        await _productBarcodeRepository.saveProductBarcode(productBarcodeModel);
        emit(ProductBarcodeSaveSuccess());
      } else {
        emit(ProductBarcodeSaveFailed(message: result.message));
      }
    } catch (e) {
      emit(ProductBarcodeSaveFailed(message: e.toString()));
    }
  }
}
