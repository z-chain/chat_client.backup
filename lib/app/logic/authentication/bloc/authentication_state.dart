part of 'authentication_bloc.dart';

@immutable
class AuthenticationState extends Equatable {
  final User user;

  AuthenticationStatus get status => user.isNotEmpty
      ? AuthenticationStatus.authenticated
      : AuthenticationStatus.unauthenticated;

  const AuthenticationState._({required this.user});

  const AuthenticationState.authenticated(User user) : this._(user: user);

  const AuthenticationState.unauthenticated() : this._(user: User.empty);

  @override
  List<Object?> get props => [user, status];
}
