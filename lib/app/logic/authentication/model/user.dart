import 'package:dartsv/dartsv.dart';
import 'package:equatable/equatable.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:bip39/bip39.dart' show generateMnemonic, mnemonicToSeedHex;

class User extends Equatable {
  final String id;

  HDPrivateKey get key => HDPrivateKey.fromSeed(id, NetworkType.MAIN);

  String get address => key.publicKey.toAddress(NetworkType.MAIN).address;

  String get avatar => 'https://api.multiavatar.com/$address.png';

  const User({required this.id});

  static const empty = User(id: '');

  bool get isEmpty => this == empty;

  bool get isNotEmpty => this != empty;

  @override
  List<Object?> get props => [id];

  factory User.fromJson(Map<String, dynamic> map) {
    return User(id: map['id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': this.id};
  }

  static User random() {
    final mnemonic = generateMnemonic();

    final seedHex = mnemonicToSeedHex(mnemonic);

    return User(id: seedHex);
  }
}
