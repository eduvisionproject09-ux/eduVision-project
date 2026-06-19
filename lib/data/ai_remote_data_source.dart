import 'package:academic_project/domain/ai_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AiRemoteDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/ai'));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Options> _getOptions() async {
    final token = await _storage.read(key: 'jwt');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<AiResponse> askAi(String prompt, {String? style, String? language}) async {
    final response = await _dio.post(
      '/ask',
      data: {
        'prompt': prompt,
        'style': style,
        'language': language,
      },
      options: await _getOptions(),
    );
    return AiResponse.fromJson(response.data);
  }
}
