part of 'authentication_bloc.dart';

@immutable
class AuthenticationState extends Equatable {
  final AuthenticationUser user;

  AuthenticationStatus get status => user.isNotEmpty
      ? AuthenticationStatus.authenticated
      : AuthenticationStatus.unauthenticated;

  const AuthenticationState._({required this.user});

  const AuthenticationState.authenticated(AuthenticationUser user)
      : this._(user: user);

  static final unauthenticated =
      AuthenticationState._(user: AuthenticationUser.empty);

  @override
  List<Object?> get props => [user, status];
}
