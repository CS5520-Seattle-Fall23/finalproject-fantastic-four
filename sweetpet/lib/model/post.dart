import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  String id;
  String uid;
  String cover; // 封面
  String content;
  String avatar;
  String nickname;
  int fav;
  int like;
  int comment;

  Post(
    this.id,
    this.uid,
    this.cover,
    this.content,
    this.avatar,
    this.nickname,
    this.fav,
    this.like,
    this.comment,
  );

  factory Post.fromJson(Map<String, dynamic> srcJson) =>
      _$PostFromJson(srcJson);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
