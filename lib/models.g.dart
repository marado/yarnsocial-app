// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return AppUser(
    token: json['token'] as String?,
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    twter: json['twter'] == null
        ? null
        : Twter.fromJson(json['twter'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'profile': instance.profile,
      'token': instance.token,
      'twter': instance.twter,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['Username'] as String?,
    json['Tagline'] as String?,
    json['Email'] as String?,
    json['IsFollowersPubliclyVisible'] as bool?,
    json['IsFollowingPubliclyVisible'] as bool?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Username': instance.username,
      'Tagline': instance.tagline,
      'Email': instance.email,
      'IsFollowersPubliclyVisible': instance.isFollowersPubliclyVisible,
      'IsFollowingPubliclyVisible': instance.isFollowingPubliclyVisible,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return AuthResponse(
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

PagerResponse _$PagerResponseFromJson(Map<String, dynamic> json) {
  return PagerResponse(
    currentPage: json['current_page'] as int?,
    maxPages: json['max_pages'] as int?,
    totalTwts: json['total_twts'] as int?,
  );
}

Map<String, dynamic> _$PagerResponseToJson(PagerResponse instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'max_pages': instance.maxPages,
      'total_twts': instance.totalTwts,
    };

Twter _$TwterFromJson(Map<String, dynamic> json) {
  return Twter(
    nick: json['nick'] as String?,
    uri: json['url'] == null ? null : Uri.parse(json['url'] as String),
    avatar: json['avatar'] == null ? null : Uri.parse(json['avatar'] as String),
    slug: json['slug'] as String?,
  );
}

Map<String, dynamic> _$TwterToJson(Twter instance) => <String, dynamic>{
      'nick': instance.nick,
      'url': instance.uri?.toString(),
      'avatar': instance.avatar?.toString(),
      'slug': instance.slug,
    };

Twt _$TwtFromJson(Map<String, dynamic> json) {
  return Twt(
    twter: json['twter'] == null
        ? null
        : Twter.fromJson(json['twter'] as Map<String, dynamic>),
    text: json['text'] as String?,
    markdownText: json['markdownText'] as String?,
    createdTime: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    hash: json['hash'] as String?,
    tags: (json['tags'] as List?)?.map((e) => e as String)?.toList(),
    subject: json['subject'] as String?,
  );
}

Map<String, dynamic> _$TwtToJson(Twt instance) => <String, dynamic>{
      'twter': instance.twter,
      'text': instance.text,
      'markdownText': instance.markdownText,
      'created': instance.createdTime?.toIso8601String(),
      'hash': instance.hash,
      'tags': instance.tags,
      'subject': instance.subject,
    };

PagedResponse _$PagedResponseFromJson(Map<String, dynamic> json) {
  return PagedResponse(
    json['twts'] == null
        ? []
        : (json['twts'] as List)
            .map((e) => Twt.fromJson(e as Map<String, dynamic>))
            .toList(),
    PagerResponse.fromJson(json['Pager'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PagedResponseToJson(PagedResponse instance) =>
    <String, dynamic>{
      'twts': instance.twts,
      'Pager': instance.pagerResponse,
    };

PostRequest _$PostRequestFromJson(Map<String, dynamic> json) {
  return PostRequest(
    json['post_as'] as String?,
    json['text'] as String?,
  );
}

Map<String, dynamic> _$PostRequestToJson(PostRequest instance) =>
    <String, dynamic>{
      'post_as': instance.postAs,
      'text': instance.text,
    };

ConfigResponse _$ConfigResponseFromJson(Map<String, dynamic> json) {
  return ConfigResponse(
    json["name"] as String,
    json["logo"] as String,
    json["description"] as String,
    json["max_twt_length"] as int,
    json["open_profiles"] as bool,
    json["open_registrations"] as bool,
    json["whitelisted_domains"] as List<String>,
  );
}

Map<String, dynamic> _$ConfigResponseToJson(ConfigResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'logo': instance.logo,
      'description': instance.description,
      'max_twt_length': instance.maxTwtLength,
      'open_profiles': instance.openProfiles,
      'open_registrations': instance.openRegistrations,
      'whitedlisted_domains': instance.whitelistedDomains,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) {
  return ProfileResponse(
    Profile.fromJson(json['profile'] as Map<String, dynamic>),
    json['links'] == null
        ? null
        : (json['links'] as List)
            .map((e) => Link.fromJson(e as Map<String, dynamic>))
            .toList(),
    json['alternatives'] == null
        ? null
        : (json['alternatives'] as List)
            .map((e) => Alternative.fromJson(e as Map<String, dynamic>))
            .toList(),
    Twter.fromJson(json['twter'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'links': instance.links,
      'alternatives': instance.alternatives,
      'twter': instance.twter,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['Type'] as String?,
    json['Username'] as String?,
    json['URL'] == null ? null : Uri.parse(json['URL'] as String),
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
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'Type': instance.type,
      'Username': instance.username,
      'URL': instance.uri?.toString(),
      'Followers': instance.followers,
      'Following': instance.following,
      'Tagline': instance.tagline,
      'Muted': instance.muted,
      'FollowedBy': instance.followedBy,
      'Follows': instance.follows,
    };

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
    json['Href'] as String?,
    json['Rel'] as String?,
  );
}

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'Href': instance.href,
      'Rel': instance.rel,
    };

Alternative _$AlternativeFromJson(Map<String, dynamic> json) {
  return Alternative(
    json['Type'] as String?,
    json['Title'] as String?,
    json['URL'] as String?,
  );
}

Map<String, dynamic> _$AlternativeToJson(Alternative instance) =>
    <String, dynamic>{
      'Type': instance.type,
      'Title': instance.title,
      'URL': instance.url,
    };
