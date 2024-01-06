import 'package:flutter/material.dart';

const String kTowers = 'towers';
const String kHeroes = 'heroes';
const String kBloons = 'bloons';
const String kBlimps = 'blimps';
const String kBosses = 'bosses';
const String kMaps = 'maps';

const int kTowersIndex = 0;
const int kHeroesIndex = 1;
const int kBloonsIndex = 2;
const int kMapsIndex = 3;

const List<String> capTitles = [
  'Towers',
  'Heroes',
  'Bloons & Bosses',
  'Maps',
];

const List<String> simpleTitles = [
  'towers',
  'heroes',
  'bloons',
  'maps',
];

const List<Icon> icons = [
  Icon(Icons.cell_tower),
  Icon(Icons.person),
  Icon(Icons.nature),
  Icon(Icons.map_outlined),
];

const configDirectory = 'assets/data/config';
const towerDataPath = 'assets/data/towers/';
const heroDataPath = 'assets/data/heroes/';
const mapDataPath = 'assets/data/maps/';
const bloonsDataPath = 'assets/data/bloons/';
const bossesDataPath = 'assets/data/bosses/';
const minionsDataPath = 'assets/data/minions/';

const Map<String, String> statsDictionary = {
  'damage': 'Damage',
  'pierce': 'Pierce',
  'attackSpeed': 'Attack Speed',
  'range': 'Range',
  'statusEffects': 'Status Effects',
  'towerBoosts': 'Tower Boosts',
  'incomeBoosts': 'Income Boosts',
  'camo': 'Camo',
  'levelSpeed': 'Level Speed',
};

const Map<String, String> pathsDictionary = {
  'path1': 'Top Path',
  'path2': 'Middle Path',
  'path3': 'Bottom Path',
  'paragon': 'Paragon',
};

const List<String> mapDifficulties = [
  'All',
  'Beginner',
  'Intermediate',
  'Advanced',
  'Expert'
];

const List<String> towerTypes = [
  'All',
  'Primary',
  'Military',
  'Magic',
  'Support',
];

const List<String> bloonTypes = [
  'All',
  'Bloons',
  'Blimps',
  'Bosses',
];

const Map<String, Map<String, String>> mapDifficultyToReward = {
  'Beginner': {
    'easy': '75\$',
    'medium': '125\$',
    'hard': '200\$',
    'impoppable': '300\$',
  },
  'Intermediate': {
    'easy': '150\$',
    'medium': '250\$',
    'hard': '400\$',
    'impoppable': '600\$',
  },
  'Advanced': {
    'easy': '225\$',
    'medium': '375\$',
    'hard': '600\$',
    'impoppable': '900\$',
  },
  'Expert': {
    'easy': '300\$',
    'medium': '500\$',
    'hard': '800\$',
    'impoppable': '1200\$',
  },
};

const Map<String, String> bossImageLabels = {
  'normal': 'Normal',
  'defeated': 'Defeated',
  'elite': 'Elite',
  'eliteDefeated': 'Elite Defeated',
};

const TextStyle subtitleStyle = TextStyle(
  fontSize: 13,
);

const TextStyle normalStyle = TextStyle(
  fontSize: 16,
);

const TextStyle bolderNormalStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle smallTitleStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
);

const TextStyle titleStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
);

const TextStyle bigTitleStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

const String googleLink =
    'https://play.google.com/store/apps/details?id=asafhadad.btd6wiki';

const String playfulEmail = 'Playfulsols@gamil.com';
const String playfulGitRepo = 'https://github.com/PlayfulSol/flutter-btd6-wiki';

const String name = 'name';
const String email = 'email';
const String gitRepo = 'git_repo';
const String git = 'git';
const String linkedin = 'linkedin';

const Map<String, String> asaf = {
  name: 'Asaf Hadad',
  email: 'asaf147369@gmail.com',
  git: 'https://github.com/asaf147369',
  linkedin: 'https://www.linkedin.com/in/asaf-hadad/',
};

const Map<String, String> shai = {
  name: 'Shai Holczer',
  email: 'shaitnto@gmail.com',
  git: 'https://github.com/namelessto',
  linkedin: 'https://www.linkedin.com/in/shai-holczer/',
};

const String towerCrossCount = 'towerCrossAxisCount';
const String towerAspectRatio = 'towerChildAspectRatio';
const String towerTitleStyle = 'towerTitleStyle';
const String towerSubtitleStyle = 'towerSubtitleStyle';
const String towerSubtitleRows = 'towerSubtitleMaxRows';
const String towerImageWidth = 'towerImageWidth';

const String heroCrossCount = 'heroCrossAxisCount';
const String heroAspectRatio = 'heroChildAspectRatio';
const String heroTitleStyle = 'heroTitleStyle';
const String heroSubtitleStyle = 'heroSubtitleStyle';
const String heroSubtitleRows = 'heroSubtitleMaxRows';
const String skinCrossCount = 'skinCrossAxisCount';
const String skinAspectRatio = 'skinChildAspectRatio';

const String bloonCrossCount = 'bloonCrossAxisCount';
const String bloonAspectRatio = 'bloonChildAspectRatio';
const String bloonTitleStyle = 'bloonTitleStyle';
const String bloonImageWidth = 'bloonImageWidth';

const String bossCrossCount = 'bossCrossAxisCount';
const String bossAspectRatio = 'bossChildAspectRatio';
const String bossTitleStyle = 'bossTitleStyle';
const String bossSubtitleStyle = 'bossSubtitleStyle';

const String mapCrossCount = 'mapCrossAxisCount';
const String mapAspectRatio = 'mapChildAspectRatio';
const String mapTitleStyle = 'mapTitleStyle';
const String mapSubtitleStyle = 'mapSubtitleStyle';
