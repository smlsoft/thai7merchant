import 'package:json_annotation/json_annotation.dart';

part 'language_model.g.dart';

class LanguageModel {
  String code;
  String name;
  bool use;
  
  LanguageModel({required this.code, required this.name, required this.use});
}

@JsonSerializable(explicitToJson: true)
class LanguageDataModel {
  String code;
  String name;
  bool isauto;

  LanguageDataModel(
      {required this.code, required this.name, required this.isauto});

  factory LanguageDataModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageDataModelToJson(this);
}
