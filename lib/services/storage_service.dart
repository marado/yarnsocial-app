import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService() {
    init();
  }

  SharedPreferences? sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> savePodUrl(String podURL) async {
    Uri uri = Uri.parse(podURL);

    if (!uri.hasScheme) {
      uri = Uri.https(podURL, "");
    }

    if (uri.isScheme("HTTP")) {
      uri = uri.replace(scheme: "HTTPS");
    }

    await sharedPreferences?.setString(Keys.podUrl, uri.toString());
  }

  String? getPodUrl() {
    return sharedPreferences?.getString(Keys.podUrl);
  }
}

mixin Keys {
  static const podUrl = 'pod-url';
}
