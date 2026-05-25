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
    easy = json['easy']?.toString() ?? '';
    medium = json['medium']?.toString() ?? '';
    hard = json['hard']?.toString() ?? '';
    impoppable = json['impoppable']?.toString() ?? '';
  }
}
