part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final AuthenticationUser user;

  SignUpState({required this.user});

  @override
  List<Object?> get props => [user];

  factory SignUpState.initial() => SignUpState(user: AuthenticationUser.random());

  SignUpState copyWith({AuthenticationUser? user}) {
    return SignUpState(user: user ?? this.user);
  }
}
