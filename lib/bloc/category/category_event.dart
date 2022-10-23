part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class ListCategoryLoadDropDown extends CategoryEvent {
  const ListCategoryLoadDropDown();

  @override
  List<Object> get props => [];
}

class ListCategoryLoad extends CategoryEvent {
  int page;
  int perPage;
  String search;
  bool nextPage;

  ListCategoryLoad(
      {required this.page,
      required this.perPage,
      required this.search,
      required this.nextPage});

  @override
  List<Object> get props => [];
}

class ListCategoryLoadById extends CategoryEvent {
  String id;
  ListCategoryLoadById({required this.id});

  @override
  List<Object> get props => [];
}

class CategorySaved extends CategoryEvent {
  final CategoryModel category;

  const CategorySaved({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class CategoryUpdate extends CategoryEvent {
  final CategoryModel category;

  const CategoryUpdate({
    required this.category,
  });

  @override
  List<Object> get props => [category];
}

class CategoryDelete extends CategoryEvent {
  final String id;

  const CategoryDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
