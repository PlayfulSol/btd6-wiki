import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/presentation/widgets/common/app_image.dart';
import '/presentation/widgets/common/detail_page_scaffold.dart';
import '/presentation/widgets/common/loader.dart';
import '/presentation/widgets/common/image_carousel.dart';
import '/models/bloons/boss/boss_health_class.dart';
import '/models/bloons/boss/boss_bloon.dart';
import '/presentation/widgets/common/property_card.dart';
import '/presentation/widgets/common/stat_row.dart';
import '/analytics/analytics_constants.dart';
import '/analytics/analytics.dart';
import '/utilities/favorite_state.dart';
import '/utilities/images_url.dart';
import '/utilities/constants.dart';

// Human-readable labels and format hints for known mechanics keys.
// Format: 'percent' → multiply by 100 + %, 'multiplier' → × prefix,
//         'seconds' → s suffix, 'health' → comma-formatted int, 'raw' → as-is
const _mechanicsMeta = <String, List<String>>{
  'drainInterval': ['Drain interval', 'seconds'],
  'tombstoneInterval': ['Tombstone interval', 'seconds'],
  'healPercent': ['Heal per interval', 'percent'],
  'worthMultiplier': ['Sellback value', 'percent'],
  'bloonSpeedBoost': ['Bloon speed boost', 'multiplier'],
  'bloonSpeedRadius': ['Boost radius (units)', 'raw'],
  'rangeReduction': ['Tower range reduction', 'percent'],
  'abilityCooldownMultiplier': ['Ability cooldown modifier', 'percent'],
  'tailShieldRegenTime': ['Shield regen time', 'seconds'],
  'tailDamageMultiplier': ['Tail damage multiplier', 'multiplier'],
  'tombstoneHealth': ['Tombstone HP', 'health'],
  'armorAmount': ['Armor HP', 'health'],
  'armorSpeedMultiplier': ['Armor speed mult.', 'multiplier'],
  'stunRadius': ['Stun radius (units)', 'raw'],
  'stunDuration': ['Stun duration', 'seconds'],
  'shieldAmount': ['Shield HP', 'health'],
  'shieldSpeedBoost': ['Speed boost (shielded)', 'multiplier'],
  'numSegments': ['Body segments', 'raw'],
};

class BossBloon extends StatefulWidget {
  const BossBloon({
    super.key,
    required this.analyticsHelper,
    required this.bossId,
  });

  final AnalyticsHelper analyticsHelper;
  final String bossId;

  @override
  State<BossBloon> createState() => _BossBloonState();
}

class _BossBloonState extends State<BossBloon> {
  final controller = CarouselSliderController();
  late final BossBloonModel boss;
  List<String> images = [];
  List<String> imageKeys = [];
  bool loading = true;
  int activeIndex = 0;

  void loadBoss() async {
    final path = '${bossesDataPath + widget.bossId}.json';
    final data = await rootBundle.loadString(path);
    boss = BossBloonModel.fromJson(json.decode(data));
    setState(() {
      loading = false;
      images = List.from(boss.images.values);
      imageKeys = List.from(boss.images.keys);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.analyticsHelper.logScreenView(
      screenClass: kBossPagesClass,
      screenName: widget.bossId,
    );
    loadBoss();
  }

  // ── Formatters ────────────────────────────────────────────────────────────

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _fmtMechanic(String key, dynamic value) {
    if (value is! num) return value.toString();
    final format = _mechanicsMeta[key]?[1] ?? 'raw';
    switch (format) {
      case 'percent':
        final pct = value * 100;
        final s = pct == pct.truncateToDouble()
            ? pct.toInt().toString()
            : pct.toStringAsFixed(1);
        return '$s%';
      case 'multiplier':
        return '×$value';
      case 'seconds':
        return '${value}s';
      case 'health':
        return _fmt(value.toInt());
      default:
        return value == value.truncateToDouble()
            ? value.toInt().toString()
            : value.toString();
    }
  }

  String _mechanicLabel(String key) =>
      _mechanicsMeta[key]?[0] ??
      key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(0)}');

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Loader(),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;
    final carH = sw > 600 ? 360.0 : sw * 0.42;
    final vf = sw > 600 ? 0.8 : 0.7;
    final favoriteState = context.watch<FavoriteState>();
    final isFav = favoriteState.isFavorite(boss.type, boss.id);

    return DetailPageScaffold(
      title: boss.name,
      accentColor: GameColors.danger,
      isFavorite: isFav,
      onFavoriteToggle: () =>
          favoriteState.toggleFavoriteFunc(context, favoriteState, boss),
      headerContent: Padding(
        padding: const EdgeInsets.only(top: 44),
        child: ImageCarousel(
          images: images,
          pathBuilder: bossImage,
          controller: controller,
          activeIndex: activeIndex,
          height: carH,
          viewportFraction: vf,
          accentColor: GameColors.danger,
          onPageChanged: (i) => setState(() => activeIndex = i),
          showIndicator: false,
        ),
      ),
      belowHeader: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            if (images.length > 1)
              AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count: images.length,
                onDotClicked: (i) => controller.jumpToPage(i),
                effect: ScrollingDotsEffect(
                  activeDotScale: 1.25,
                  spacing: 10,
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: GameColors.danger,
                  dotColor: colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
            const SizedBox(height: 6),
            Text(
              bossImageLabels[imageKeys[activeIndex]] ?? '',
              textAlign: TextAlign.center,
              style: smallTitleStyle.copyWith(color: GameColors.danger),
            ),
          ],
        ),
      ),
      body: [
        Chip(
          label: const Text(
            'Boss',
            style: TextStyle(
              color: GameColors.danger,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          backgroundColor: GameColors.danger.withValues(alpha: 0.12),
          side: BorderSide(color: GameColors.danger.withValues(alpha: 0.4)),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(height: 12),

        _gimmickWidget(boss.gimmick),
        const SizedBox(height: 12),

        PropertyCard(
          title: 'Skulls',
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Normal',
                            style: bolderNormalStyle.copyWith(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          '${boss.skullCount['normal']}',
                          style: titleStyle.copyWith(color: GameColors.danger),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(color: colorScheme.outlineVariant),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Elite',
                            style: bolderNormalStyle.copyWith(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          '${boss.skullCount['elite']}',
                          style: titleStyle.copyWith(color: GameColors.danger),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if (boss.mechanics.isNotEmpty) ...[
          const SizedBox(height: 12),
          PropertyCard(
            title: 'Mechanics',
            children: boss.mechanics.entries
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: StatRow(
                        label: _mechanicLabel(e.key),
                        value: _fmtMechanic(e.key, e.value),
                      ),
                    ))
                .toList(),
          ),
        ],

        if (boss.minions.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Minions', style: titleStyle),
          const SizedBox(height: 8),
          ...boss.minions.map(_minionCard),
        ],

        const SizedBox(height: 12),
        const Text('Health', style: titleStyle),
        const Text(
          'Each additional player adds 20%',
          style: subtitleStyle,
        ),
        const SizedBox(height: 8),
        Card(child: _bossHealth('Normal', boss.tiers.normal)),
        const SizedBox(height: 8),
        Card(child: _bossHealth('Elite', boss.tiers.elite)),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Gimmick ───────────────────────────────────────────────────────────────

  Widget _gimmickWidget(String gimmick) {
    final sentences = gimmick
        .split('. ')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) => s.endsWith('.') ? s : '$s.')
        .toList();

    if (sentences.length <= 1) return Text(gimmick, style: normalStyle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sentences
          .map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: normalStyle),
                    Expanded(child: Text(s, style: normalStyle)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  // ── Minion card ───────────────────────────────────────────────────────────

  Widget _minionCard(BossMinion m) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              path: minionImage(m.image),
              width: 64,
              height: 64,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(m.name, style: smallTitleStyle),
                      if (m.isMoab) ...[
                        const SizedBox(width: 8),
                        _badge('MOAB', GameColors.moab),
                      ],
                      if (m.isCamo) ...[
                        const SizedBox(width: 4),
                        _badge('Camo', Colors.green),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (m.healthFlat != null)
                    Text('HP: ${_fmt(m.healthFlat!)}', style: normalStyle),
                  if (m.hasTierHealth) ...[
                    Text('HP (Normal):',
                        style: bolderNormalStyle.copyWith(fontSize: 14)),
                    ...List.generate(
                        m.healthNormal!.length,
                        (i) => Text(
                              '  Tier ${i + 1}: ${_fmt(m.healthNormal![i])}',
                              style: normalStyle.copyWith(fontSize: 14),
                            )),
                    Text('HP (Elite):',
                        style: bolderNormalStyle.copyWith(fontSize: 14)),
                    ...List.generate(
                        m.healthElite!.length,
                        (i) => Text(
                              '  Tier ${i + 1}: ${_fmt(m.healthElite![i])}',
                              style: normalStyle.copyWith(fontSize: 14),
                            )),
                  ],
                  const SizedBox(height: 4),
                  if (m.speedFlat != null)
                    Text('Speed: ${m.speedFlat}', style: normalStyle),
                  if (m.hasModeSpeed)
                    Text(
                        'Speed — Normal: ${m.speedNormal}  Elite: ${m.speedElite}',
                        style: normalStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  // ── Health / Tiers ────────────────────────────────────────────────────────

  ExpansionTile _bossHealth(String title, List<BossTier> tiers) {
    return ExpansionTile(
      title: Text(title,
          style: smallTitleStyle.copyWith(color: GameColors.danger)),
      onExpansionChanged: (v) => widget.analyticsHelper.logEvent(
        name: widgetEngagement,
        parameters: {
          'screen': boss.id,
          'widget': expansionTile,
          'value': 'health_${title}_$v'
        },
      ),
      children: tiers.map((tier) {
        final h = tier.health;
        final h2 = (h * 1.2).round();
        final h3 = (h * 1.4).round();
        final h4 = (h * 1.6).round();
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: Text('Tier ${tier.tier}',
              style: normalStyle.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Text(
              tier.speedRelative != null
                  ? '1P: ${_fmt(h)}  •  Speed: ${tier.speed} (${(tier.speedRelative! * 100).round()}% of Red)'
                  : '1P: ${_fmt(h)}  •  Speed: ${tier.speed}',
              style: subtitleStyle),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 Player: ${_fmt(h)}\n'
                    '2 Players: ${_fmt(h2)}\n'
                    '3 Players: ${_fmt(h3)}\n'
                    '4 Players: ${_fmt(h4)}',
                    style: normalStyle,
                  ),
                  if (tier.mechanics.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text('Tier mechanics:', style: bolderNormalStyle),
                    const SizedBox(height: 4),
                    ...tier.mechanics.entries.map((e) => Text(
                          '${_mechanicLabel(e.key)}: ${_fmtMechanic(e.key, e.value)}',
                          style: normalStyle.copyWith(fontSize: 14),
                        )),
                  ],
                  if (tier.triggers.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text('Spawns:', style: bolderNormalStyle),
                    const SizedBox(height: 4),
                    ...tier.triggers.map((t) => Text(
                          '• ${t.label}',
                          style: normalStyle.copyWith(fontSize: 14),
                        )),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
