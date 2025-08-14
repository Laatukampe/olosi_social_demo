import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Bottom sheet for selecting an emoji from a supplied map. The keys of the
/// map correspond to the values returned to the caller. Once an emoji is
/// selected the sheet closes and returns the associated key.
class EmojiSelector extends StatelessWidget {
  const EmojiSelector({
    Key? key,
    required this.title,
    required this.emojiMap,
    required this.selectedValue,
  }) : super(key: key);

  final String title;
  final Map<int, String> emojiMap;
  final int selectedValue;

  @override
  Widget build(BuildContext context) {
    final items = emojiMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Container(
      decoration: BoxDecoration(
        color: OlosiColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: items.map((e) {
              final bool selected = e.key == selectedValue;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(e.key);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? OlosiColors.primaryLight
                        : OlosiColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e.value,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}