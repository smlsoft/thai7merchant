// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      guidfixed: json['guidfixed'] as String,
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      personaltype: json['personaltype'] as int,
      addressforbilling: CustomerAddressModel.fromJson(
          json['addressforbilling'] as Map<String, dynamic>),
      addressforshipping: (json['addressforshipping'] as List<dynamic>)
          .map((e) => CustomerAddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ImagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxid: json['taxid'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'personaltype': instance.personaltype,
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'addressforbilling': instance.addressforbilling.toJson(),
      'addressforshipping':
          instance.addressforshipping.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'taxid': instance.taxid,
      'email': instance.email,
    };

CustomerAddressModel _$CustomerAddressModelFromJson(
        Map<String, dynamic> json) =>
    CustomerAddressModel(
      address:
          (json['address'] as List<dynamic>).map((e) => e as String).toList(),
      countryCode: json['countryCode'] as String,
      provincecode: json['provincecode'] as String,
      districtcode: json['districtcode'] as String,
      subDistrictcode: json['subDistrictcode'] as String,
      zipcode: json['zipcode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      contactnames: (json['contactnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phoneprimary: json['phoneprimary'] as String,
      phonesecondary: json['phonesecondary'] as String,
    )..guid = json['guid'] as String;

Map<String, dynamic> _$CustomerAddressModelToJson(
        CustomerAddressModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'address': instance.address,
      'countryCode': instance.countryCode,
      'provincecode': instance.provincecode,
      'districtcode': instance.districtcode,
      'subDistrictcode': instance.subDistrictcode,
      'zipcode': instance.zipcode,
      'contactnames': instance.contactnames.map((e) => e.toJson()).toList(),
      'phoneprimary': instance.phoneprimary,
      'phonesecondary': instance.phonesecondary,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
