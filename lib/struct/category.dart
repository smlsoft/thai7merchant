import 'package:thai7merchant/struct/image_upload.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  String guidfixed;
  String name1;
  String name2;
  String name3;
  String name4;
  String name5;
  String image;

  Category({
    String? guidfixed,
    required this.name1,
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? image,
  })  : guidfixed = guidfixed ?? '',
        name2 = name2 ?? '',
        name3 = name3 ?? '',
        name4 = name4 ?? '',
        name5 = name5 ?? '',
        image = image ?? '';

  String toShowLabel() {
    if (guidfixed != '') {
      return name1;
    } else {
      return '';
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
