import 'package:json_annotation/json_annotation.dart';

// 指向将会生成的文件
part 'follower.g.dart';

@JsonSerializable()
class Follower {
  final String id;
  final String avatarUrl;
  final String name;
  bool tag; // 注意：Bool 应该是 bool，Dart 的布尔类型是小写的

  Follower({
    required this.id,
    required this.avatarUrl,
    required this.name,
    required this.tag,
  });

  // 从 JSON 生成 Follower
  factory Follower.fromJson(Map<String, dynamic> json) =>
      _$FollowerFromJson(json);

  // 将 Follower 实例转换为 JSON
  Map<String, dynamic> toJson() => _$FollowerToJson(this);
}
