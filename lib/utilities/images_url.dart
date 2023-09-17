import '/utilities/constants.dart';

String heroBaseImage(String heroId) {
  return '$baseImageUrl/heroes/$heroId/hero.png';
}

String heroLevelImage(String heroId, int level) {
  return '$baseImageUrl/heroes/$heroId/$level.png';
}

String heroSkinImage(String heroId, String skinId) {
  return '$baseImageUrl/heroes/$heroId/$skinId/hero.png';
}

String heroSkinLevelImage(String heroId, String skinId, int level) {
  return '$baseImageUrl/heroes/$heroId/$skinId/$level.png';
}

String bossImage(String bloonId) {
  return '$baseImageUrl/bloons/$bloonId/base.png';
}

String bloonImage(String image) {
  return 'assets/images/bloons/$image';
}

String mapImage(String image) {
  return 'assets/images/maps/$image';
}

String towerImage(String image) {
  return 'assets/images/towers/$image';
}
