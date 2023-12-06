// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['id'] as String,
      json['toPostId'] as String,
      json['nickname'] as String,
      json['avatar'] as String,
      json['content'] as String,
      json['createDate'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'toPostId': instance.toPostId,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'content': instance.content,
      'createDate': instance.createDate,
    };
