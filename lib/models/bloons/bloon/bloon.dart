import '/models/base_model.dart';
import '/models/bloons/common/speed_class.dart';
import '/models/bloons/common/variant_class.dart';
import '/models/bloons/common/relative_class.dart';
import 'rounds_class.dart';

class BloonModel extends BaseModel {
  late final String fullName;
  late final List<dynamic> rbe;
  late final Speed speed;
  late final List<Relative> children;
  late final List<Relative> parents;
  late final List<Variant> variants;
  late final Rounds rounds;

  BloonModel(
    super.id,
    super.name,
    super.image,
    super.type,
    this.fullName,
    this.rbe,
    this.speed,
    this.children,
    this.parents,
    this.variants,
    this.rounds,
  );

  BloonModel.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        rbe = json['rbe'],
        speed = Speed.fromJson(json['speed']),
        children = List<Relative>.from(
          json['children'].map((e) => Relative.fromJson(e)).toList(),
        ),
        parents = List<Relative>.from(
          json['parents'].map((e) => Relative.fromJson(e)).toList(),
        ),
        variants = List<Variant>.from(
          json['variants'].map((e) => Variant.fromJson(e)).toList(),
        ),
        rounds = Rounds.fromJson(json['rounds']),
        super(
          json["id"] as String,
          json["name"] as String,
          json["image"] as String,
          json['type'] as String,
        );
}
