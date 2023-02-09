import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:yarn_social_app/data/data.dart';
import 'package:yarn_social_app/screens/internet_issue_screen.dart';

import '../models.dart';
import '../styles/theme.dart';
import '../viewmodels.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext, AsyncSnapshot<AppUser?>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: InternetConnectionChecker().hasConnection.asStream(),
        builder: (BuildContext context, AsyncSnapshot<bool> internetSnapshot) {
          if (internetSnapshot.hasData && internetSnapshot.data == false) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: InternetIssueScreen(),
              themeMode:
                  context.watch<ThemeViewModel>().themeMode.toThemeMode(),
              theme: AppThemes.lightTheme(),
              darkTheme: context.watch<ThemeViewModel>().themeMode.toTheme(),
            );
          }
          return StreamBuilder<AppUser?>(
            stream: context.watch<AuthViewModel>().user as Stream<AppUser?>?,
            builder: (BuildContext context, AsyncSnapshot<AppUser?> snapshot) {
              final AppUser? user = snapshot.data;
              if (user != null) {
                return MultiProvider(
                  providers: [
                    Provider<AppUser>.value(value: user),
                  ],
                  child: builder(context, snapshot),
                );
              }
              return builder(context, snapshot);
            },
          );
        });
  }
}
