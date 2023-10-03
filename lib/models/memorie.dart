class Memorie {
  int? id;
  String? image;
  double? latitude;
  double? longitude;
  String? description;
  String? formatedAddress;

  Memorie([
    this.id,
    this.description,
    this.formatedAddress,
    this.image,
    this.latitude,
    this.longitude,
  ]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'formatedAddress': formatedAddress,
    };
  }
}
