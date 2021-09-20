// ignore: import_of_legacy_library_into_null_safe
import 'package:dartsv/dartsv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class User extends Equatable {
  final String public;

  String get address =>
      SVPublicKey.fromHex(public).toAddress(NetworkType.MAIN).toBase58();

  String get avatar => 'https://api.multiavatar.com/$public.png';

  const User({required this.public});

  @override
  List<Object?> get props => [public];

  static const empty = User(public: '');

  factory User.fromJson(Map<String, dynamic> map) {
    return User(public: map['public']);
  }

  Map<String, dynamic> toJson() {
    return {'public': public};
  }
}

extension UserToMessageUser on User {
  types.User toMessageUser() {
    return types.User(id: this.public, imageUrl: this.avatar);
  }
}
