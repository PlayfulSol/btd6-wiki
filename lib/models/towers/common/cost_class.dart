class Cost {
  late final String easy;
  late final String medium;
  late final String hard;
  late final String impoppable;

  Cost(
    easy,
    medium,
    hard,
    impoppable,
  );

  Cost.fromJson(Map<String, dynamic> json) {
    easy = json['easy'] as String? ?? '';
    medium = json['medium'] as String? ?? '';
    hard = json['hard'] as String? ?? '';
    impoppable = json['impoppable'] as String? ?? '';
  }
}
