class Rounds {
  late final List<String> normal;
  late final List<String> abr;

  Rounds({required this.normal, required this.abr});

  Rounds.fromJson(Map<String, dynamic> json) {
    normal = _parseRounds(json['normal'] as Map<String, dynamic>?);
    abr = _parseRounds(json['alternate'] as Map<String, dynamic>?);
  }

  static List<String> _parseRounds(Map<String, dynamic>? data) {
    if (data == null) return [];
    final entries = data.entries.toList()
      ..sort((a, b) => (int.tryParse(a.key) ?? 0).compareTo(int.tryParse(b.key) ?? 0));
    return entries.map((e) => 'Round ${e.key}: ${e.value}').toList();
  }
}
