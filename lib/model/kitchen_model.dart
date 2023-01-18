// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'kitchen_model.g.dart';

@JsonSerializable()
class KitchenModel {
  late String guidfixed;
  late String code;
  late String name1;
  late List<String> printers;
  late List<String> products;
  late List<String> zones;

  KitchenModel(
      {required this.guidfixed,
      required this.code,
      required this.name1,
      required this.printers,
      required this.products,
      required this.zones});

  factory KitchenModel.fromJson(Map<String, dynamic> json) =>
      _$KitchenModelFromJson(json);
  Map<String, dynamic> toJson() => _$KitchenModelToJson(this);
}
