part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryGet extends CategoryEvent {
  final String guid;

  const CategoryGet({required this.guid});

  @override
  List<Object> get props => [guid];
}

class CategoryLoadList extends CategoryEvent {
  final int limit;
  final int offset;
  final String search;

  const CategoryLoadList(
      {required this.offset, required this.limit, required this.search});

  @override
  List<Object> get props => [];
}

class CategoryDelete extends CategoryEvent {
  final String guid;

  const CategoryDelete({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CategoryDeleteMany extends CategoryEvent {
  final List<String> guid;

  const CategoryDeleteMany({
    required this.guid,
  });

  @override
  List<Object> get props => [guid];
}

class CategorySave extends CategoryEvent {
  final CategoryModel categoryModel;

  const CategorySave({
    required this.categoryModel,
  });

  @override
  List<Object> get props => [categoryModel];
}

class CategoryUpdate extends CategoryEvent {
  final String guid;
  final CategoryModel categoryModel;

  const CategoryUpdate({
    required this.guid,
    required this.categoryModel,
  });

  @override
  List<Object> get props => [categoryModel];
}
