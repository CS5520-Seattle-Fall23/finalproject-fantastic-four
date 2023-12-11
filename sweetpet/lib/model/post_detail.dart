import 'package:json_annotation/json_annotation.dart';

part 'post_detail.g.dart';

@JsonSerializable()
class PostDetail {
  String id;
  String uid;
  String title;
  String content;
  String avatar;
  String nickname;
  int fav;
  int comment;
  String date;
  List<String> images;

  PostDetail(this.id, this.uid, this.title, this.content, this.avatar,
      this.nickname, this.fav, this.comment, this.date, this.images);

  factory PostDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$PostDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}
