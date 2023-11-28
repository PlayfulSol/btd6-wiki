import '../common/speed_class.dart';
import '../common/variant_class.dart';
import 'rounds_class.dart';

class SingleBloonModel {
  late final String name;
  late final String fullName;
  late final String image;
  late final List<dynamic> rbe;
  late final Speed speed;
  late final List<dynamic> children;
  late final List<dynamic> parents;
  late final List<Variant> variants;
  late final Rounds rounds;

  SingleBloonModel(
      {required this.name,
      required this.image,
      required this.rbe,
      required this.speed,
      required this.children,
      required this.parents,
      required this.variants,
      required this.rounds});

  SingleBloonModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fullName = json['fullName'];
    image = json['image'];
    rbe = json['rbe'];
    speed = Speed.fromJson(json['speed']);
    children = json['children'];
    parents = json['parents'];
    variants = List<Variant>.from(
        json['variants'].map((e) => Variant.fromJson(e)).toList());
    rounds = Rounds.fromJson(json['rounds']);
  }
}
