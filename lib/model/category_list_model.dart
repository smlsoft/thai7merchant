import 'package:thai7merchant/model/category_model.dart';

class CategoryListModel {
  late CategoryModel detail;
  late List<CategoryListModel> childCategorys;
  late bool isExpand = true;

  CategoryListModel({
    required this.detail,
    required this.childCategorys,
  });
}
