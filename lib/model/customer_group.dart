import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_model.dart';

part 'customer_group.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerGroupModel {
  String guidfixed;
  /// รหัสกลุ่มลูกค้า
  String code;
  /// ชื่อกลุ่มลูกค้า
  List<LanguageDataModel> names = <LanguageDataModel>[];
  

  CustomerGroupModel({
    required this.guidfixed,
    required this.code,
    List<LanguageDataModel>? names,
  }) : names = names ?? <LanguageDataModel>[];

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerGroupModelToJson(this);
}
