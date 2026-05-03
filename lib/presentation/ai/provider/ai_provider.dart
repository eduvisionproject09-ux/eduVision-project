import 'package:academic_project/domain/ai_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final aiProvider = StateNotifierProvider<AiNotifier, AiState>((ref) {
  return AiNotifier();
});

class AiState {
  final bool isLoading;
  final AiResponse? response;
  final String? error;

  AiState({this.isLoading = false, this.response, this.error});

  AiState copyWith({bool? isLoading, AiResponse? response, String? error}) {
    return AiState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}

class AiNotifier extends StateNotifier<AiState> {
  AiNotifier() : super(AiState());

  final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/ai'));
  final _storage = const FlutterSecureStorage();

  Future<void> askAi(String prompt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _storage.read(key: 'jwt');
      final response = await _dio.post(
        '/ask',
        data: {'prompt': prompt},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final aiResponse = AiResponse.fromJson(response.data);
      state = state.copyWith(isLoading: false, response: aiResponse);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
