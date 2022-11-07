import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/language_model.dart';

part 'global_model.g.dart';

class SearchReturnValueModel {
  late String code;
  late List<LanguageDataModel> names;
}

@JsonSerializable(explicitToJson: true)
class SortDataModel {
  String code;
  int xorder;

  SortDataModel({required this.code, required this.xorder});

  factory SortDataModel.fromJson(Map<String, dynamic> json) =>
      _$SortDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortDataModelToJson(this);
}
