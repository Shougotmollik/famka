class ApiConstants {
  // auth
  static const String refreshToken = '/auth/refresh';
  static const String signUp = '/auth/sign-up';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-code';
  static const String signIn = '/auth/sign-in';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-reset-code';
  static const String resetPassword = '/auth/reset-password';

  // profile
  static const String updateProfile = '/auth/my-account';
  static const String me = '/auth/my-account';
  static const String privacyPolicy = "/common/privacy";
  static const String termsCondition = '/common/terms';

  // statistics
  static const String statistics = '/statistics';

  // notifications
  static const String notifications = '/notification/list';
  static const String readNotification = '/notification/read';
  static const String allNotification = '/notification/read-all';

  // home
  static const String home = '/home';

  // quiz
  static String getQuiz(String storyId, String difficulty) =>
      "/home/stories/$storyId/quiz?difficulty=$difficulty";
  static String audioListented = "/home/audio-listen";
}
