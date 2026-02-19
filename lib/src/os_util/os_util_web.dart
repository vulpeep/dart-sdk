import 'os_util.dart';

OSUtil getOSUtil() => OSUtilWeb();

class OSUtilWeb extends OSUtil {
  @override
  String? getOSName() => null;

  @override
  String? getOSVersion() => null;

  @override
  String? getLocale() => null;

  @override
  String? getLanguage() => null;
}
