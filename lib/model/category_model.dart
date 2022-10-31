import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_model.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  String guidfixed;
  String parentguid;
  String parentguidall;
  List<LanguageDataModel> names = <LanguageDataModel>[];
  int childcount;
  String imageuri;

  CategoryModel({
    required this.guidfixed,
    required this.parentguid,
    required this.parentguidall,
    required this.names,
    required this.imageuri,
    required this.childcount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
