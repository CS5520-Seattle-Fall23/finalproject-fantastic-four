import 'package:json_annotation/json_annotation.dart';
part 'thumb.g.dart';

@JsonSerializable()
class THUMB {
  String id;
  String authorId;
  String userId;
  String postId;
  int tag;

  THUMB(
    this.id,
    this.authorId,
    this.userId,
    this.postId,
    this.tag,
  );

  factory THUMB.fromJson(Map<String, dynamic> srcJson) =>
      _$THUMBFromJson(srcJson);
  Map<String, dynamic> toJson() => _$THUMBToJson(this);
}
