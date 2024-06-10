import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/config_model.dart';

class HttpService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late final String _baseUrl;
  late final String _apiKey;

  HttpService() {
    final AppConfig _config = getIt.get<AppConfig>();
    _baseUrl = _config.BASE_API_URL;
    _apiKey = _config.API_KEY;
  }

  Future<Response?> get(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    final String url = '$_baseUrl$path';
    final Map<String, dynamic> query = {
      'api_key': _apiKey, // Corrected here
      'language': 'en-US',
      ...queryParameters,
    };

    try {
      return await dio.get(url, queryParameters: query);
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    }
  }

  void _handleDioError(DioException e) {
    print('Unable to perform GET request');
    print('DioError: ${e.message}');
    if (e.response != null) {
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
    }
  }
}
