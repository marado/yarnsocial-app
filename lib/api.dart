import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yarn_social_app/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import 'models.dart';
import 'errors.dart';

class Api {
  final http.Client _httpClient;
  final StorageService _storageService;
  final FlutterSecureStorage _flutterSecureStorage;
  final String tokenKey = 'provile-v2';

  Api(this._httpClient, this._storageService, this._flutterSecureStorage);

  Future<AppUser?> get user async {
    String? json = await _flutterSecureStorage.read(key: tokenKey);
    if (json == null) {
      return null;
    }

    final user = AppUser.fromJson(jsonDecode(json));

    if (_storageService.getPodUrl() == null) {
      await _storageService
          .savePodUrl(user.profile!.uri!.replace(path: "").toString());
    }

    return user;
  }

  void clearUserToken() {
    _flutterSecureStorage.delete(key: tokenKey);
  }

  Future<bool> ping(Uri podURI) async {
    final response = await _httpClient.post(
      podURI.replace(path: "/api/v1/ping"),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
    );

    return response.statusCode == 200;
  }

  Future<AppUser> login(String username, String password, Uri podURI) async {
    final response = await _httpClient.post(
      podURI.replace(path: "/api/v1/auth"),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException(
        'Invalid Username/Password Hint: Register an account?',
      );
    }

    debugPrint("response: ${response.toString()}");
    debugPrint("statusCode: ${response.statusCode}");

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to login');
    }

    final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

    final profileResponse =
        await getProfile(username, token: authResponse.token, podURI: podURI);

    final user = AppUser(
      profile: profileResponse.profile,
      twter: profileResponse.twter,
      token: AuthResponse.fromJson(jsonDecode(response.body)).token,
    );

    await _flutterSecureStorage.write(key: tokenKey, value: jsonEncode(user));

    return user;
  }

  Future<AppUser?> getAppUser() async {
    var _user = await (user);

    if (_user == null) {
      return null;
    }

    final profileResponse = await getProfile(_user.profile!.username);

    _user = _user.copyWith(
        profile: profileResponse.profile, twter: profileResponse.twter);

    await _flutterSecureStorage.write(key: tokenKey, value: jsonEncode(_user));

    return _user;
  }

  Future<void> register(
      Uri uri, String username, String password, String email) async {
    final response = await _httpClient.post(
      uri.replace(path: "/api/v1/register"),
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to register. ${response.body}');
    }
  }

  Future<PagedResponse> timeline(int page) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/timeline"),
      body: jsonEncode({'page': page}),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to get posts');
    }

    return PagedResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<PagedResponse> mentions(int page) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/mentions"),
      body: jsonEncode({'page': page}),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to get posts');
    }

    return PagedResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<PagedResponse> discover(int page) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/discover"),
      body: jsonEncode({'page': page}),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to get posts');
    }

    return PagedResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<void> savePost(PostRequest postRequest) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/post"),
      body: jsonEncode(postRequest.toJson()),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed post tweet. Please try again later');
    }
  }

  Future<void> follow(String? nick, String url) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/follow"),
      body: jsonEncode({'nick': nick, 'url': url}),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Follow request failed. Please try again later',
      );
    }
  }

  Future<void> unfollow(String? nick) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/unfollow"),
      body: jsonEncode({'nick': nick}),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Follow request failed. Please try again later',
      );
    }
  }

  Future<String?> uploadImage(String filePath) async {
    final _user = await (user);
    final request = http.MultipartRequest(
      'POST',
      _user!.profile!.uri!.replace(path: "/api/v1/upload"),
    )
      ..headers['Token'] = _user.token!
      ..files.add(
        await http.MultipartFile.fromPath(
          'media_file',
          filePath,
          filename: basename(filePath),
        ),
      );

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode >= 400) {
      throw http.ClientException(
        'Failed to upload image. Please try again later',
      );
    }

    final response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body)['Path'];
  }

  Future<ProfileResponse> getProfile(String? name,
      {String? token, Uri? podURI}) async {
    http.Response response;

    if (token != null && podURI != null) {
      response = await _httpClient.get(
        podURI.replace(path: "/api/v1/profile/$name"),
        headers: {
          'Token': token,
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        },
      );
    } else {
      final _user = await (user);
      response = await _httpClient.get(
        _user!.profile!.uri!.replace(path: "/api/v1/profile/$name"),
        headers: {
          'Token': _user.token!,
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
        },
      );
    }

    debugPrint("response: ${response.toString()}");
    debugPrint("statusCode: ${response.statusCode}");

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed fetch profile. Please try again later',
      );
    }

    return ProfileResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }

  Future<ProfileResponse> getExternalProfile(String? nick, String url) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/external"),
      body: jsonEncode({
        "nick": nick,
        "url": url,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    debugPrint("response: ${response.toString()}");
    debugPrint("statusCode: ${response.statusCode}");

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed fetch profile. Please try again later',
      );
    }

    return ProfileResponse.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
  }

  Future<PagedResponse> getUserTwts(int page, String? nick,
      [String url = '']) async {
    final _user = await (user);

    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/fetch-twts"),
      body: jsonEncode({
        'page': page,
        'nick': nick,
        'url': url,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException(
          'Failed to get posts: ${response.reasonPhrase}');
    }

    return PagedResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<void> submitReport(
    String? nick,
    String url,
    String name,
    String email,
    String? category,
    String messsage,
  ) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/report"),
      body: jsonEncode({
        'nick': nick,
        'url': url,
        'name': name,
        'email': email,
        'subject': category,
        'message': messsage,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to post report');
    }
  }

  Future<void> mute(String? nick, String url) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/mute"),
      body: jsonEncode({
        'nick': nick,
        'url': url,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to mute user/feed');
    }
  }

  Future<void> unmute(String? nick) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/unmute"),
      body: jsonEncode({
        'nick': nick,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to unmute user/feed');
    }
  }

  Future<PagedResponse> fetchConversation(String hash, int page) async {
    final _user = await (user);
    final response = await _httpClient.post(
      _user!.profile!.uri!.replace(path: "/api/v1/conv"),
      body: jsonEncode({
        'page': page,
        'hash': hash,
      }),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to get posts');
    }

    return PagedResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<User> getUserSettings() async {
    final _user = await (user);
    final response = await _httpClient.get(
      _user!.profile!.uri!.replace(path: "/api/v1/settings"),
      headers: {
        'Token': _user.token!,
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to get user setting');
    }

    return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<String?> saveSettings(
    String? avatarPath,
    String tagline,
    String password,
    String email,
    bool isFollowersPubliclyVisible,
    bool isFollowingPubliclyVisible,
  ) async {
    final _user = await (user);
    final request = http.MultipartRequest(
      'POST',
      _user!.profile!.uri!.replace(path: "/api/v1/settings"),
    )
      ..headers['Token'] = _user.token!
      ..fields['tagline'] = tagline
      ..fields['password'] = password
      ..fields['email'] = email
      ..fields['isFollowersPubliclyVisible'] =
          isFollowersPubliclyVisible ? "on" : "off"
      ..fields['isFollowingPubliclyVisible'] =
          isFollowingPubliclyVisible ? "on" : "off";

    if (avatarPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'avatar_file',
        avatarPath,
        filename: basename(avatarPath),
      ));
    }

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode >= 400) {
      throw http.ClientException(
        'Failed to upload image. Please try again later',
      );
    }

    final response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body)['Path'];
  }
}
