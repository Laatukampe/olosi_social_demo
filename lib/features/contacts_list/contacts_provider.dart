import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/contact.dart';
import '../../data/repo/contact_repository.dart';
import '../../data/local/local_store.dart';

/// Provides access to the list of contacts. This notifier lazily loads
/// contacts from the repository on first use and exposes methods to
/// update individual contacts. UI components listen to this provider to
/// display and react to changes.
class ContactsNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  ContactsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final ContactRepository _repository;

  Future<void> _load() async {
    try {
      final contacts = await _repository.getContacts();
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Updates the status for a contact and refreshes the list. This ensures
  /// UI subscribers see the updated values immediately. Errors are
  /// propagated via the state to allow error handling.
  Future<void> updateContactStatus(
      {required String id, required int mood, required int body, required bool lonely}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateStatus(contactId: id, mood: mood, body: body, lonely: lonely);
      final contacts = await _repository.getContacts();
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Riverpod provider for the contacts notifier. It injects the
/// [ContactRepository] and ensures a single notifier instance is used
/// throughout the application.
final contactsProvider =
    StateNotifierProvider<ContactsNotifier, AsyncValue<List<Contact>>>((ref) {
  final repo = ContactRepository(LocalStore());
  return ContactsNotifier(repo);
});