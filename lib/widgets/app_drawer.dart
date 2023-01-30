import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api.dart';
import '../models.dart';
import '../screens/about.dart';
import '../screens/discover.dart';
import '../screens/follow.dart';
import '../screens/mentions.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';
import '../screens/timeline.dart';
import '../viewmodels.dart';
import 'avatar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer(
      {Key? key, required this.activatedRoute, this.avatarRadius = 35})
      : super(key: key);

  final String activatedRoute;
  final double avatarRadius;

  ListTile buildListTile(BuildContext context, String title, String routePath) {
    final isActive = activatedRoute == routePath;
    return ListTile(
      title: Text(title),
      tileColor: isActive ? Theme.of(context).highlightColor : null,
      onTap: isActive
          ? null
          : () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(routePath);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () async {
              final user = context.read<AppUser>();
              final api = context.read<Api>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChangeNotifierProvider(
                      create: (_) =>
                          ProfileViewModel(api, user.twter, user.profile),
                      child: ProfileScreen(),
                    );
                  },
                ),
              );
            },
            child: Consumer<AppUser>(builder: (context, user, _) {
              return UserAccountsDrawerHeader(
                margin: const EdgeInsets.all(0),
                // Avatar border
                currentAccountPicture: AvatarWithBorder(
                  radius: avatarRadius,
                  imageUrl: user.twter!.avatar.toString(),
                ),
                accountName: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.profile!.username!),
                    Text(user.profile!.uri!.authority),
                  ],
                ),
                accountEmail: null,
              );
            }),
          ),
          buildListTile(context, 'Discover', Discover.routePath),
          buildListTile(context, 'Timeline', Timeline.routePath),
          buildListTile(context, 'Follow', Follow.routePath),
          buildListTile(context, 'Mentions', Mentions.routePath),
          buildListTile(context, 'Settings', Settings.routePath),
          buildListTile(context, "About", About.routePath),
          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthViewModel>().logout();
            },
          )
        ],
      ),
    );
  }
}
