import 'package:json_annotation/json_annotation.dart';
part 'mall.g.dart';

@JsonSerializable()
class Mall {
  String title;
  String dealLink;
  String realBuyLink;
  String store;
  String price;
  String redPrice;
  int thumbs;
  String views;
  String pic;

  Mall(
    this.title,
    this.dealLink,
    this.realBuyLink,
    this.store,
    this.price,
    this.redPrice,
    this.thumbs,
    this.views,
    this.pic,
  );

  factory Mall.fromJson(Map<String, dynamic> srcJson) =>
      _$MallFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MallToJson(this);
}
