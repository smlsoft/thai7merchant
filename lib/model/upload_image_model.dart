import 'package:json_annotation/json_annotation.dart';

part 'upload_image_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadImageModel {
  String uri;

  UploadImageModel({
    required this.uri,
  });

  factory UploadImageModel.fromJson(Map<String, dynamic> json) =>
      _$UploadImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageModelToJson(this);
}
