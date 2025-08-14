import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../core/theme.dart';
import 'emoji_sets.dart';
import 'emoji_selector.dart';

/// Screen allowing the user to set their own mood, body state and
/// loneliness (seura) status. Upon saving the user is taken to the
/// contacts list page. The UI emphasises accessibility with large
/// touch targets and semantics.
class StatusSetPage extends ConsumerStatefulWidget {
  const StatusSetPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusSetPage> createState() => _StatusSetPageState();
}

class _StatusSetPageState extends ConsumerState<StatusSetPage> {
  int _mood = 3; // Default neutral
  int _body = 3; // Default neutral
  bool _lonely = false;

  void _openMoodSelector() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => EmojiSelector(
        title: 'Valitse mieli',
        emojiMap: EmojiSets.mood,
        selectedValue: _mood,
      ),
    );
    if (result != null) {
      setState(() => _mood = result);
    }
  }

  void _openBodySelector() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => EmojiSelector(
        title: 'Valitse vointi',
        emojiMap: EmojiSets.body,
        selectedValue: _body,
      ),
    );
    if (result != null) {
      setState(() => _body = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodEmoji = EmojiSets.mood[_mood] ?? '';
    final bodyEmoji = EmojiSets.body[_body] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('OLOSI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusCard(
              title: 'MIELI',
              child: Text(
                moodEmoji,
                style: const TextStyle(fontSize: 48),
              ),
              onTap: _openMoodSelector,
              semanticsLabel: 'Mieli: ${_describeMood(_mood)}',
            ),
            const SizedBox(height: 16),
            _StatusCard(
              title: 'VOINTI',
              child: Text(
                bodyEmoji,
                style: const TextStyle(fontSize: 48),
              ),
              onTap: _openBodySelector,
              semanticsLabel: 'Vointi: ${_describeBody(_body)}',
            ),
            const SizedBox(height: 16),
            _StatusCard(
              title: 'SEURA',
              child: Checkbox(
                value: _lonely,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _lonely = val);
                },
              ),
              onTap: () => setState(() => _lonely = !_lonely),
              semanticsLabel:
                  'Seura: ${_lonely ? 'yksinäinen' : 'ei yksinäinen'}',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // In a full implementation we'd persist the user's own status
                // here. For the demo we simply navigate to the contacts list.
                App.goToContacts(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OlosiColors.primary,
                foregroundColor: OlosiColors.text,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tallenna'),
            ),
          ],
        ),
      ),
    );
  }

  String _describeMood(int value) {
    switch (value) {
      case 1:
        return 'surullinen';
      case 2:
        return 'alakuloinen';
      case 3:
        return 'neutraali';
      case 4:
        return 'iloinen';
      case 5:
        return 'onnellinen';
      default:
        return '';
    }
  }

  String _describeBody(int value) {
    switch (value) {
      case 1:
        return 'sairas';
      case 2:
        return 'väsynyt';
      case 3:
        return 'flunssainen';
      case 4:
        return 'kylmä';
      case 5:
        return 'voimakas';
      default:
        return '';
    }
  }
}

/// A reusable card widget for presenting a status property. Tapping the card
/// invokes the provided [onTap] callback. Semantics are injected via
/// [semanticsLabel] for accessibility support.
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.child,
    required this.onTap,
    required this.semanticsLabel,
  });

  final String title;
  final Widget child;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                        color: OlosiColors.muted,
                      ),
                ),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}