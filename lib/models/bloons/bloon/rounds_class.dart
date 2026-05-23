class Rounds {
  late final List<String> normal;
  late final List<String> abr;

  Rounds({required this.normal, required this.abr});

  Rounds.fromJson(Map<String, dynamic> json) {
    normal = _parseRounds(json['normal']);
    abr = _parseRounds(json['alternate'] ?? json['abr']);
  }

  static List<String> _parseRounds(dynamic data) {
    if (data == null) return [];
    if (data is List) return List<String>.from(data);
    if (data is Map) {
      final entries = data.entries.toList()
        ..sort((a, b) {
          final ai = int.tryParse(a.key.toString()) ?? 0;
          final bi = int.tryParse(b.key.toString()) ?? 0;
          return ai.compareTo(bi);
        });
      return entries.map((e) => 'Round ${e.key}: ${e.value}').toList();
    }
    return [];
  }
}
