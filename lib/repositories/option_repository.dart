import 'dart:convert';

import 'package:thai7merchant/struct/option.dart';

import 'client.dart';
import 'package:dio/dio.dart';

class OptionRepository {
  Future<ApiResponse> getOptionList({
    int page = 0,
    int perPage = 20,
    String search = "",
  }) async {
    Dio client = Client().init();

    try {
      final response =
          await client.get('/option?page=${page}&limit=${perPage}&q=${search}');
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

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

  Future<ApiResponse> getOptionId(String id) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/option/${id}');
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          print(errorMessage);
          throw new Exception('${rawData['code']}: ${rawData['message']}');
        }

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

  Future<ApiResponse> saveOption(Option option) async {
    Dio client = Client().init();
    final data = option.toJson();
    print(data);
    try {
      final response = await client.post('/option', data: data);
      try {
        // final rawData = json.decode(response.toString());

        print(response.data);

        // if (rawData['error'] != null) {
        //   String errorMessage = '${rawData['code']}: ${rawData['message']}';
        //   print(errorMessage);
        //   throw new Exception('${rawData['code']}: ${rawData['message']}');
        // }

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

  Future<ApiResponse> updateOption(Option option) async {
    Dio client = Client().init();
    final data = option.toJson();
    print(data);
    try {
      final response =
          await client.put('/option/${option.guidfixed}', data: data);
      try {
        // final rawData = json.decode(response.toString());

        print(response.data);

        // if (rawData['error'] != null) {
        //   String errorMessage = '${rawData['code']}: ${rawData['message']}';
        //   print(errorMessage);
        //   throw new Exception('${rawData['code']}: ${rawData['message']}');
        // }

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

  Future<ApiResponse> deleteOption(String id) async {
    Dio client = Client().init();
    try {
      final response = await client.delete('/option/${id}');
      try {
        // final rawData = json.decode(response.toString());

        print(response.data);

        // if (rawData['error'] != null) {
        //   String errorMessage = '${rawData['code']}: ${rawData['message']}';
        //   print(errorMessage);
        //   throw new Exception('${rawData['code']}: ${rawData['message']}');
        // }

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
