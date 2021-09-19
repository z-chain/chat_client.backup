part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final User user;

  SignUpState({required this.user});

  @override
  List<Object?> get props => [user];

  factory SignUpState.initial() => SignUpState(user: User.random());

  SignUpState copyWith({User? user}) {
    return SignUpState(user: user ?? this.user);
  }
}
