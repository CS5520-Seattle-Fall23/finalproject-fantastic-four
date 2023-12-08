// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mall _$MallFromJson(Map<String, dynamic> json) => Mall(
      json['title'] as String,
      json['dealLink'] as String,
      json['realBuyLink'] as String,
      json['store'] as String,
      json['price'] as String,
      json['redPrice'] as String,
      json['thumbs'] as int,
      json['views'].toString(),
      json['pic'] as String,
    );

Map<String, dynamic> _$MallToJson(Mall instance) => <String, dynamic>{
      'title': instance.title,
      'dealLink': instance.dealLink,
      'realBuyLink': instance.realBuyLink,
      'store': instance.store,
      'price': instance.price,
      'redPrice': instance.redPrice,
      'thumbs': instance.thumbs,
      'views': instance.views,
      'pic': instance.pic,
    };
