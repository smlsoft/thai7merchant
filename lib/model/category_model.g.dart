// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      guidfixed: json['guidfixed'] as String,
      parentguid: json['parentguid'] as String,
      parentguidall: json['parentguidall'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageuri: json['imageuri'] as String,
      childcount: json['childcount'] as int,
      xsort: (json['xsort'] as List<dynamic>?)
          ?.map((e) => SortDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      barcodes: (json['barcodes'] as List<dynamic>?)
          ?.map((e) => SortDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'parentguid': instance.parentguid,
      'parentguidall': instance.parentguidall,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'childcount': instance.childcount,
      'imageuri': instance.imageuri,
      'xsort': instance.xsort?.map((e) => e.toJson()).toList(),
      'barcodes': instance.barcodes?.map((e) => e.toJson()).toList(),
    };
