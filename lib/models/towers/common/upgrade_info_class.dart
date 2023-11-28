import 'cost_class.dart';

class UpgradeInfo {
  late final String name;
  late final String image;
  late final String upgradeBody;
  late final Cost cost;

  UpgradeInfo(
    name,
    description,
    cost,
    effects,
  );

  UpgradeInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json["image"];
    upgradeBody = json['upgradeBody'];
    cost = Cost.fromJson(json['cost']);
  }
}
