/// Provides static emoji mappings for the status setting UI. The numerical
/// values correspond to mood and body condition levels, making it easy to
/// store selections in local state and preferences. When updating these
/// values ensure the ordering remains consistent so that indexes align.
class EmojiSets {
  static const mood = {
    1: '😭',
    2: '🙁',
    3: '😐',
    4: '🙂',
    5: '😀',
  };
  static const body = {
    1: '🤕',
    2: '🫤',
    3: '🤒',
    4: '🥶',
    5: '💪',
  };

  /// Returns an iterable of mood emojis in ascending order of their keys.
  static Iterable<String> get moodEmojis =>
      List<int>.from(mood.keys)..sort((a, b) => a.compareTo(b))
      .map((k) => mood[k]!);

  /// Returns an iterable of body emojis in ascending order of their keys.
  static Iterable<String> get bodyEmojis =>
      List<int>.from(body.keys)..sort((a, b) => a.compareTo(b))
      .map((k) => body[k]!);
}