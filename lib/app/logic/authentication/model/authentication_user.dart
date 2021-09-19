// ignore: import_of_legacy_library_into_null_safe
import 'package:bip39/bip39.dart' show generateMnemonic, mnemonicToSeedHex;

// ignore: import_of_legacy_library_into_null_safe
import 'package:dartsv/dartsv.dart';

import '../../logic.dart';

class AuthenticationUser extends User {
  final String mnemonic;

  AuthenticationUser({required this.mnemonic})
      : super(
            public: HDPrivateKey.fromSeed(
                    mnemonicToSeedHex(mnemonic), NetworkType.MAIN)
                .publicKey
                .toHex());

  static final empty = AuthenticationUser(
      mnemonic: List.generate(12, (index) => 'abandon').join(' '));

  bool get isEmpty => this == empty;

  bool get isNotEmpty => this != empty;

  static AuthenticationUser random() {
    final mnemonic = generateMnemonic();

    return AuthenticationUser(mnemonic: mnemonic);
  }

  static AuthenticationUser fromJson(Map<String, dynamic> map) {
    return AuthenticationUser(mnemonic: map['mnemonic']);
  }

  Map<String, dynamic> toJson() {
    return {'mnemonic': this.mnemonic};
  }
}
