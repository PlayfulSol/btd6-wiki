import '/models/base/base_model.dart';

class BaseHero extends BaseModel {
  late final int easyCost;
  late final int mediumCost;
  late final int hardCost;
  late final int impoppableCost;

  BaseHero(
    super.id,
    super.name,
    super.image,
    super.type,
    this.easyCost,
    this.mediumCost,
    this.hardCost,
    this.impoppableCost, {
    super.changes,
  });

  static int _parseCost(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().replaceAll(',', '')) ?? 0;
  }

  BaseHero.fromJson(Map<String, dynamic> json)
      : easyCost = _parseCost(json['cost']?['easy']),
        mediumCost = _parseCost(json['cost']?['medium']),
        hardCost = _parseCost(json['cost']?['hard']),
        impoppableCost = _parseCost(json['cost']?['impoppable']),
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
          changes: json['changes'] as String?,
        );
}
