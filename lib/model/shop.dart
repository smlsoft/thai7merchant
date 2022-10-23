import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop {
  String shopid;
  String name;
  String role;

  Shop({required this.shopid, required this.name, required this.role});

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson() => _$ShopToJson(this);
}
