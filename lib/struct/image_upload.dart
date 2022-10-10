import 'package:json_annotation/json_annotation.dart';

part 'image_upload.g.dart';

@JsonSerializable()
class ImageUpload {
  String uri;

  ImageUpload({
    required this.uri,
  });

  factory ImageUpload.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadToJson(this);
}
