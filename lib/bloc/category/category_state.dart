part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<CategoryModel> categorys;

  const CategoryLoadSuccess({required this.categorys});

  CategoryLoadSuccess copyWith({
    List<CategoryModel>? categorys,
  }) =>
      CategoryLoadSuccess(categorys: categorys ?? this.categorys);

  @override
  List<Object> get props => [categorys];
}

class CategoryLoadFailed extends CategoryState {
  final String message;

  const CategoryLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class CategorySaveInitial extends CategoryState {}

class CategorySaveInProgress extends CategoryState {}

class CategorySaveSuccess extends CategoryState {}

class CategorySaveFailed extends CategoryState {
  final String message;

  const CategorySaveFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class CategoryDeleteInProgress extends CategoryState {}

class CategoryDeleteSuccess extends CategoryState {}

class CategoryDeleteFailed extends CategoryState {}

class CategoryDeleteManyInProgress extends CategoryState {}

class CategoryDeleteManySuccess extends CategoryState {}

class CategoryDeleteManyFailed extends CategoryState {}

class CategoryGetInProgress extends CategoryState {}

class CategoryGetSuccess extends CategoryState {
  final CategoryModel category;

  const CategoryGetSuccess({required this.category});

  CategoryGetSuccess copyWith({
    CategoryModel? category,
  }) =>
      CategoryGetSuccess(category: category ?? this.category);

  @override
  List<Object> get props => [category];
}

class CategoryGetFailed extends CategoryState {
  final String message;

  const CategoryGetFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class CategoryUpdateInitial extends CategoryState {}

class CategoryUpdateInProgress extends CategoryState {}

class CategoryUpdateSuccess extends CategoryState {}

class CategoryUpdateFailed extends CategoryState {
  final String message;

  const CategoryUpdateFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
