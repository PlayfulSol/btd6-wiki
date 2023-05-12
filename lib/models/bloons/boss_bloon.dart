class BossBloonModel {
  late final String id;
  late final String name;
  late final String type;
  late final double speed;
  late final Properties properties;
  late final Properties eliteProperties;

  BossBloonModel({
    required this.id,
    required this.name,
    required this.type,
    required this.speed,
  });

  BossBloonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    speed = json['speed'];
    properties = Properties(properties: json['properties']);
    eliteProperties = Properties(properties: json['properties']);
  }
}

class Properties {
  late final Map<dynamic, dynamic> properties;

  Properties({required this.properties});

  Properties.fromJson(Map<String, dynamic> json) {
    properties = json['properties'];
  }

  Iterable getKeys() {
    return properties.keys;
  }

  Iterable getValues() {
    return properties.values;
  }
}
