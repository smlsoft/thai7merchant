import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<ListCategoryLoadDropDown>(_onCategoryLoadDropDown);
    on<ListCategoryLoad>(_onCategoryLoad);
    on<ListCategoryLoadById>(_onGetCategoryId);
    on<CategorySaved>(_onCategorySaved);
    on<CategoryUpdate>(_onCategoryUpdate);
    on<CategoryDelete>(_onCategoryDelete);
  }

  void _onCategoryLoadDropDown(
      ListCategoryLoadDropDown event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadDropDownInProgress());
    try {
      final _result = await _categoryRepository.getCategoryList();

      List<CategoryModel> _category = (_result.data as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList();
      emit(CategoryLoadDropDownSuccess(_category));
    } catch (e) {
      emit(CategoryLoadDropDownFailure(message: e.toString()));
    }
  }

  void _onCategoryLoad(
      ListCategoryLoad event, Emitter<CategoryState> emit) async {
    CategoryLoadSuccess categoryLoadSuccess;
    List<CategoryModel> _previousCategory = [];
    if (state is CategoryLoadSuccess) {
      categoryLoadSuccess = (state as CategoryLoadSuccess).copyWith();
      _previousCategory = categoryLoadSuccess.category;
    }
    emit(CategoryInProgress());

    try {
      final _result = await _categoryRepository.getCategoryList(
          perPage: event.perPage, page: event.page, search: event.search);

      if (_result.success) {
        if (event.nextPage) {
          List<CategoryModel> _category = (_result.data as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList();
          // print(_category);
          emit(CategoryLoadSuccess(category: _category, page: _result.page));
        } else {
          List<CategoryModel> _category = (_result.data as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList();
          // print(_category);
          _previousCategory.addAll(_category);
          emit(CategoryLoadSuccess(
              category: _previousCategory, page: _result.page));
        }
      } else {
        emit(CategoryLoadFailed(message: 'Category Not Found'));
      }
    } catch (e) {
      emit(CategoryLoadFailed(message: e.toString()));
    }
  }

  void _onGetCategoryId(
      ListCategoryLoadById event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadByIdInProgress());
    try {
      final _result = await _categoryRepository.getCategoryId(event.id);

      if (_result.success) {
        CategoryModel _category = CategoryModel.fromJson(_result.data);
        // print(_category);
        emit(CategoryLoadByIdLoadSuccess(category: _category));
      } else {
        emit(CategoryLoadByIdLoadFailed(message: 'Category Not Found'));
      }
    } catch (e) {
      emit(CategoryLoadByIdLoadFailed(message: e.toString()));
    }
  }

  void _onCategorySaved(
      CategorySaved event, Emitter<CategoryState> emit) async {
    emit(CategoryFormSaveInProgress());
    try {
      // print(event.inventory.toString());

      await _categoryRepository.saveCategory(event.category);
      // print('Success');
      emit(CategoryFormSaveSuccess());
    } catch (e) {
      emit(CategoryFormSaveFailure(message: e.toString()));
    }
  }

  void _onCategoryUpdate(
      CategoryUpdate event, Emitter<CategoryState> emit) async {
    emit(CategoryUpdateInProgress());
    try {
      // print(event.inventory.toString());

      await _categoryRepository.updateCategory(event.category);

      emit(CategoryUpdateSuccess());
    } catch (e) {
      emit(CategoryUpdateFailure(message: e.toString()));
    }
  }

  void _onCategoryDelete(
      CategoryDelete event, Emitter<CategoryState> emit) async {
    emit(CategoryDeleteInProgress());
    try {
      // print(event.inventory.toString());

      await _categoryRepository.deleteCategory(event.id);

      emit(CategoryDeleteSuccess());
    } catch (e) {
      emit(CategoryDeleteFailure(message: e.toString()));
    }
  }
}
