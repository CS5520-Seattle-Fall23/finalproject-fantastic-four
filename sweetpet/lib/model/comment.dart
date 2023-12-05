import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String id;
  String toPostId;
  String nickname;
  String avatar;
  String content;
  String createDate;
  int like;
  bool isLike = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Comment> replyCommentList = [];

  Comment(this.id, this.toPostId, this.nickname, this.avatar, this.content,
      this.createDate, this.like, this.isLike);

  factory Comment.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
