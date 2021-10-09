import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../strings.dart';
import '../widgets/common_widgets.dart';
import '../viewmodels.dart';
import 'newtwt.dart';

class Discover extends StatefulWidget {
  static const String routePath = '/discover';

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DiscoverViewModel>().fetchNewPost());
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = context.watch<AppStrings>();
    return Scaffold(
      drawer: AppDrawer(activatedRoute: Discover.routePath),
      appBar: AppBar(title: Text(appStrings.discover)),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          tooltip: 'New twt',
          child: Icon(Icons.add),
          onPressed: () async {
            if (await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewTwt()),
                ) ??
                false) {
              context.read<DiscoverViewModel>().fetchNewPost();
            }
          },
        ),
      ),
      body: Consumer<DiscoverViewModel>(
        builder: (context, vm, _) {
          switch (vm.mainListState) {
            case FetchState.Loading:
              return Center(child: CircularProgressIndicator());
            case FetchState.Error:
              return UnexpectedErrorMessage(
                onRetryPressed: vm.fetchNewPost,
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
