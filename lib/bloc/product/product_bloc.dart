import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:thai7merchant/model/product_struct.dart';
import 'package:thai7merchant/model/master_model.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<ProductLoadList>(onProductLoad);
    on<ProductSave>(onProductSave);
    on<ProductUpdate>(onProductUpdate);
    on<ProductDelete>(onProductDelete);
    on<ProductDeleteMany>(onProductDeleteMany);
    on<ProductGet>(onProductGet);
    on<ProductWithImageSave>(onProductWithImageSave);
  }

  void onProductLoad(ProductLoadList event, Emitter<ProductState> emit) async {
    emit(ProductInProgress());

    try {
      final results = await _productRepository.getProductList(
          offset: event.offset, limit: event.limit, search: event.search);

      if (results.success) {
        List<ProductModel> Products = (results.data as List)
            .map((Product) => ProductModel.fromJson(Product))
            .toList();
        emit(ProductLoadSuccess(products: Products));
      } else {
        emit(const ProductLoadFailed(message: 'Product Not Found'));
      }
    } catch (e) {
      emit(ProductLoadFailed(message: e.toString()));
    }
  }

  void onProductDelete(ProductDelete event, Emitter<ProductState> emit) async {
    emit(ProductDeleteInProgress());
    try {
      await _productRepository.deleteProduct(event.guid);

      emit(ProductDeleteSuccess());
    } catch (e) {
      // emit(ProductDeleteFailure(message: e.toString()));
    }
  }

  void onProductDeleteMany(
      ProductDeleteMany event, Emitter<ProductState> emit) async {
    emit(ProductDeleteManyInProgress());
    try {
      await _productRepository.deleteProductMany(event.guid);

      emit(ProductDeleteManySuccess());
    } catch (e) {
      // emit(ProductDeleteFailure(message: e.toString()));
    }
  }

  void onProductSave(ProductSave event, Emitter<ProductState> emit) async {
    emit(ProductSaveInProgress());
    try {
      await _productRepository.saveProduct(event.productModel);
      emit(ProductSaveSuccess());
    } catch (e) {
      emit(ProductSaveFailed(message: e.toString()));
    }
  }

  void onProductUpdate(ProductUpdate event, Emitter<ProductState> emit) async {
    emit(ProductUpdateInProgress());
    try {
      await _productRepository.updateProduct(event.guid, event.productModel);
      emit(ProductUpdateSuccess());
    } catch (e) {
      emit(ProductUpdateFailed(message: e.toString()));
    }
  }

  void onProductGet(ProductGet event, Emitter<ProductState> emit) async {
    emit(ProductGetInProgress());
    try {
      final result = await _productRepository.getProduct(event.guid);
      if (result.success) {
        ProductModel Product = ProductModel.fromJson(result.data);
        emit(ProductGetSuccess(product: Product));
      } else {
        emit(const ProductGetFailed(message: 'Product Not Found'));
      }
    } catch (e) {
      // emit(ProductDeleteFailure(message: e.toString()));
    }
  }

  void onProductWithImageSave(
      ProductWithImageSave event, Emitter<ProductState> emit) async {
    emit(ProductSaveInProgress());
    try {
      ApiResponse result = await _productRepository.uploadImage(
          event.imageFile, event.imageWeb!);
      if (result.success) {
        /*UploadImageModel uploadImage = UploadImageModel.fromJson(result.data);
        ProductModel productModel = event.ProductModel;
        productModel.imageuri = uploadImage.uri;
        await _productRepository.saveProduct(ProductModel);*/
        emit(ProductSaveSuccess());
      } else {
        emit(ProductSaveFailed(message: result.message));
      }
    } catch (e) {
      emit(ProductSaveFailed(message: e.toString()));
    }
  }
}
