import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yarn_social_app/widgets/post_action.dart';
import 'package:yarn_social_app/widgets/twtvideoplayer.dart';

import '../api.dart';
import '../models.dart';
import '../screens/conversation.dart';
import '../screens/newtwt.dart';
import '../screens/profile.dart';
import '../services/storage_service.dart';
import '../strings.dart';
import '../viewmodels.dart';
import 'avatar.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;

import 'error_widget.dart';

class PostList extends StatefulWidget {
  const PostList({
    Key? key,
    required this.fetchNewPost,
    required this.gotoNextPage,
    required this.twts,
    required this.fetchMoreState,
    this.topSlivers = const <Widget>[],
    this.afterReply,
    this.showReplyButton = true,
    this.showForkButton = false,
    this.showConversationButton = true,
  }) : super(key: key);

  final Function fetchNewPost;
  final Function gotoNextPage;
  final List<Twt>? twts;
  final List<Widget> topSlivers;
  final FetchState fetchMoreState;
  final bool showReplyButton;
  final bool showForkButton;
  final bool showConversationButton;
  final Function()? afterReply;

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(initiateLoadMoreOnScroll);
  }

  void initiateLoadMoreOnScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent * 0.9 &&
        widget.fetchMoreState == FetchState.Done) {
      widget.gotoNextPage();
    }
  }

  void pushToProfileScreen(
    BuildContext context,
    Twter? twter,
  ) {
    final user = context.read<AppUser>();
    final api = context.read<Api>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => ProfileViewModel(api, twter, user.profile),
            child: ProfileScreen(),
          );
        },
      ),
    );
  }

  Twter? getTwterFromTwtxtURL(String link, title) {
    Uri uri;

    try {
      uri = Uri.parse(link);
    } catch (e) {
      return null;
    }

    return Twter(nick: title, uri: uri);
  }

  Widget buildMarkdownBody(BuildContext context, Twt twt) {
    final appStrings = context.read<AppStrings>();

    return MarkdownBody(
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      imageBuilder: (uri, title, alt) => Builder(
        builder: (context) {
          if (path.extension(uri.path) == '.mp4') {
            return TwtAssetVideo(
              videoURL: uri.toString(),
            );
          }

          void onTap() async {
            if (await canLaunch(uri.toString())) {
              await launch(uri.toString());
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(appStrings.failLaunchImageToBrowser),
              ),
            );
          }

          return GestureDetector(
            onTap: onTap,
            child: CachedNetworkImage(
              httpHeaders: {HttpHeaders.acceptHeader: "image/png"},
              imageUrl: uri.toString(),
              placeholder: (context, url) => CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(image: imageProvider),
                  ],
                );
              },
            ),
          );
        },
      ),
      onTapLink: (text, link, title) async {
        if (twt.mentions.contains(text.replaceFirst("@", ""))) {
          final twter = getTwterFromTwtxtURL(link!, text.replaceFirst("@", ""));
          pushToProfileScreen(context, twter);
          return;
        }

        if (await canLaunch(link!)) {
          await launch(link);
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${appStrings.failLaunch} $link'),
          ),
        );
      },
      data: twt.cleanMDText,
      extensionSet: md.ExtensionSet.gitHubWeb,
      softLineBreak: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppUser>();
    final storage = Provider.of<StorageService>(context, listen: false);
    final podURL = storage.getPodUrl();
    final strings = context.watch<AppStrings>();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        ...widget.topSlivers,
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, idx) {
              final twt = widget.twts![idx];

              final imageUrl =
                  podURL!.contains(twt.twter!.uri.toString().split('/user')[0])
                      ? twt.twter!.avatar.toString()
                      : '$podURL/externalAvatar?uri=${twt.twter!.uri}';

              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(16, 16, 8, 6),
                isThreeLine: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          pushToProfileScreen(context, twt.twter);
                        },
                        child: Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(imageUrl: imageUrl),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      twt.twter!.nick!,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          Jiffy(twt.createdTime!.toLocal())
                                              .format('jm'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '(${Jiffy(twt.createdTime).fromNow()})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.more_vert,
                              size: 16,
                            ),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              builder: (context) => Container(
                                child: PostActions(twt: twt),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      child: buildMarkdownBody(context, twt),
                    ),
                    Row(
                      children: [
                        if (widget.showReplyButton)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewTwt(
                                    initialText: twt.replyText(user.profile),
                                  ),
                                ),
                              );
                              widget.afterReply?.call();
                            },
                            child: Text(
                              "Reply",
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        SizedBox(width: 8),
                        if (widget.showForkButton && idx > 0)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewTwt(
                                    initialText: twt.forkText(
                                      user.profile!.username,
                                    ),
                                  ),
                                ),
                              );
                              widget.afterReply?.call();
                            },
                            child: Text(
                              "Fork",
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        SizedBox(width: 8),
                        if (widget.showConversationButton &&
                            twt.subject!.isNotEmpty)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => ConversationViewModel(
                                      context.read<Api>(),
                                      twt,
                                    ),
                                    child: Conversation(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              strings.conversationButtonTitle,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: widget.twts!.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              switch (widget.fetchMoreState) {
                case FetchState.Loading:
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                case FetchState.Error:
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: UnexpectedErrorMessage(
                      onRetryPressed: widget.gotoNextPage as void Function(),
                    ),
                  );
                default:
                  return SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }
}
