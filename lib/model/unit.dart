import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_mode.dart';

part 'unit.g.dart';

@JsonSerializable(explicitToJson: true)
class UnitModel {
  String unitcode;
  List<LanguageMode> names = <LanguageMode>[];

  UnitModel({
    required this.unitcode,
    List<LanguageMode>? names,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
