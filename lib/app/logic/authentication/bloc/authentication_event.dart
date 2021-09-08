part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User user;

  AuthenticationUserChanged({required this.user});
}

class AuthenticationSignOut extends AuthenticationEvent {}
