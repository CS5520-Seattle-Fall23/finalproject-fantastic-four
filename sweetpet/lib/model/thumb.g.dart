// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

THUMB _$ThumbFromJson(Map<String, dynamic> json) => THUMB(
      json['id'] as String,
      json['userId'] as String,
      json['postId'] as String,
      json['tag'] as int,
    );

Map<String, dynamic> _$ThumbToJson(THUMB instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'postId': instance.postId,
      'tag': instance.tag,
    };
