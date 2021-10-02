part of 'contact_bloc.dart';

@immutable
class ContactState {

  final List<Contact> contacts;

  ContactState({required this.contacts});

  factory ContactState.initial(List<Contact> friends) =>
      ContactState(contacts: friends);

  ContactState copyWith({List<Contact>? friends}) {
    return ContactState(contacts: friends ?? this.contacts);
  }
}
