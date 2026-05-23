import '/models/base_model.dart';
import '/models/bloons/common/speed_class.dart';
import '/models/bloons/common/variant_class.dart';
import '/models/bloons/common/relative_class.dart';
import 'rounds_class.dart';

class BloonModel extends BaseModel {
  late final String fullName;
  late final bool isMoab;
  late final int health;
  late final double leakDamage;
  late final int layerNumber;
  late final List<String> tags;
  late final String firstAppearance; // formatted "Round N | ABR: Round N"
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
    this.isMoab,
    this.health,
    this.leakDamage,
    this.layerNumber,
    this.tags,
    this.firstAppearance,
    this.rbe,
    this.speed,
    this.children,
    this.parents,
    this.variants,
    this.rounds,
  );

  BloonModel.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'] as String? ?? json['name'] as String,
        isMoab = (json['isMoab'] as bool?) ?? false,
        health = (json['health'] as num?)?.toInt() ?? 0,
        leakDamage = (json['leakDamage'] as num?)?.toDouble() ?? 0.0,
        layerNumber = (json['layerNumber'] as num?)?.toInt() ?? 0,
        tags = List<String>.from(json['tags'] as List? ?? []),
        firstAppearance = _parseFirstAppearance(
            json['firstAppearance'] as Map<String, dynamic>?),
        rbe = [(json['rbe'] ?? 0).toString()],
        speed = Speed(
          absolute: (json['speed'] as num?)?.toString() ?? 'N/A',
          relative: (json['speedRelative'] as num?)?.toString() ?? 'N/A',
        ),
        children = List<Relative>.from(
          (json['children'] as List? ?? []).map((e) => Relative.fromJson(e)),
        ),
        parents = List<Relative>.from(
          (json['parents'] as List? ?? []).map((e) => Relative.fromJson(e)),
        ),
        variants = List<Variant>.from(
          (json['variants'] as List? ?? []).map((e) => Variant.fromJson(e)),
        ),
        rounds = Rounds.fromJson(json['rounds'] ?? {}),
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
        );

  static String _parseFirstAppearance(Map<String, dynamic>? fa) {
    if (fa == null) return 'N/A';
    final normal = fa['normal'];
    final alternate = fa['alternate'];
    final parts = <String>[];
    if (normal != null) parts.add('Round $normal');
    if (alternate != null) parts.add('ABR: Round $alternate');
    return parts.isEmpty ? 'N/A' : parts.join(' | ');
  }
}
