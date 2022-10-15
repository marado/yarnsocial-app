// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      token: json['token'] as String?,
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      twter: json['twter'] == null
          ? null
          : Twter.fromJson(json['twter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'profile': instance.profile,
      'token': instance.token,
      'twter': instance.twter,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['Username'] as String?,
      json['Tagline'] as String?,
      json['IsFollowersPubliclyVisible'] as bool?,
      json['IsFollowingPubliclyVisible'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Username': instance.username,
      'Tagline': instance.tagline,
      'IsFollowersPubliclyVisible': instance.isFollowersPubliclyVisible,
      'IsFollowingPubliclyVisible': instance.isFollowingPubliclyVisible,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

PagerResponse _$PagerResponseFromJson(Map<String, dynamic> json) =>
    PagerResponse(
      currentPage: json['current_page'] as int?,
      maxPages: json['max_pages'] as int?,
      totalTwts: json['total_twts'] as int?,
    );

Map<String, dynamic> _$PagerResponseToJson(PagerResponse instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'max_pages': instance.maxPages,
      'total_twts': instance.totalTwts,
    };

Twter _$TwterFromJson(Map<String, dynamic> json) => Twter(
      nick: json['nick'] as String?,
      // XXX: url field is deprecated in favor of uri
      // TODO: Remove this compatibility
      uri: json['url'] == null
          ? Uri.parse(json["uri"] as String)
          : Uri.parse(json['url'] as String),
      avatar:
          json['avatar'] == null ? null : Uri.parse(json['avatar'] as String),
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$TwterToJson(Twter instance) => <String, dynamic>{
      'nick': instance.nick,
      'uri': instance.uri?.toString(),
      'avatar': instance.avatar?.toString(),
      'slug': instance.slug,
    };

Twt _$TwtFromJson(Map<String, dynamic> json) => Twt(
      twter: json['twter'] == null
          ? null
          : Twter.fromJson(json['twter'] as Map<String, dynamic>),
      text: json['text'] as String?,
      markdownText: json['markdownText'] as String?,
      createdTime: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      hash: json['hash'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subject: json['subject'] as String?,
    );

Map<String, dynamic> _$TwtToJson(Twt instance) => <String, dynamic>{
      'twter': instance.twter,
      'text': instance.text,
      'markdownText': instance.markdownText,
      'created': instance.createdTime?.toIso8601String(),
      'hash': instance.hash,
      'tags': instance.tags,
      'subject': instance.subject,
    };

PagedResponse _$PagedResponseFromJson(Map<String, dynamic> json) =>
    PagedResponse(
      (json['twts'] as List<dynamic>)
          .map((e) => Twt.fromJson(e as Map<String, dynamic>))
          .toList(),
      PagerResponse.fromJson(json['Pager'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagedResponseToJson(PagedResponse instance) =>
    <String, dynamic>{
      'twts': instance.twts,
      'Pager': instance.pagerResponse,
    };

PostRequest _$PostRequestFromJson(Map<String, dynamic> json) => PostRequest(
      json['post_as'] as String?,
      json['text'] as String?,
    );

Map<String, dynamic> _$PostRequestToJson(PostRequest instance) =>
    <String, dynamic>{
      'post_as': instance.postAs,
      'text': instance.text,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      json['twter'] == null
          ? null
          : Twter.fromJson(json['twter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'twter': instance.twter,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['Type'] as String?,
      json['Username'] as String?,
      json['Avatar'] as String?,
      json['URL'] == null ? null : Uri.parse(json['URL'] as String),
      json['NFollowers'] as int?,
      json['NFollowing'] as int?,
      (json['Followers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      (json['Following'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      json['Tagline'] as String? ?? '',
      json['Muted'] as bool?,
      json['FollowedBy'] as bool?,
      json['Follows'] as bool?,
      (json['Links'] as List<dynamic>?)
          ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['Feeds'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'Type': instance.type,
      'Username': instance.username,
      'Avatar': instance.avatar,
      'URL': instance.uri?.toString(),
      'NFollowers': instance.nFollowers,
      'NFollowing': instance.nFollowing,
      'Followers': instance.followers,
      'Following': instance.following,
      'Tagline': instance.tagline,
      'Muted': instance.muted,
      'FollowedBy': instance.followedBy,
      'Follows': instance.follows,
      'Links': instance.links,
      'Feeds': instance.feeds,
    };

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
      json['URL'] as String?,
      json['Title'] as String?,
    );

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'Title': instance.title,
      'URL': instance.url,
    };
