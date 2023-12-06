import 'package:json_annotation/json_annotation.dart';
part 'thumb.g.dart';

@JsonSerializable()
class THUMB {
  String id;
  String userId;
  String postId;
  int tag;

  THUMB(
    this.id,
    this.userId,
    this.postId,
    this.tag,
  );

  factory THUMB.fromJson(Map<String, dynamic> srcJson) =>
      _$ThumbFromJson(srcJson);
  Map<String, dynamic> toJson() => _$ThumbToJson(this);
}
