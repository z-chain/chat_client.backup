// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class User extends Equatable {
  /// 账户ID
  final String address;

  /// 头像
  String get avatar => 'https://api.multiavatar.com/$address.png';

  User({required this.address});

  /// 判断是否一致，只需要判断 address 是否一致即可
  @override
  List<Object?> get props => [address];
}

extension UserToMessageUser on User {
  types.User toMessageUser() {
    return types.User(id: this.address, imageUrl: this.avatar);
  }
}
