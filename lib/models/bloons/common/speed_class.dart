class Speed {
  late final String absolute;
  late final String relative;

  Speed({required this.absolute, required this.relative});

  Speed.fromJson(Map<String, dynamic> json) {
    absolute = json['absolute'];
    relative = json['relative'];
  }
}
