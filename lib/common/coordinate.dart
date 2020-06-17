import '../model/amap_base_model.dart';

class Coordinate extends AMapBaseModel {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  Coordinate.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'];

  @override
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}