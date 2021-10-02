part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent {}

class ContactAdded extends ContactEvent {
  final Contact contact;

  ContactAdded({required this.contact});
}

class ContactRemoved extends ContactEvent {
  final Contact contact;

  ContactRemoved({required this.contact});
}

class ContactChanged extends ContactEvent {
  final List<Contact> contacts;

  ContactChanged({required this.contacts});
}
