import 'package:thai7merchant/model/image_upload.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  String guidfixed;
  String parentGuid;
  String parentGuidAll;
  String name1;
  String name2;
  String name3;
  String name4;
  String name5;
  String image;
  int childCount = 0;

  CategoryModel({
    required this.guidfixed,
    required this.parentGuid,
    String? parentGuidAll,
    required this.name1,
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? image,
  })  : parentGuidAll = parentGuidAll ?? '',
        name2 = name2 ?? '',
        name3 = name3 ?? '',
        name4 = name4 ?? '',
        name5 = name5 ?? '',
        image = image ?? '';

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
