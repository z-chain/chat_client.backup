part of 'sign_up_bloc.dart';

abstract class SignUpEvent {
  const SignUpEvent();
}

class SignUpRandom extends SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {}
