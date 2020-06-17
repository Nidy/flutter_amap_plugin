import 'dart:convert';

import 'package:flutter_amap_plugin/common/coordinate.dart';
import 'package:flutter_amap_plugin/model/amap_base_model.dart';

class AMapPoiModel extends AMapBaseModel {
  //地址
  String address;

  //名称
  String name;

  //经纬度
  Coordinate latLng;

  //省
  String province;

  //城市名
  String city;

  //区划名称 省/市/区
  String district;

  //商圈
  String area;

  AMapPoiModel.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('latLng')) {
      this.latLng = Coordinate.fromJson(jsonDecode(map['latLng']));
    }

    this.address = map['address'];
    this.name = map['name'];
    this.province = map['province'];
    this.city = map['city'];
    this.district = map['district'];
    this.area = map['area'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'address': address,
      'name': name,
      'province': province,
      'city': city,
      'district': district,
      'area': area,
    };
    if (latLng != null) {
      map['latLng'] = latLng.toJson();
    }
    return map;
  }
}