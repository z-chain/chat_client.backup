import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;

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
}
