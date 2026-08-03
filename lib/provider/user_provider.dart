import 'dart:io';

import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/services/custom_http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class User extends _$User {
  @override
  Object build() {
    return {};
  }

  // profile update
  Future<bool> updateProfile({
    String? fullName,
    File? profileImage,
    bool? pushNotification,
    bool? dailyRemider,
    String? reminderTime,
  }) async {
    state = AsyncLoading();
    try {
      final response = await CustomHttp.multipart(
        endpoint: ApiConstants.updateProfile,
        fieldName: 'avatar',
        filePath: profileImage?.path,
        method: "PATCH",
        fields: {
          'full_name': ?fullName,
          'push_notification': ?pushNotification?.toString(),
          'daily_reminder': ?dailyRemider?.toString(),
          'reminder_time': ?reminderTime,
        },
      );
      if (response.ok) {
        state = AsyncData(response.data ?? {});
        return true;
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
    return false;
  }
}
