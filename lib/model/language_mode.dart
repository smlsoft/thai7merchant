import 'package:json_annotation/json_annotation.dart';

part 'language_mode.g.dart';

@JsonSerializable(explicitToJson: true)
class LanguageMode {
  String code;
  String name;
  bool use;
  bool isauto;

  LanguageMode(
      {this.code = "", this.name = "", this.use = false, this.isauto = false});

  factory LanguageMode.fromJson(Map<String, dynamic> json) =>
      _$LanguageModeFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageModeToJson(this);
}
