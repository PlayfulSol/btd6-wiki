import '/utilities/constants.dart';
import '/utilities/utils.dart';

String towerBaseImage(String towerId) {
  return '$baseImageUrl/towers/$towerId/tower.png';
}

String towerPathImage(String monkeyId, String pathKey, int index) {
  return '$baseImageUrl/towers/$monkeyId/${getTowerLevel(pathKey, index)}.png';
}

// String heroBaseImage(String heroId) {
//   return '$baseImageUrl/heroes/$heroId/hero.png';
// }

String heroLevelImage(String heroId, int level) {
  return '$baseImageUrl/heroes/$heroId/$level.png';
}

String heroSkinImage(String heroId, String skinId) {
  return '$baseImageUrl/heroes/$heroId/$skinId/hero.png';
}

String heroSkinLevelImage(String heroId, String skinId, int level) {
  return '$baseImageUrl/heroes/$heroId/$skinId/$level.png';
}

String bloonImage(String bloonId) {
  return '$baseImageUrl/bloons/$bloonId/base.png';
}

String bloonVariantImage(String bloonId, String variantId) {
  return '$baseImageUrl/bloons/$bloonId/$variantId.png';
}

String mapImage(String image) {
  return 'assets/images/maps/$image';
}

String towerImage(String image) {
  return 'assets/images/towers/$image';
}

String heroImage(String image) {
  return 'assets/images/heroes/$image';
}
