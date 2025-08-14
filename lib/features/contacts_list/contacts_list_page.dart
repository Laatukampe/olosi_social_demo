import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/contact.dart';
import '../status_set/emoji_sets.dart';
import '../status_set/emoji_selector.dart';
import 'contacts_provider.dart';

/// Displays a table-like view of all contacts. Each row shows the contact
/// name, mood, body and loneliness status. The header row is sticky at the
/// top. Users can tap on the emoji cells to change values or toggle
/// loneliness via a checkbox.
class ContactsListPage extends ConsumerWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yleisnäkymä'),
      ),
      body: contactsAsync.when(
        data: (contacts) => _buildList(context, ref, contacts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Virhe: $err')),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Contact> contacts) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          _HeaderRow(),
          ...contacts.map((c) => _ContactRow(contact: c)).toList(),
        ],
      ),
    );
  }
}

/// Header row with column labels. Uses uppercase text and muted colour to
/// differentiate from data rows.
class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: OlosiColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: const [
          Expanded(
            flex: 12,
            child: Text(
              'NIMI',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.06,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'MIELI',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.06,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'VOINTI',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.06,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'SEURA',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.06,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual contact row with interactive emoji and checkbox cells. When
/// selecting an emoji, a bottom sheet is displayed allowing the user to
/// choose a new value. Toggling the checkbox updates the loneliness state.
class _ContactRow extends ConsumerWidget {
  const _ContactRow({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(contactsProvider.notifier);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: OlosiColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                contact.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (context) => EmojiSelector(
                    title: 'Valitse mieli',
                    emojiMap: EmojiSets.mood,
                    selectedValue: contact.mood,
                  ),
                );
                if (result != null) {
                  notifier.updateContactStatus(
                      id: contact.id,
                      mood: result,
                      body: contact.body,
                      lonely: contact.lonely);
                }
              },
              child: Semantics(
                label: 'Mieli: ${EmojiSets.mood[contact.mood]}',
                button: true,
                child: Center(
                  child: Text(
                    EmojiSets.mood[contact.mood] ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (context) => EmojiSelector(
                    title: 'Valitse vointi',
                    emojiMap: EmojiSets.body,
                    selectedValue: contact.body,
                  ),
                );
                if (result != null) {
                  notifier.updateContactStatus(
                      id: contact.id,
                      mood: contact.mood,
                      body: result,
                      lonely: contact.lonely);
                }
              },
              child: Semantics(
                label: 'Vointi: ${EmojiSets.body[contact.body]}',
                button: true,
                child: Center(
                  child: Text(
                    EmojiSets.body[contact.body] ?? '',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Center(
              child: Checkbox(
                value: contact.lonely,
                onChanged: (val) {
                  final newVal = val ?? false;
                  notifier.updateContactStatus(
                      id: contact.id,
                      mood: contact.mood,
                      body: contact.body,
                      lonely: newVal);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}