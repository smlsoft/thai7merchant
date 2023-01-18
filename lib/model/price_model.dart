import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/global_model.dart';

part 'price_model.g.dart';

class PriceModel {
  int keynumber;
  List<LanguageModel> names;
  bool isuse;

  PriceModel(
      {required this.keynumber, required this.isuse, required this.names});
}

@JsonSerializable(explicitToJson: true)
class PriceDataModel {
  int keynumber;
  String price;

  PriceDataModel({required this.keynumber, required this.price});

  factory PriceDataModel.fromJson(Map<String, dynamic> json) =>
      _$PriceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceDataModelToJson(this);
}
