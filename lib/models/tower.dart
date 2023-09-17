import '/models/common.dart';

class TowerModel {
  late final String id;
  late final String image;
  late final String name;
  late final String inGameDesc;
  late final String type;

  TowerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    inGameDesc = json['inGameDesc'];
    type = json['type'];
  }

  TowerModel(id, name, description, type);
}

class SingleTowerModel {
  late final String id;
  late final String image;
  late final String name;
  late final String inGameDesc;
  late final String type;
  late final Cost cost;
  late final Stats stats;
  late final MonkeyPathsModel paths;

  SingleTowerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json["image"];
    name = json['name'];
    inGameDesc = json['inGameDesc'];
    type = json['type'];
    cost = Cost.fromJson(json['cost']);
    stats = Stats.fromJson(json['stats']);
    paths = MonkeyPathsModel.fromJson(json['paths']);
  }

  SingleTowerModel(id, name, description, type, cost, stats, paths);
}

class MonkeyPathsModel {
  List<MonkeyPathModel> path1 = [];
  List<MonkeyPathModel> path2 = [];
  List<MonkeyPathModel> path3 = [];
  MonkeyPathModel? paragon;

  MonkeyPathsModel(
      {required path1, required path2, required path3, this.paragon});

  MonkeyPathsModel.fromJson(Map<String, dynamic> json) {
    json['path1'].forEach((path) {
      path1.add(MonkeyPathModel.fromJson(path));
    });

    json['path2'].forEach((path) {
      path2.add(MonkeyPathModel.fromJson(path));
    });

    json['path3'].forEach((path) {
      path3.add(MonkeyPathModel.fromJson(path));
    });

    paragon = json['paragon'] != null
        ? MonkeyPathModel.fromJson(json['paragon'])
        : null;
  }
}

class MonkeyPathModel {
  late final String name;
  late final String image;
  late final String upgradeBody;
  // late final String unlock;
  late final Cost cost;

  MonkeyPathModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json["image"];
    upgradeBody = json['upgradeBody'];
    // unlock = json['unlock'];
    cost = Cost.fromJson(json['cost']);
  }

  MonkeyPathModel(name, description, cost, effects);
}
