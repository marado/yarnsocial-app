import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yarn_social_app/data/data.dart';
import 'package:yarn_social_app/httpclient.dart';
import 'package:yarn_social_app/services/storage_service.dart';
import 'package:yarn_social_app/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'screens/auth_widget.dart';
import 'strings.dart';
import 'viewmodels.dart';
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MyApp(
      sharedPreferences: await SharedPreferences.getInstance(),
      packageInfo: await PackageInfo.fromPlatform(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;

  const MyApp({
    Key? key,
    required this.sharedPreferences,
    required this.packageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _storageService = StorageService();

    final api = Api(
      UserAgentClient(http.Client(), this.packageInfo),
      _storageService,
      FlutterSecureStorage(),
    );

    return MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => _storageService, lazy: false),
        Provider.value(value: api),
        Provider(create: (_) => AppStrings()),
        Provider(create: (_) => AuthViewModel(api)),
        ChangeNotifierProvider(
          create: (context) => ThemeViewModel(sharedPreferences),
        ),
      ],
      child: AuthWidgetBuilder(
        builder: (context, snapshot) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthWidget(snapshot: snapshot),
          themeMode: context.watch<ThemeViewModel>().themeMode.toThemeMode(),
          theme: AppThemes.lightTheme(),
          darkTheme: context.watch<ThemeViewModel>().themeMode.toTheme(),
        ),
      ),
    );
  }
}
