import 'package:thai7merchant/model/language_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thai7merchant/model/product_option_struct.dart';

part 'product_barcode_struct.g.dart';

@JsonSerializable()
class ProductBarcodeModel {
  /// guid ฐานข้อมูล
  String guidfixed;

  /// รหัสสินค้า
  String itemcode;

  /// guid กลุ่มสินค้า
  String categoryguid;

  /// Barcode
  String barcode;

  /// ชื่อสินค้า
  List<LanguageDataModel> names;

  /// รหัสหน่วยนับ
  String itemunitcode;

  /// ชื่อหน่วยนับ
  List<LanguageDataModel> itemunitnames;

  /// ราคาขาย (10 แถว)
  List<double> price;

  /// uri รูปภาพ
  String imageuri;

  /// ข้อเลือกสินค้า (เช่น เพิ่มไข่)
  List<ProductOptionModel> options;

  ProductBarcodeModel({
    required this.guidfixed,
    required this.categoryguid,
    required this.barcode,
    required this.names,
    required this.itemcode,
    required this.itemunitcode,
    required this.itemunitnames,
    required this.price,
    required this.imageuri,
    required this.options,
  });

  factory ProductBarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBarcodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBarcodeModelToJson(this);
}
