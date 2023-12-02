// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follower _$FollowerFromJson(Map<String, dynamic> json) => Follower(
      id: json['id'] as String,
      avatarUrl: json['avatarUrl'] as String,
      name: json['name'] as String,
      tag: json['tag'] as bool,
    );

Map<String, dynamic> _$FollowerToJson(Follower instance) => <String, dynamic>{
      'id': instance.id,
      'avatarUrl': instance.avatarUrl,
      'name': instance.name,
      'tag': instance.tag,
    };
