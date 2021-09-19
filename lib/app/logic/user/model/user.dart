// ignore: import_of_legacy_library_into_null_safe
import 'package:dartsv/dartsv.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String public;

  String get address =>
      SVPublicKey.fromHex(public).toAddress(NetworkType.MAIN).toBase58();

  String get avatar => 'https://api.multiavatar.com/$address.png';

  const User({required this.public});

  @override
  List<Object?> get props => [address];
}
