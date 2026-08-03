class AppCredentials {
  AppCredentials._();

  // static const String domain = "";
  static const String domain = "http://10.10.29.62:8006";

  static String fixurl(String? path) {
    if (path == null || path.isEmpty) return '';
    // avoid double slashes
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) return '$domain$path';
    return '$domain/$path';
  }
}
