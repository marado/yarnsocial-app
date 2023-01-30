import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../viewmodels.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext, AsyncSnapshot<AppUser?>) builder;

  @override
  Widget build(BuildContext context) {
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
  }
}
