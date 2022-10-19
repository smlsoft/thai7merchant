// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      guidfixed: json['guidfixed'] as String,
      parentGuid: json['parentGuid'] as String,
      parentGuidAll: json['parentGuidAll'] as String?,
      name1: json['name1'] as String,
      name2: json['name2'] as String?,
      name3: json['name3'] as String?,
      name4: json['name4'] as String?,
      name5: json['name5'] as String?,
      image: json['image'] as String?,
    )..childCount = json['childCount'] as int;

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'parentGuid': instance.parentGuid,
      'parentGuidAll': instance.parentGuidAll,
      'name1': instance.name1,
      'name2': instance.name2,
      'name3': instance.name3,
      'name4': instance.name4,
      'name5': instance.name5,
      'image': instance.image,
      'childCount': instance.childCount,
    };
