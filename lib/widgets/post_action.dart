import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../models.dart';

class PostActions extends StatelessWidget {
  final Twt twt;

  const PostActions({
    Key? key,
    required this.twt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(Icons.drag_handle),
                ),
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  Share.share(context
                      .read<AppUser>()
                      .profile!
                      .uri!
                      .replace(
                        path: "/twt/${twt.hash}",
                      )
                      .toString());
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
