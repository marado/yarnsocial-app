import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../strings.dart';
import '../viewmodels.dart';
import '../widgets/app_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/post_list.dart';
import 'newtwt.dart';

class Mentions extends StatefulWidget {
  static const String routePath = "/mentions";
  @override
  _MentionsState createState() => _MentionsState();
}

class _MentionsState extends State<Mentions> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MentionsViewModel>().fetchNewPost());
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = context.read<AppStrings>();
    return Scaffold(
      drawer: AppDrawer(activatedRoute: Mentions.routePath),
      appBar: AppBar(title: Text(appStrings.mentions)),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            if (await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewTwt()),
                ) ??
                false) {
              context.read<MentionsViewModel>().fetchNewPost();
            }
          },
        ),
      ),
      body: Consumer<MentionsViewModel>(
        builder: (context, vm, _) {
          switch (vm.mainListState) {
            case FetchState.Loading:
              return Center(child: CircularProgressIndicator());
            case FetchState.Error:
              return UnexpectedErrorMessage(
                onRetryPressed: vm.gotoNextPage,
              );
            default:
              return RefreshIndicator(
                onRefresh: vm.refreshPost,
                child: PostList(
                  gotoNextPage: vm.gotoNextPage,
                  fetchNewPost: vm.fetchNewPost,
                  fetchMoreState: vm.fetchMoreState,
                  twts: vm.twts,
                ),
              );
          }
        },
      ),
    );
  }
}
