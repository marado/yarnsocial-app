import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'models.dart';
import 'errors.dart';

class AuthViewModel {
  final Api _api;

  final _user = BehaviorSubject<AppUser?>();

  AuthViewModel(this._api) {
    getAppUser().catchError((e) {
      debugPrint("Error getting user: " + e.toString());
      debugPrint(e.runtimeType.toString());

      final podURI = _user.value!.profile!.uri!.replace(path: "");
      _api.ping(podURI).then((bool ok) {
        if (ok) {
          _api.clearUserToken();
          _user.add(null);
        }
      });
    });
  }

  Stream get user => _user.stream;

  void logout() {
    if (_user.value == null) return;
    _api.clearUserToken();
    _user.add(null);
  }

  Future<void> unfollow(String? nick) async {
    final user = await (_user.first);
    _api.unfollow(nick);
    user!.profile!.following!.remove(nick);
    _user.add(user);
  }

  Future<void> follow(String? nick, String url) async {
    final user = await (_user.first);
    _api.follow(nick, url);
    user!.profile!.following!.putIfAbsent(nick!, () => url);
    _user.add(user);
  }

  Future<void> login(String username, String password, String podURL) async {
    var uri = Uri.parse(podURL);

    if (!uri.hasScheme) {
      uri = Uri.https(podURL, "");
    }

    if (uri.isScheme("HTTP")) {
      uri = uri.replace(scheme: "HTTPS");
    }

    final user = await _api.login(
      username,
      password,
      uri,
    );
    _user.add(user);
  }

  Future<void> getAppUser() {
    return _api.getAppUser().then(_user.add);
  }
}

enum FetchState { Loading, Done, Error }

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel(this._api);

  final Api _api;
  late PagedResponse _lastTimelineResponse;

  FetchState _mainListState = FetchState.Done;
  FetchState _fetchMoreState = FetchState.Done;
  List<Twt>? _twts = [];

  FetchState get mainListState => _mainListState;
  FetchState get fetchMoreState => _fetchMoreState;

  List<Twt>? get twts => _twts;

  set mainListState(FetchState fetchState) {
    _mainListState = fetchState;
    notifyListeners();
  }

  set fetchMoreState(FetchState fetchState) {
    _fetchMoreState = fetchState;
    notifyListeners();
  }

  Future refreshPost() async {
    _lastTimelineResponse = await _api.timeline(0);
    _twts = _lastTimelineResponse.twts;
    notifyListeners();
  }

  void fetchNewPost() async {
    mainListState = FetchState.Loading;

    try {
      _lastTimelineResponse = await _api.timeline(0);
      _twts = _lastTimelineResponse.twts;

      mainListState = FetchState.Done;
    } catch (e) {
      mainListState = FetchState.Error;
      rethrow;
    }
  }

  void gotoNextPage() async {
    if (_lastTimelineResponse.pagerResponse.currentPage ==
        _lastTimelineResponse.pagerResponse.maxPages) {
      return;
    }

    fetchMoreState = FetchState.Loading;
    try {
      final page = _lastTimelineResponse.pagerResponse.currentPage! + 1;
      _lastTimelineResponse = await _api.timeline(page);
      _twts = [..._twts!, ..._lastTimelineResponse.twts];
      fetchMoreState = FetchState.Done;
    } catch (e) {
      fetchMoreState = FetchState.Error;
      rethrow;
    }
  }
}

class MentionsViewModel extends ChangeNotifier {
  MentionsViewModel(this._api);

  final Api _api;
  late PagedResponse _lastMentionsResponse;

  FetchState _mainListState = FetchState.Done;
  FetchState _fetchMoreState = FetchState.Done;
  List<Twt>? _twts = [];

  FetchState get mainListState => _mainListState;
  FetchState get fetchMoreState => _fetchMoreState;

  List<Twt>? get twts => _twts;

  set mainListState(FetchState fetchState) {
    _mainListState = fetchState;
    notifyListeners();
  }

  set fetchMoreState(FetchState fetchState) {
    _fetchMoreState = fetchState;
    notifyListeners();
  }

  Future refreshPost() async {
    _lastMentionsResponse = await _api.mentions(0);
    _twts = _lastMentionsResponse.twts;
    notifyListeners();
  }

  void fetchNewPost() async {
    mainListState = FetchState.Loading;

    try {
      _lastMentionsResponse = await _api.mentions(0);
      _twts = _lastMentionsResponse.twts;

      mainListState = FetchState.Done;
    } catch (e) {
      mainListState = FetchState.Error;
      rethrow;
    }
  }

  void gotoNextPage() async {
    if (_lastMentionsResponse.pagerResponse.currentPage ==
        _lastMentionsResponse.pagerResponse.maxPages) {
      return;
    }

    fetchMoreState = FetchState.Loading;
    try {
      final page = _lastMentionsResponse.pagerResponse.currentPage! + 1;
      _lastMentionsResponse = await _api.mentions(page);
      _twts = [..._twts!, ..._lastMentionsResponse.twts];
      fetchMoreState = FetchState.Done;
    } catch (e) {
      fetchMoreState = FetchState.Error;
      rethrow;
    }
  }
}

class DiscoverViewModel extends ChangeNotifier {
  DiscoverViewModel(this._api);

  final Api _api;
  FetchState _mainListState = FetchState.Done;
  FetchState _fetchMoreState = FetchState.Done;

  late PagedResponse _lastTimelineResponse = PagedResponse([], PagerResponse());
  List<Twt>? _twts = [];

  List<Twt>? get twts => _twts;

  FetchState get mainListState => _mainListState;
  FetchState get fetchMoreState => _fetchMoreState;

  set mainListState(FetchState fetchState) {
    _mainListState = fetchState;
    notifyListeners();
  }

  set fetchMoreState(FetchState fetchState) {
    _fetchMoreState = fetchState;
    notifyListeners();
  }

  Future refreshPost() async {
    _lastTimelineResponse = await _api.discover(0);
    _twts = _lastTimelineResponse.twts;
    notifyListeners();
  }

  void fetchNewPost() async {
    mainListState = FetchState.Loading;

    try {
      _lastTimelineResponse = await _api.discover(0);
      _twts = _lastTimelineResponse.twts;
      mainListState = FetchState.Done;
    } catch (e) {
      mainListState = FetchState.Error;
      rethrow;
    }
  }

  void gotoNextPage() async {
    if (_lastTimelineResponse.pagerResponse.currentPage ==
        _lastTimelineResponse.pagerResponse.maxPages) {
      return;
    }

    fetchMoreState = FetchState.Loading;
    try {
      final page = _lastTimelineResponse.pagerResponse.currentPage! + 1;
      _lastTimelineResponse = await _api.discover(page);
      _twts = [..._twts!, ..._lastTimelineResponse.twts];
      fetchMoreState = FetchState.Done;
    } catch (e) {
      fetchMoreState = FetchState.Error;
      rethrow;
    }
  }
}

class ProfileViewModel extends ChangeNotifier {
  final Api _api;
  final Profile? _loggedInUserProfile;
  final Twter? _twter;

  ProfileResponse? _profileResponse;
  late PagedResponse _lastTimelineResponse;
  List<Twt>? _twts = [];

  FetchState _fetchMoreState = FetchState.Done;

  List<Twt>? get twts => _twts;

  Profile? get profile => _profileResponse!.profile;
  Twter? get twter => _profileResponse!.twter;
  bool get hasProfile => _profileResponse?.profile != null;

  Map<String?, String>? get following => _profileResponse?.profile?.following;
  int get followingCount => _profileResponse?.profile?.nFollowing ?? 0;
  bool get hasFollowing => followingCount > 0;

  Map<String, String>? get followers => _profileResponse?.profile?.followers;
  int get followerCount => _profileResponse?.profile?.nFollowers ?? 0;
  bool get hasFollowers => followerCount > 0;

  bool get isViewingOwnProfile => _loggedInUserProfile!.uri == twter!.uri;
  bool get isProfileExternal => !_twter!.isPodMember(_loggedInUserProfile!.uri);

  FetchState get fetchMoreState => _fetchMoreState;

  String? get name => _twter!.nick;

  String? get avatar => _profileResponse?.profile?.avatar;

  set profileResponse(ProfileResponse profileResponse) {
    _profileResponse = profileResponse;
    notifyListeners();
  }

  Future refreshPost() async {
    _lastTimelineResponse = await _api.getUserTwts(
      0,
      _twter!.nick,
      _twter!.uri.toString(),
    );
    _twts = _lastTimelineResponse.twts;
    notifyListeners();
  }

  set fetchMoreState(FetchState fetchState) {
    _fetchMoreState = fetchState;
    notifyListeners();
  }

  ProfileViewModel(this._api, this._twter, this._loggedInUserProfile) {
    _twts = [];
  }

  Future<void> fetchProfile() async {
    if (isProfileExternal) {
      profileResponse =
          await _api.getExternalProfile(_twter!.nick, _twter!.uri.toString());
      return;
    }
    profileResponse = await _api.getProfile(_twter!.nick);
  }

  Future<void> gotoNextPage() async {
    if (_lastTimelineResponse.pagerResponse.currentPage ==
        _lastTimelineResponse.pagerResponse.maxPages) {
      return;
    }

    fetchMoreState = FetchState.Loading;
    try {
      final page = _lastTimelineResponse.pagerResponse.currentPage! + 1;
      _lastTimelineResponse = await _api.getUserTwts(page, profile!.username);
      _twts = [..._twts!, ..._lastTimelineResponse.twts];
      fetchMoreState = FetchState.Done;
    } catch (e) {
      fetchMoreState = FetchState.Error;
      rethrow;
    }
  }

  Future<void> mute() async {
    await _api.mute(profile!.username, profile!.uri.toString());
    await fetchProfile();
  }

  Future<void> unmute() async {
    await _api.unmute(profile!.username);
    await fetchProfile();
  }
}

class ThemeViewModel extends ChangeNotifier {
  static const String ThemeModeKey = "theme_mode";
  final SharedPreferences _sharedPreferences;
  ThemeMode? _themeMode;

  ThemeViewModel(this._sharedPreferences) {
    _themeMode = ThemeMode.values[
        (_sharedPreferences.getInt(ThemeViewModel.ThemeModeKey) ??
            0)]; // Uses ThemeMode.system by default
  }

  ThemeMode get themeMode => _themeMode!;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _sharedPreferences.setInt(ThemeViewModel.ThemeModeKey, mode.index);
    notifyListeners();
  }

  bool get isDarkModeEnabled => _themeMode == ThemeMode.dark;

  void toggleDarkMode(bool shouldToggleDarkMode) {
    themeMode = shouldToggleDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

class ConversationViewModel extends ChangeNotifier {
  ConversationViewModel(this._api, this._sourceTwt);

  final Api _api;
  final Twt _sourceTwt;
  late PagedResponse _lastMentionsResponse;

  FetchState _mainListState = FetchState.Done;
  FetchState _fetchMoreState = FetchState.Done;
  List<Twt>? _twts = [];

  FetchState get mainListState => _mainListState;
  FetchState get fetchMoreState => _fetchMoreState;

  List<Twt>? get twts => _twts;
  String get replyForInitialText => "${_sourceTwt.subject} ";
  String get conversationRootTwtHash => "${_sourceTwt.cleanSubject}";

  set mainListState(FetchState fetchState) {
    _mainListState = fetchState;
    notifyListeners();
  }

  set fetchMoreState(FetchState fetchState) {
    _fetchMoreState = fetchState;
    notifyListeners();
  }

  Future refreshPost() async {
    _lastMentionsResponse =
        await _api.fetchConversation(_sourceTwt.cleanSubject, 0);
    _twts = _lastMentionsResponse.twts;
    notifyListeners();
  }

  void fetchNewPost() async {
    mainListState = FetchState.Loading;

    try {
      _lastMentionsResponse =
          await _api.fetchConversation(_sourceTwt.cleanSubject, 0);
      _twts = _lastMentionsResponse.twts;

      mainListState = FetchState.Done;
    } catch (e) {
      mainListState = FetchState.Error;
      rethrow;
    }
  }

  void gotoNextPage() async {
    if (_lastMentionsResponse.pagerResponse.currentPage ==
        _lastMentionsResponse.pagerResponse.maxPages) {
      return;
    }

    fetchMoreState = FetchState.Loading;
    try {
      final page = _lastMentionsResponse.pagerResponse.currentPage! + 1;
      _lastMentionsResponse =
          await _api.fetchConversation(_sourceTwt.cleanSubject, page);
      _twts = [..._twts!, ..._lastMentionsResponse.twts];
      fetchMoreState = FetchState.Done;
    } catch (e) {
      fetchMoreState = FetchState.Error;
      rethrow;
    }
  }
}
