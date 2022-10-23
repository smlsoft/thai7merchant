part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryLoadDropDownInitial extends CategoryState {}

class CategoryLoadDropDownInProgress extends CategoryState {}

class CategoryLoadDropDownSuccess extends CategoryState {
  final List<CategoryModel> category;

  const CategoryLoadDropDownSuccess([this.category = const []]);

  @override
  List<Object> get props => [category];
}

class CategoryLoadDropDownFailure extends CategoryState {
  final String message;
  const CategoryLoadDropDownFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//Load

class CategoryInitial extends CategoryState {}

class CategoryInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  List<CategoryModel> category;
  final Page? page;

  CategoryLoadSuccess({required this.category, required this.page});

  CategoryLoadSuccess copyWith({
    List<CategoryModel>? category,
    final Page? page,
  }) =>
      CategoryLoadSuccess(
        category: category ?? this.category,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [category];
}

class CategoryLoadFailed extends CategoryState {
  final String message;
  CategoryLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//loadby ID

class CategoryLoadByIdInProgress extends CategoryState {}

class CategoryLoadByIdLoadSuccess extends CategoryState {
  CategoryModel category;

  CategoryLoadByIdLoadSuccess({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class CategoryLoadByIdLoadFailed extends CategoryState {
  final String message;
  CategoryLoadByIdLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//save
class CategoryFormInitial extends CategoryState {}

class CategoryFormSaveInProgress extends CategoryState {}

class CategoryFormSaveSuccess extends CategoryState {}

class CategoryFormSaveFailure extends CategoryState {
  final String message;
  const CategoryFormSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// update
class CategoryUpdateInitial extends CategoryState {}

class CategoryUpdateInProgress extends CategoryState {}

class CategoryUpdateSuccess extends CategoryState {}

class CategoryUpdateFailure extends CategoryState {
  final String message;
  const CategoryUpdateFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Delete
class CategoryDeleteInitial extends CategoryState {}

class CategoryDeleteInProgress extends CategoryState {}

class CategoryDeleteSuccess extends CategoryState {}

class CategoryDeleteFailure extends CategoryState {
  final String message;
  const CategoryDeleteFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
