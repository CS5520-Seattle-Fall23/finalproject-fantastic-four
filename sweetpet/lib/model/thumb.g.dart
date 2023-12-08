// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

THUMB _$THUMBFromJson(Map<String, dynamic> json) => THUMB(
      json['id'] as String,
      json['authorId'] as String,
      json['userId'] as String,
      json['postId'] as String,
      json['tag'] as int,
    );

Map<String, dynamic> _$THUMBToJson(THUMB instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'userId': instance.userId,
      'postId': instance.postId,
      'tag': instance.tag,
    };
