import 'dart:async';

import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/models/statistics_model.dart';
import 'package:famka/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_provider.g.dart';

@riverpod
class Statistics extends _$Statistics {
  @override
  FutureOr<StatisticsModel> build() {
    return const StatisticsModel();
  }

  // fetch statistics
  Future<void> fetchStatistics() async {
    state = const AsyncLoading();
    try {
      final response = await CustomHttp.get(endpoint: ApiConstants.statistics);

      final data = response.data?['data'];
      if (response.ok && data is Map<String, dynamic>) {
        state = AsyncData(StatisticsModel.fromJson(data));
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
