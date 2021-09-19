import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../logic.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository repository;

  SignUpBloc({required this.repository}) : super(SignUpState.initial());

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignUpRandom:
        yield this.state.copyWith(user: User.random());
        break;
      case SignUpSubmitted:
        this.repository.signUp(state.user);
    }
  }
}
