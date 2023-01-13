class BloonHierarchyModel {
  late final String id;
  late final String? type;
  late final int? count;

  BloonHierarchyModel(this.id, this.type, this.count);

  BloonHierarchyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    count = json['count'];
  }
}
