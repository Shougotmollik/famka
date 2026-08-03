import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/services/custom_http.dart';
import 'package:famka/services/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  void build() {
    return;
  }

  // sign up
  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isTermsAndConditionsAccepted,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.signUp,
        need_auth: false,
        body: {
          'full_name': fullName,
          'email_address': email,
          'password': password,
          'confirm_password': confirmPassword,
          'accept_terms': isTermsAndConditionsAccepted,
        },
      );

      if (response.ok) {
        return {'email': email, 'user_id': response.data['data']['user_id']};
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // signup otp verification
  Future<Map<String, dynamic>> verifySignUpOtp({
    required String userId,
    required String otp,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.verifyEmail,
        need_auth: false,
        body: {'user_id': userId, 'verification_code': otp},
      );

      if (response.ok) {
        final data = response.data['data'];
        final userId = data['user']['id'];
        final fullName = data['user']['full_name'];
        await LocalStorage.access_token.set(data['access']);
        await LocalStorage.refresh_token.set(data['refresh']);
        await LocalStorage.user_id.set(userId);
        await LocalStorage.full_name.set(fullName);

        return {
          'accessToken': data['access'],
          'refreshToken': data['refresh'],
          'tokenType': data['token_type'],
          'expiresIn': data['expires_in'],
          'expiresAt': data['expires_at'],
          'user_id': userId,
          'full_name': fullName,
        };
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // resend otp
  Future<Map<String, dynamic>> resendOtp({
    required String userId,
    required String purpose,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.resendOtp,
        need_auth: false,
        body: {'user_id': userId, 'purpose': purpose},
      );

      if (response.ok) {
        return {'message': response.data['message']};
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // log in
  Future<Map<String, dynamic>> logIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.signIn,
        need_auth: false,
        body: {'email_address': email, 'password': password},
      );

      if (response.ok) {
        final data = response.data['data'];
        final userId = data['user']['id'];
        final fullName = data['user']['full_name'];
        final userEmail = data['user']['email'];
        final role = data['user']['role'];
        await LocalStorage.access_token.set(data['access']);
        await LocalStorage.refresh_token.set(data['refresh']);
        await LocalStorage.user_id.set(userId);
        await LocalStorage.full_name.set(fullName);
        await LocalStorage.user_email.set(userEmail);
        await LocalStorage.role.set(role);
        await LocalStorage.access_token_valid_till.set(
          (data['expires_at'] as num).toInt(),
        );

        return {
          'accessToken': data['access'],
          'refreshToken': data['refresh'],
          'tokenType': data['token_type'],
          'expiresIn': data['expires_in'],
          'expiresAt': data['expires_at'],
          'user_id': userId,
          'full_name': fullName,
          'email': userEmail,
          'role': role,
        };
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // forgot password
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.forgotPassword,
        need_auth: false,
        body: {'email_address': email},
      );

      if (response.ok) {
        return {'user_id': response.data['data']['user_id']};
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // verify reset code
  Future<Map<String, dynamic>> verifyResetCode({
    required String userId,
    required String code,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.verifyResetCode,
        need_auth: false,
        body: {'user_id': userId, 'code': code},
      );

      if (response.ok) {
        final data = response.data['data'];
        return {'reset_token': data['reset_token'], 'user_id': data['user_id']};
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // reset password
  Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String resetToken,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.resetPassword,
        need_auth: false,
        body: {
          'user_id': userId,
          'reset_token': resetToken,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      if (response.ok) {
        return {'message': response.data['message']};
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  // log out
  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await LocalStorage.clearAuth();
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
