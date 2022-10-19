import 'dart:convert';

import 'package:thai7merchant/model/unit.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class UnitRepository {
  Future<ApiResponse> getUnitList({
    int page = 0,
    int perPage = 20,
    String search = "",
  }) async {
    Dio client = Client().init();

    try {
      final response =
          await client.get('/unit?page=${page}&limit=${perPage}&q=${search}');
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        var xxx = ApiResponse.fromMap(rawData);
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        print(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
