import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thai7merchant/app_const.dart';
import 'package:thai7merchant/model/pagination.dart';

class Client {
  Dio init() {
    final appConfig = GetStorage('AppConfig');

    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());

    String endPointService = AppConfig.serviceApi;

    endPointService +=
        endPointService[endPointService.length - 1] == "/" ? "" : "/";

    _dio.options.baseUrl = endPointService;
    _dio.options.connectTimeout = 20000; //20s
    _dio.options.receiveTimeout = 5000; //5s

    return _dio;
  }
}

class ApiResponse<T> {
  late final bool success;
  late final bool error;
  // ignore: unnecessary_question_mark
  late final dynamic? data;
  late final message;
  late final code;
  final Page? page;

  ApiResponse({
    required this.success,
    required this.data,
    this.error = true,
    this.message = "",
    this.code = 00,
    this.page,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      success: map['success'] ?? false,
      error: map['error'] ?? true,
      data: map['data'],
      page: map['pagination'] == null
          ? Page.empty
          : Page.fromMap(map['pagination']),
    );
  }
}

class Page {
  final int perPage;
  final int page;
  final int total;
  final int totalPage;

  const Page({
    required this.perPage,
    required this.page,
    required this.total,
    required this.totalPage,
  });

  static const empty = Page(perPage: 0, page: 0, total: 0, totalPage: 0);

  bool get isEmpty => this == Page.empty;

  bool get isNotEmpty => this == Page.empty;

  factory Page.fromMap(Map<String, dynamic> map) {
    return Page(
        perPage: map['perPage'],
        page: map['page'],
        total: map['total'],
        totalPage: map['totalPage']);
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appConfig = GetStorage('AppConfig');

    String authorization = appConfig.read("token") ?? '';
    if (authorization.length > 0) {
      options.headers['Authorization'] = "Bearer " + authorization;
    }

    super.onRequest(options, handler);
  }
}
