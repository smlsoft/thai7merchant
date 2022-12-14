import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_mode.dart';

part 'unit.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitModel {
  String unitcode;
  String guidfixed;
  List<LanguageMode> names = <LanguageMode>[];

  UnitModel({
    required this.guidfixed,
    required this.unitcode,
    List<LanguageMode>? names,
  }) : names = names ?? <LanguageMode>[];

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
