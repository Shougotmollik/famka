import 'dart:async';

import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/models/home.dart';
import 'package:famka/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  @override
  FutureOr<HomeModel> build() {
    return const HomeModel();
  }

  // fetch home data
  Future<void> fetchHomeData() async {
    state = AsyncLoading<HomeModel>().copyWithPrevious(state);
    try {
      final response = await CustomHttp.get(endpoint: ApiConstants.home);

      final data = response.data?['data'];
      if (response.ok && data is Map<String, dynamic>) {
        state = AsyncData(HomeModel.fromJson(data));
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError<HomeModel>(e, stackTrace).copyWithPrevious(state);
    }
  }
}
