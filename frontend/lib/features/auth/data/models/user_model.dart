import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    @JsonKey(name: 'first_name') required super.firstName,
    @JsonKey(name: 'last_name') required super.lastName,
    @JsonKey(name: 'created_at') required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      createdAt: user.createdAt,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      createdAt: createdAt,
    );
  }
}
