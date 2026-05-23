class FavoriteModel {
  final String id;
  final String name;
  final String image;
  final String type;

  FavoriteModel(this.id, this.name, this.image, this.type);

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        json['id'] as String,
        json['name'] as String,
        json['image'] as String,
        json['type'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'type': type,
      };
}
