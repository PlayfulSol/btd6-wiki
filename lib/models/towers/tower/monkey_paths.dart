import '/models/towers/common/upgrade_info_class.dart';

class MonkeyPathsModel {
  List<UpgradeInfo> path1 = [];
  List<UpgradeInfo> path2 = [];
  List<UpgradeInfo> path3 = [];
  UpgradeInfo? paragon;

  MonkeyPathsModel(
    path1,
    path2,
    path3,
    paragon,
  );

  MonkeyPathsModel.fromJson(Map<String, dynamic> json) {
    json['path1'].forEach((path) {
      path1.add(UpgradeInfo.fromJson(path));
    });

    json['path2'].forEach((path) {
      path2.add(UpgradeInfo.fromJson(path));
    });

    json['path3'].forEach((path) {
      path3.add(UpgradeInfo.fromJson(path));
    });

    paragon = json['paragon'] is Map && !json['paragon'].isEmpty
        ? UpgradeInfo.fromJson(json['paragon'])
        : null;
  }
}
