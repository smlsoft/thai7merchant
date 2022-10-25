import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_model.dart';

part 'unit.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitModel {
  String unitcode;
  String guidfixed;
  List<LanguageDataModel> names = <LanguageDataModel>[];

  UnitModel({
    required this.guidfixed,
    required this.unitcode,
    List<LanguageDataModel>? names,
  }) : names = names ?? <LanguageDataModel>[];

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
