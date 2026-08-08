import 'dart:async';

import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/models/quiz.dart';
import 'package:famka/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_provider.g.dart';

@riverpod
class Quiz extends _$Quiz {
  String _loadedStoryId = '';
  String _loadedDifficulty = '';

  @override
  FutureOr<QuizResponseModel> build() {
    return const QuizResponseModel();
  }

  // fetch quiz
  Future<void> fetchQuiz({
    required String storyId,
    required String difficulty,
  }) async {
    if (_loadedStoryId == storyId &&
        _loadedDifficulty == difficulty &&
        (state.value?.questions.isNotEmpty ?? false)) {
      return;
    }
    _loadedStoryId = storyId;
    _loadedDifficulty = difficulty;

    state = AsyncLoading<QuizResponseModel>().copyWithPrevious(state);
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.getQuiz(storyId, difficulty),
      );

      final body = response.data;
      if (response.ok && body is Map<String, dynamic>) {
        state = AsyncData(QuizResponseModel.fromJson(body));
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError<QuizResponseModel>(
        e,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }

  //sesssion audio instented
  Future<bool> sessionAudioListened({required String audioId}) async {
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.audioListented,
        body: {'audio_id': audioId},
      );
      if (response.ok) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
