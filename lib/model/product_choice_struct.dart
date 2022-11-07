import 'package:thai7merchant/model/language_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_choice_struct.g.dart';

/// ข้อเลือกย่อยสินค้า
@JsonSerializable(explicitToJson: true)
class ProductChoiceModel {
  String guid;

  /// ชื่อข้อเลือกย่อย
  List<LanguageDataModel> names;

  /// ราคาข้อเลือกย่อย (เพิ่ม)
  double price;

  /// ตัดสต๊อกสินค้า
  bool isstock;

  /// อ้างอิง Barcode
  String refbarcode;

  /// อ้างอิงสินค้า เพื่อตัดสต๊อก
  String refproductcode;

  /// อ้างอิงหน่วยนับ เพื่อตัดสต๊อก
  String refunitcode;

  /// จำนวนเพื่อตัดสต๊อก
  double qty;

  ProductChoiceModel({
    required this.guid,
    required this.refbarcode,
    required this.refproductcode,
    required this.refunitcode,
    required this.names,
    required this.isstock,
    required this.price,
    required this.qty,
  });

  factory ProductChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductChoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductChoiceModelToJson(this);
}
