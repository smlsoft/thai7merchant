// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'printer_model.g.dart';

@JsonSerializable()
class PrinterModel {
  late String guidfixed;
  late String code;
  late String name1;
  late int type;
  late String address;

  PrinterModel(
      {required this.guidfixed,
      required this.code,
      required this.name1,
      required this.address,
      required this.type});

  factory PrinterModel.fromJson(Map<String, dynamic> json) =>
      _$PrinterModelFromJson(json);
  Map<String, dynamic> toJson() => _$PrinterModelToJson(this);
}
