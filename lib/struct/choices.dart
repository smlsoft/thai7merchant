import 'package:json_annotation/json_annotation.dart';

part 'choices.g.dart';

@JsonSerializable()
class Choices {
  final String barcode;
  @JsonKey(name: 'default')
  bool isdefault;
  final String itemunit;
  final String name1;
  final String name2;
  final String name3;
  final String name4;
  final String name5;
  double price;
  double qty;
  double qtymax;
  bool selected;
  final String suggestcode;

  Choices({
    String? barcode,
    required this.isdefault,
    String? itemunit,
    String? name1,
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    double? price,
    double? qty,
    double? qtymax,
    required this.selected,
    String? suggestcode,
  })  : barcode = barcode ?? '',
        itemunit = itemunit ?? '',
        name1 = name1 ?? '',
        name2 = name2 ?? '',
        name3 = name3 ?? '',
        name4 = name4 ?? '',
        name5 = name5 ?? '',
        price = price ?? 0,
        qty = qty ?? 0,
        qtymax = qtymax ?? 0,
        suggestcode = suggestcode ?? '';

  factory Choices.fromJson(Map<String, dynamic> json) =>
      _$ChoicesFromJson(json);

  Map<String, dynamic> toJson() => _$ChoicesToJson(this);
}
