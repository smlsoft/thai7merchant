import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thai7merchant/model/global_model.dart';
import 'package:thai7merchant/model/master_model.dart';
import 'package:thai7merchant/repositories/category_repository.dart';
import 'package:thai7merchant/repositories/client.dart';
import 'package:thai7merchant/model/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitial()) {
    on<CategoryLoadList>(onCategoryLoad);
    on<CategorySave>(onCategorySave);
    on<CategoryWithImageSave>(onCategoryWithImageSave);
    on<CategoryUpdate>(onCategoryUpdate);
    on<CategoryWithImageUpdate>(onCategoryWithImageUpdate);
    on<CategoryDelete>(categoryDelete);
    on<CategoryDeleteMany>(categoryDeleteMany);
    on<CategoryGet>(onCategoryGet);
    on<CategoryUpdateXOrder>(onCategoryUpdateXOrder);
  }

  void onCategoryLoad(
      CategoryLoadList event, Emitter<CategoryState> emit) async {
    emit(CategoryInProgress());

    try {
      final results = await _categoryRepository.getCategoryList(
          offset: event.offset, limit: event.limit, search: event.search);

      if (results.success) {
        List<CategoryModel> categorys = (results.data as List)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        emit(CategoryLoadSuccess(categorys: categorys));
      } else {
        emit(const CategoryLoadFailed(message: 'Category Not Found'));
      }
    } catch (e) {
      emit(CategoryLoadFailed(message: e.toString()));
    }
  }

  void categoryDelete(CategoryDelete event, Emitter<CategoryState> emit) async {
    emit(CategoryDeleteInProgress());
    try {
      await _categoryRepository.deleteCategory(event.guid);

      emit(CategoryDeleteSuccess());
    } catch (e) {
      // emit(CategoryDeleteFailure(message: e.toString()));
    }
  }

  void categoryDeleteMany(
      CategoryDeleteMany event, Emitter<CategoryState> emit) async {
    emit(CategoryDeleteManyInProgress());
    try {
      await _categoryRepository.deleteCategoryMany(event.guid);

      emit(CategoryDeleteManySuccess());
    } catch (e) {
      // emit(CategoryDeleteFailure(message: e.toString()));
    }
  }

  void onCategoryWithImageSave(
      CategoryWithImageSave event, Emitter<CategoryState> emit) async {
    emit(CategorySaveInProgress());
    try {
      ApiResponse result = await _categoryRepository.uploadImage(
          event.imageFile, event.imageWeb!);
      if (result.success) {
        UploadImageModel uploadImage = UploadImageModel.fromJson(result.data);
        CategoryModel categoryModel = event.categoryModel;
        categoryModel.imageuri = uploadImage.uri;
        await _categoryRepository.saveCategory(categoryModel);
        emit(CategorySaveSuccess());
      } else {
        emit(CategorySaveFailed(message: result.message));
      }
    } catch (e) {
      emit(CategorySaveFailed(message: e.toString()));
    }
  }

  void onCategorySave(CategorySave event, Emitter<CategoryState> emit) async {
    emit(CategorySaveInProgress());
    try {
      await _categoryRepository.saveCategory(event.categoryModel);
      emit(CategorySaveSuccess());
    } catch (e) {
      emit(CategorySaveFailed(message: e.toString()));
    }
  }

  void onCategoryUpdateXOrder(
      CategoryUpdateXOrder event, Emitter<CategoryState> emit) async {
    try {
      await _categoryRepository.updateCategoryXOrder(event.orderList);
    } catch (_) {}
  }

  void onCategoryUpdate(
      CategoryUpdate event, Emitter<CategoryState> emit) async {
    emit(CategoryUpdateInProgress());
    try {
      await _categoryRepository.updateCategory(event.guid, event.categoryModel);
      emit(CategoryUpdateSuccess());
    } catch (e) {
      emit(CategoryUpdateFailed(message: e.toString()));
    }
  }

  void onCategoryWithImageUpdate(
      CategoryWithImageUpdate event, Emitter<CategoryState> emit) async {
    emit(CategoryUpdateInProgress());
    try {
      ApiResponse result = await _categoryRepository.uploadImage(
          event.imageFile, event.imageWeb);
      if (result.success) {
        UploadImageModel uploadImage = UploadImageModel.fromJson(result.data);
        CategoryModel categoryModel = CategoryModel(
          guidfixed: event.categoryModel.guidfixed,
          parentguid: event.categoryModel.parentguid,
          parentguidall: event.categoryModel.parentguidall,
          imageuri: uploadImage.uri,
          childcount: event.categoryModel.childcount,
          colorselect: event.categoryModel.colorselect,
          colorselecthex: event.categoryModel.colorselecthex,
          useimageorcolor: event.categoryModel.useimageorcolor,
          names: event.categoryModel.names,
          xsorts: event.categoryModel.xsorts,
          barcodes: event.categoryModel.barcodes,
        );
        await _categoryRepository.updateCategory(event.guid, categoryModel);
        emit(CategoryUpdateSuccess());
      } else {
        emit(CategoryUpdateFailed(message: result.message));
      }
    } catch (e) {
      emit(CategoryUpdateFailed(message: e.toString()));
    }
  }

  void onCategoryGet(CategoryGet event, Emitter<CategoryState> emit) async {
    emit(CategoryGetInProgress());
    try {
      final result = await _categoryRepository.getCategory(event.guid);
      if (result.success) {
        CategoryModel category = CategoryModel.fromJson(result.data);
        emit(CategoryGetSuccess(category: category));
      } else {
        emit(const CategoryGetFailed(message: 'Category Not Found'));
      }
    } catch (e) {
      // emit(CategoryDeleteFailure(message: e.toString()));
    }
  }
}
