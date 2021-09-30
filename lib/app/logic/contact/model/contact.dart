// ignore: import_of_legacy_library_into_null_safe
import 'package:dartsv/dartsv.dart';

import '../../logic.dart';

class Contact extends User {
  /// 备注
  final String? remark;

  /// 公钥
  final String public;

  Contact({required this.public, this.remark})
      : super(
            address: SVPublicKey.fromHex(public)
                .toAddress(NetworkType.MAIN)
                .toBase58());

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(public: map['public'], remark: map['remark']);
  }

  Map<String, dynamic> toJson() {
    return {'public': public, 'remark': remark};
  }
}
