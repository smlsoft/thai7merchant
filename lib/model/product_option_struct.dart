import 'package:thai7merchant/model/language_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/product_choice_struct.dart';

part 'product_option_struct.g.dart';

/// ข้อเลือกพิเศษ
@JsonSerializable()
class ProductOptionModel {
  /// เลือกได้สูงสุด
  int maxselect = 0;

  /// ชื่อข้อเลือกพิเศษ
  List<LanguageDataModel> names;

  /// บังคับเลือก
  bool isrequired;

  /// รายการข้อเลือกย่อย
  List<ProductChoiceModel> choices;

  ProductOptionModel({
    required this.maxselect,
    required this.names,
    required this.isrequired,
    required this.choices,
  });

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ProductOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionModelToJson(this);
}
