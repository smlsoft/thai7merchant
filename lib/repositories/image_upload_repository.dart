import 'dart:convert';

import 'package:thai7merchant/struct/image_upload.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class ImageUploadRepository {
  Future<ApiResponse> uploadImage(ImageUpload imageupload) async {
    Dio client = Client().init();
    final data = imageupload.toJson();
    print(data);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageupload.uri),
    });

    try {
      final response = await client.post('/upload/images', data: formData);
      try {
        print(response.data);

        return ApiResponse.fromMap(response.data);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(ex);
      throw Exception(errorMessage);
    }
  }
}
