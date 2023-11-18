// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['id'] as int,
      json['uid'] as int,
      json['cover'] as String,
      json['content'] as String,
      json['avatar'] as String,
      json['nickname'] as String,
      json['fav'] as int,
      json['like'] as int,
      json['comment'] as int,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'cover': instance.cover,
      'content': instance.content,
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'fav': instance.fav,
      'like': instance.like,
      'comment': instance.comment,
    };
