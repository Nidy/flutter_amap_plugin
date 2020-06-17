import '../model/amap_base_model.dart';

class Location extends AMapBaseModel {
  //地址信息
  String address;

  //城市
  String city;

  //区
  String district;

  //省
  String province;

  //国家
  String country;

  //街道信息
  String street;

  //街道号
  String streetNum;

  //获取定位信息描述
  String locationDetail;

  double latitude;

  double longitude;

  Location.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("address")) {
      this.address = json['address'];
      this.city = json['city'];
      this.district = json['district'];
      this.province = json['province'];
      this.country = json['country'];
      this.street = json['street'];
      this.streetNum = json['streetNum'];
      this.locationDetail = json['locationDetail'];
    }
    this.latitude = json['latitude'];
    this.longitude = json['longitude'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'address': address,
      'city': city,
      'district': district,
      'province': province,
      'country': country,
      'street': street,
      'streetNum': streetNum,
      'locationDetail': locationDetail,
      'latitude': latitude,
      'longitude': longitude,
    };
    return map;
  }
}