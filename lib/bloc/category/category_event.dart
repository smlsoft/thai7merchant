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

class CategoryUpdateXOrder extends CategoryEvent {
  final List<XSortModel> orderList;

  const CategoryUpdateXOrder({
    required this.orderList,
  });

  @override
  List<Object> get props => [List<XSortModel>];
}

class CategoryWithImageSave extends CategoryEvent {
  final File imageFile;
  final CategoryModel categoryModel;
  final Uint8List? imageWeb;
  const CategoryWithImageSave({
    required this.imageWeb,
    required this.imageFile,
    required this.categoryModel,
  });

  @override
  List<Object> get props => [categoryModel, imageFile];
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

class CategoryWithImageUpdate extends CategoryEvent {
  final String guid;
  final CategoryModel categoryModel;
  final File imageFile;
  final Uint8List imageWeb;
  const CategoryWithImageUpdate({
    required this.guid,
    required this.imageFile,
    required this.imageWeb,
    required this.categoryModel,
  });

  @override
  List<Object> get props => [categoryModel, imageWeb, categoryModel];
}
