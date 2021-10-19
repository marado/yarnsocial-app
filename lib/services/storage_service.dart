import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService() {
    init();
  }

  SharedPreferences? sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> savePodUrl(String podUrl) async {
    sharedPreferences?.setString(Keys.podUrl, podUrl);
  }

  String? getPodUrl() {
    return sharedPreferences?.getString(Keys.podUrl);
  }
}

mixin Keys {
  static const podUrl = 'pod-url';
}
