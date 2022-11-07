import 'package:thai7merchant/model/category_model.dart';

class CategoryListModel {
  late CategoryModel detail;
  late List<CategoryListModel> childCategorys;
  late bool isExpand = true;
  late bool isMoveUp = false;
  late bool isMoveDown = false;

  CategoryListModel({
    required this.detail,
    required this.childCategorys,
  });
}
