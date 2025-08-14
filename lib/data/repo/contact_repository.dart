import 'dart:math';

import '../local/local_store.dart';
import '../models/contact.dart';

/// Repository responsible for providing access to contacts. It seeds a list
/// of 50 demo contacts on first launch, each with a random mood, body and
/// loneliness value. Subsequent calls return the locally stored data.
class ContactRepository {
  ContactRepository(this._store);

  final LocalStore _store;

  /// Returns all contacts, loading from shared preferences or generating
  /// them on first launch. If no stored contacts exist, 50 fake contacts
  /// will be created.
  Future<List<Contact>> getContacts() async {
    final existing = await _store.loadContacts();
    if (existing.isNotEmpty) return existing;
    final seeded = _generateContacts();
    await _store.saveContacts(seeded);
    return seeded;
  }

  /// Updates the status of a contact.
  Future<void> updateStatus(
      {required String contactId,
      required int mood,
      required int body,
      required bool lonely}) {
    return _store.saveContactStatus(
        contactId: contactId, mood: mood, body: body, lonely: lonely);
  }

  /// Generates a list of 50 demo contacts with Finnish-sounding names and
  /// phone numbers. Each contact is assigned a random mood and body status
  /// and a random loneliness flag. Randomisation ensures a varied starting
  /// dataset for the demo.
  List<Contact> _generateContacts() {
    final rng = Random();
    final names = [
      'Pekka',
      'Jussi',
      'Pauna',
      'Pasi',
      'Matti',
      'Liisa',
      'Kari',
      'Saara',
      'Teemu',
      'Pirjo',
      'Eero',
      'Aino',
      'Tapio',
      'Outi',
      'Janne',
      'Marja',
      'Olli',
      'Sanna',
      'Markku',
      'Helmi',
      'Aleksi',
      'Essi',
      'Hannu',
      'Anni',
      'Ville',
      'Leena',
      'Jari',
      'Merja',
      'Heikki',
      'Johanna',
      'Lauri',
      'Hanna',
      'Antti',
      'Tarja',
      'Sami',
      'Katja',
      'Juha',
      'Riikka',
      'Mikko',
      'Tuija',
      'Mervi',
      'Petri',
      'Nina',
      'Risto',
      'Annika',
      'Vesa',
      'Eeva',
      'Johannes',
      'Kerttu',
      'Seppo'
    ];
    final contacts = <Contact>[];
    for (var i = 0; i < 50; i++) {
      final name = names[i % names.length];
      final phone = _generatePhoneNumber(rng);
      contacts.add(Contact(
        id: 'c$i',
        name: name,
        phone: phone,
        mood: rng.nextInt(5) + 1,
        body: rng.nextInt(5) + 1,
        lonely: rng.nextBool(),
        updatedAt: DateTime.now(),
      ));
    }
    return contacts;
  }

  /// Generates a Finnish-looking phone number in the format +358 4xx xxx xxx.
  String _generatePhoneNumber(Random rng) {
    final digits = List.generate(7, (_) => rng.nextInt(10));
    // Format: +358 4xx xxx xxx
    return '+358 4${digits[0]}${digits[1]} ${digits[2]}${digits[3]}${digits[4]} ${digits[5]}${digits[6]}${rng.nextInt(10)}';
  }
}