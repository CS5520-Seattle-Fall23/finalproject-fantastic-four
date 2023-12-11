import 'package:json_annotation/json_annotation.dart';
part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  final String username;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> srcJson) =>
      _$UserModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
