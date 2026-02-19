import 'dart:io';
import 'os_util.dart';

OSUtil getOSUtil() => OSUtilNonWeb();

class OSUtilNonWeb extends OSUtil {
  @override
  String? getOSName() {
    switch (Platform.operatingSystem) {
      case "macos":
        return "Mac OS X";
      case "windows":
        return "Windows";
      case "linux":
        return "Linux";
      case "android":
        return "Android";
      case "ios":
        return "iOS";
      default:
        return Platform.operatingSystem;
    }
  }

  @override
  String? getOSVersion() {
    return Platform.operatingSystemVersion;
  }

  @override
  String? getLocale() {
    return Platform.localeName;
  }

  @override
  String? getLanguage() {
    final locale = Platform.localeName;
    final underscoreIndex = locale.indexOf('_');
    if (underscoreIndex > 0) {
      return locale.substring(0, underscoreIndex);
    }
    final dashIndex = locale.indexOf('-');
    if (dashIndex > 0) {
      return locale.substring(0, dashIndex);
    }
    return locale;
  }
}
