import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 1)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  late final String id;

  @HiveField(1)
  late final String name;

  @HiveField(2)
  late final String image;

  @HiveField(3)
  late final String type;

  @HiveField(4)
  late int itemIndex;

  FavoriteModel(this.id, this.name, this.image, this.type, this.itemIndex);
}
