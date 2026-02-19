import 'package:uuid/uuid.dart';
import 'disk_util/disk_util.dart';
import 'os_util/os_util.dart';

abstract class StatsigMetadata {
  static String getSDKVersion() {
    return "1.2.6";
  }

  static String getSDKType() {
    return "dart-client";
  }

  static String _sessionId = Uuid().v4();
  static String getSessionID() {
    return _sessionId;
  }

  static void regenSessionID() {
    _sessionId = Uuid().v4();
  }

  static String _stableId = "";
  static String getStableID() {
    if (_stableId.isEmpty) {
      throw Exception("Stable ID has not yet been loaded");
    }
    return _stableId;
  }

  static final Map<String, String> _overrides = {};

  /// Override auto-detected metadata values.
  ///
  /// Useful on platforms where Dart cannot access full device info natively
  /// (e.g. Android `Build.VERSION.RELEASE` or `Build.MODEL`).
  /// Use the `statsig_flutter` package for automatic collection via
  /// `device_info_plus` and `package_info_plus`.
  ///
  /// Supported keys: `systemVersion`, `locale`, `language`,
  /// `deviceModel`, `deviceManufacturer`, `appVersion`, `appIdentifier`.
  static void setOverrides(Map<String, String> overrides) {
    _overrides.addAll(overrides);
  }

  static Future loadStableID([String? overrideStableID]) async {
    const stableIdFilename = "statsig_stable_id";

    if (overrideStableID != null && overrideStableID.isNotEmpty) {
      _stableId = overrideStableID;
      DiskUtil.instance.write(stableIdFilename, overrideStableID);
      return;
    }

    _stableId = await DiskUtil.instance.read(stableIdFilename);
    if (_stableId.isEmpty) {
      var id = Uuid().v4();
      await DiskUtil.instance.write(stableIdFilename, id);
      _stableId = id;
    }
  }

  static Map toJson() {
    var res = <String, String>{
      "sdkVersion": getSDKVersion(),
      "sdkType": getSDKType(),
      "sessionID": getSessionID(),
      "stableID": getStableID(),
    };

    void addIfNotNull(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        res[key] = value;
      }
    }

    final osUtil = OSUtil.instance;
    addIfNotNull("systemName", osUtil.getOSName());
    addIfNotNull("deviceOS", osUtil.getOSName());
    addIfNotNull("systemVersion", _overrides["systemVersion"] ?? osUtil.getOSVersion());
    addIfNotNull("locale", _overrides["locale"] ?? osUtil.getLocale());
    addIfNotNull("language", _overrides["language"] ?? osUtil.getLanguage());

    for (var key in ["deviceModel", "deviceManufacturer", "appVersion", "appIdentifier"]) {
      addIfNotNull(key, _overrides[key]);
    }

    return res;
  }
}
