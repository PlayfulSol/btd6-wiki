class Rounds {
  late final List<String> normal;
  late final List<String> abr;

  Rounds({required this.normal, required this.abr});

  Rounds.fromJson(Map<String, dynamic> json) {
    normal = List<String>.from(json['normal']);
    abr = List<String>.from(json['abr']);
  }
}
