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

  Cost.fromJson(dynamic json) {
    try {
      easy = json['easy'];
      medium = json['medium'];
      hard = json['hard'];
      impoppable = json['impoppable'];
    } catch (e) {
      easy = json;
      medium = json;
      hard = json;
      impoppable = json;
    }
  }
}
