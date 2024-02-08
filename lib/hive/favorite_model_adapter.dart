import 'package:hive_flutter/hive_flutter.dart';
import '/hive/favorite_model.dart';

class FavoriteModelBoxAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final typeId = 1;

  @override
  FavoriteModel read(BinaryReader reader) {
    return FavoriteModel(
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.image);
    writer.writeString(obj.type);
    writer.writeInt(obj.itemIndex);
  }
}
