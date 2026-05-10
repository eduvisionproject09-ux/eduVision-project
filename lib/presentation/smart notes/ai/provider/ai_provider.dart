import 'package:academic_project/data/ai_remote_data_source.dart';
import 'package:academic_project/domain/ai_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiProvider = StateNotifierProvider<AiNotifier, AiState>((ref) {
  return AiNotifier(AiRemoteDataSource());
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
  final AiRemoteDataSource _dataSource;
  AiNotifier(this._dataSource) : super(AiState());

  Future<void> askAi(String prompt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final aiResponse = await _dataSource.askAi(prompt);
      state = state.copyWith(isLoading: false, response: aiResponse);
    } catch (e) {
      String errorMessage = "Failed to get AI response. Please try again.";
      if (e is Exception) {
        errorMessage = e.toString();
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  void clearResponse() {
    state = AiState();
  }
}
