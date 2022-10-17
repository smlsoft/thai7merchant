import 'package:thai7merchant/model/choices.dart';
import 'package:json_annotation/json_annotation.dart';

part 'option.g.dart';

@JsonSerializable()
class Option {
  final String guidfixed;
  int choicetype = 0;
  final String code;
  int maxselect = 0;
  final String name1;
  final String name2;
  final String name3;
  final String name4;
  final String name5;
  @JsonKey(name: 'required')
  bool isrequired;
  List<Choices> choices = <Choices>[];

  Option({
    String? guidfixed,
    required this.choicetype,
    required this.code,
    required this.maxselect,
    required this.name1,
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    required this.isrequired,
    List<Choices>? choices,
  })  : guidfixed = guidfixed ?? '',
        name2 = name2 ?? '',
        name3 = name3 ?? '',
        name4 = name4 ?? '',
        name5 = name5 ?? '',
        choices = choices ?? <Choices>[];

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
