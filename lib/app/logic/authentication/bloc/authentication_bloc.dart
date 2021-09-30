import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_client/app/logic/authentication/model/authentication_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../logic.dart';
import '../authentication.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;

  final ChatRepository message;

  late StreamSubscription _userStreamSubscription;

  AuthenticationBloc({required this.repository, required this.message})
      : super(repository.currentUser.isNotEmpty
            ? AuthenticationState.authenticated(repository.currentUser)
            : AuthenticationState.unauthenticated) {
    _userStreamSubscription = repository.user.listen(_onUserChanged);
    if (this.state.status == AuthenticationStatus.authenticated) {
      _onUserChanged(this.state.user);
    }
  }

  void _onUserChanged(AuthenticationUser user) =>
      this.add(AuthenticationUserChanged(user: user));

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield* _mapUserChangedToState(event, state);
    } else if (event is AuthenticationSignOut) {
      await repository.signOut();
    }
  }

  Stream<AuthenticationState> _mapUserChangedToState(
      AuthenticationUserChanged event, AuthenticationState state) async* {
    if (event.user.isNotEmpty) {
      await this.message.connect(
          host: 'broker-cn.emqx.io', port: 1883, clientId: event.user.address);
      this.message.subscribe('z-chain/chat/message/${event.user.address}');
      yield AuthenticationState.authenticated(event.user);
    } else {
      this.message.disconnect();
      yield AuthenticationState.unauthenticated;
    }
  }

  @override
  Future<void> close() {
    _userStreamSubscription.cancel();
    return super.close();
  }
}
