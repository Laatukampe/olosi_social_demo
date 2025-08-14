/// Representation of a social contact in the OLOSI demo. Each contact
/// maintains its own mood (mieli), body condition (vointi) and loneliness
/// status (seura). The `updatedAt` field can be used to sort contacts by
/// recency or display relative update times.
class Contact {
  final String id;
  final String name;
  final String phone;
  int mood; // 1..5 – see emoji mappings in EmojiSets
  int body; // 1..5 – see emoji mappings in EmojiSets
  bool lonely;
  DateTime updatedAt;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.mood,
    required this.body,
    required this.lonely,
    required this.updatedAt,
  });

  /// Converts this contact into a serialisable map for persistence.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'mood': mood,
        'body': body,
        'lonely': lonely,
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Restores a contact from its persisted representation. Throws if
  /// mandatory fields are missing.
  static Contact fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        mood: json['mood'] as int,
        body: json['body'] as int,
        lonely: json['lonely'] as bool,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}