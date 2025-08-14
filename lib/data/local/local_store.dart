import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact.dart';

/// Handles local persistence of contacts and their statuses. The demo uses
/// [SharedPreferences] to store a list of all contacts and individual
/// contact statuses by key. This class abstracts the underlying storage
/// mechanism to allow future replacement by more robust solutions.
class LocalStore {
  static const _contactsKey = 'contacts';

  /// Saves a list of contacts to local storage. The full list is stored as
  /// JSON to allow restoration on subsequent launches.
  Future<void> saveContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = contacts.map((c) => c.toJson()).toList();
    await prefs.setString(_contactsKey, jsonEncode(jsonList));
  }

  /// Loads all contacts from local storage. If no contacts are stored, an
  /// empty list is returned. If the stored data cannot be parsed, the data
  /// will be cleared and an empty list returned.
  Future<List<Contact>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_contactsKey);
    if (jsonString == null) return [];
    try {
      final List decoded = jsonDecode(jsonString) as List;
      return decoded
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupted data; clear and return empty
      await prefs.remove(_contactsKey);
      return [];
    }
  }

  /// Saves an individual contact's status fields. We only persist mood,
  /// body and lonely state, leaving other fields intact. This method will
  /// fetch existing contacts, update the matching contact, and re-save the
  /// list. If the contact ID doesn't exist, it will be ignored.
  Future<void> saveContactStatus(
      {required String contactId,
      required int mood,
      required int body,
      required bool lonely}) async {
    final contacts = await loadContacts();
    final index = contacts.indexWhere((c) => c.id == contactId);
    if (index == -1) return;
    final contact = contacts[index];
    contact
      ..mood = mood
      ..body = body
      ..lonely = lonely
      ..updatedAt = DateTime.now();
    await saveContacts(contacts);
  }
}