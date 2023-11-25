class Speed {
  late final String absolute;
  late final String relative;

  Speed({required this.absolute, required this.relative});

  Speed.fromJson(Map<String, dynamic> json) {
    absolute = json['absolute'];
    relative = json['relative'];
  }
}

class Variant {
  late final String image;
  late final String name;
  late final String appearances;

  Variant({required this.image, required this.name, required this.appearances});

  Variant.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    appearances = json['appearances'];
  }
}

class Rounds {
  late final List<String> normal;
  late final List<String> abr;

  Rounds({required this.normal, required this.abr});

  Rounds.fromJson(Map<String, dynamic> json) {
    normal = List<String>.from(json['normal']);
    abr = List<String>.from(json['abr']);
  }
}

class Relative {
  late final String id;
  late final String name;
  late final String image;
  late final String value;

  Relative({
    required this.id,
    required this.name,
    required this.image,
    required this.value,
  });

  Relative.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    image = json['image'] as String;
    value = json['value'] as String;
  }
}

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
