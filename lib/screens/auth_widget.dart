import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../models.dart';
import '../viewmodels.dart';
import 'about.dart';
import 'discover.dart';
import 'follow.dart';
import 'login.dart';
import 'settings.dart';
import 'timeline.dart';
import 'mentions.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<AppUser?> snapshot;

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  StreamSubscription? _userSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userSub == null) {
      _userSub = context
          .read<AuthViewModel>()
          .user
          .where((user) => user == null)
          .listen((_) => Navigator.popUntil(context, (route) => route.isFirst));
    }
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.connectionState == ConnectionState.active) {
      return widget.snapshot.hasData ? Home() : Login();
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final _api = context.watch<Api>();
    return WillPopScope(
      onWillPop: () async {
        return !await navigator.currentState!.maybePop();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TimelineViewModel(_api)),
          ChangeNotifierProvider(create: (_) => DiscoverViewModel(_api)),
          ChangeNotifierProvider(create: (_) => MentionsViewModel(_api)),
        ],
        child: Navigator(
          key: navigator,
          initialRoute: Timeline.routePath,
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case Timeline.routePath:
                builder = (_) => Timeline();
                break;
              case Discover.routePath:
                builder = (_) => Discover();
                break;
              case Mentions.routePath:
                builder = (_) => Mentions();
                break;
              case Follow.routePath:
                builder = (_) => Follow();
                break;
              case Settings.routePath:
                builder = (_) => Settings();
                break;
              case About.routePath:
                builder = (_) => About();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }

            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}
