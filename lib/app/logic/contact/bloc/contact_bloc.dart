import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../contact.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;

  late StreamSubscription _streamSubscription;

  ContactBloc({required this.repository})
      : super(ContactState.initial(repository.currentContact)) {
    _streamSubscription = repository.contact.listen(_onContactChanged);
  }

  void _onContactChanged(List<Contact> contacts) =>
      this.add(ContactChanged(contacts: contacts));

  @override
  Stream<ContactState> mapEventToState(
    ContactEvent event,
  ) async* {
    if (event is ContactChanged) {
      yield this.state.copyWith(friends: event.contacts);
    } else if (event is ContactAdded) {
      repository.add(event.contact);
    } else if (event is ContactRemoved) {
      repository.remove(event.contact);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
