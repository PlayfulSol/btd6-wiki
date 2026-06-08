import '/models/base/base_model.dart';
import 'boss_health_class.dart';

class BossBloonModel extends BaseModel {
  final String imageDefeated;
  final String imageElite;
  final String imageEliteDefeated;
  final String gimmick;
  final Map<String, dynamic> skullCount;
  final Map<String, dynamic> mechanics;
  final List<BossMinion> minions;
  final BossTiers tiers;

  Map<String, String> get images => {
        'normal': image,
        'defeated': imageDefeated,
        'elite': imageElite,
        'eliteDefeated': imageEliteDefeated,
      };

  BossBloonModel.fromJson(Map<String, dynamic> json)
      : imageDefeated = json['imageDefeated'] ?? '',
        imageElite = json['imageElite'] ?? '',
        imageEliteDefeated = json['imageEliteDefeated'] ?? '',
        gimmick = json['gimmick'] ?? '',
        skullCount = Map<String, dynamic>.from(json['skullCount'] ?? {}),
        mechanics = Map<String, dynamic>.from(json['mechanics'] ?? {}),
        minions = (json['minions'] as List? ?? [])
            .map((e) => BossMinion.fromJson(e))
            .toList(),
        tiers = BossTiers.fromJson(json['tiers'] ?? {}),
        super(
          json['id'] as String,
          json['name'] as String,
          json['image'] as String,
          json['type'] as String,
          changes: json['changes'] as String?,
        );
}
