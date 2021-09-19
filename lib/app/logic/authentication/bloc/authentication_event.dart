part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final AuthenticationUser user;

  AuthenticationUserChanged({required this.user});
}

class AuthenticationSignOut extends AuthenticationEvent {}
