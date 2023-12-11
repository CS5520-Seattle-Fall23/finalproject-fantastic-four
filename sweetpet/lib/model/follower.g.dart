// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follower _$FollowerFromJson(Map<String, dynamic> json) => Follower(
      json['id'] as String,
      json['followerId'] as String,
      json['toUserId'] as String,
      json['username'] as String,
      json['avatar'] as String,
      json['tag'] as bool,
    );

Map<String, dynamic> _$FollowerToJson(Follower instance) => <String, dynamic>{
      'id': instance.id,
      'followerId': instance.followerId,
      'toUserId': instance.toUserId,
      'avatar': instance.avatar,
      'username': instance.username,
      'tag': instance.tag,
    };
