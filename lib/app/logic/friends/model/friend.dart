import '../../logic.dart';

class Friend extends User {
  final String? remarks;

  Friend({required String public, this.remarks}) : super(public: public);

  factory Friend.fromJson(Map<String, dynamic> map) {
    return Friend(public: map['public'], remarks: map['remarks']);
  }

  Map<String, dynamic> toJson() {
    return {'public': public, 'remarks': remarks};
  }
}
