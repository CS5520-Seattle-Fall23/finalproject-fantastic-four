import 'package:json_annotation/json_annotation.dart';

// 指向将会生成的文件
part 'follower.g.dart';

@JsonSerializable()
class Follower {
  String id;
  String followerId;
  String toUserId;
  String avatar;
  String username;
  bool tag;

  Follower(
    this.id,
    this.followerId,
    this.toUserId,
    this.username,
    this.avatar,
    this.tag,
  );

  // 从 JSON 生成 Follower
  factory Follower.fromJson(Map<String, dynamic> json) =>
      _$FollowerFromJson(json);

  // 将 Follower 实例转换为 JSON
  Map<String, dynamic> toJson() => _$FollowerToJson(this);
}
