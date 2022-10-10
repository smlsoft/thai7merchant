// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      guidfixed: json['guidfixed'] as String?,
      name1: json['name1'] as String,
      name2: json['name2'] as String?,
      name3: json['name3'] as String?,
      name4: json['name4'] as String?,
      name5: json['name5'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'name1': instance.name1,
      'name2': instance.name2,
      'name3': instance.name3,
      'name4': instance.name4,
      'name5': instance.name5,
      'image': instance.image,
    };
