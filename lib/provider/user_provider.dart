import 'dart:io';

import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/models/user_model.dart';
import 'package:famka/services/custom_http.dart';
import 'package:famka/utils/app_snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() => fetchUser();

  // get user profile
  Future<UserModel> fetchUser() async {
    final response = await CustomHttp.get(
      endpoint: ApiConstants.me,
      need_auth: true,
    );

    if (response.ok && response.data?['data'] is Map<String, dynamic>) {
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    }
    throw Exception(response.error ?? 'Failed to load user details');
  }

  // update profile
  Future<bool> updateProfile({
    String? fullName,
    File? profileImage,
    bool? pushNotification,
    bool? dailyRemider,
    String? reminderTime,
  }) async {
    try {
      final response = await CustomHttp.multipart(
        endpoint: ApiConstants.updateProfile,
        fieldName: 'avatar',
        filePath: profileImage?.path,
        method: 'PATCH',
        fields: {
          'full_name': ?fullName,
          'push_notification': ?pushNotification?.toString(),
          'daily_reminder': ?dailyRemider?.toString(),
          'reminder_time': ?reminderTime,
        },
      );

      if (response.ok) {
        state = AsyncData(await fetchUser());
        return true;
      } else {
        AppSnackbar.show(
          message: response.error ?? 'Something went wrong',
          type: SnackType.error,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
    return false;
  }
}
