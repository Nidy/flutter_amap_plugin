import 'dart:convert';
import 'package:flutter_amap_plugin/common/coordinate.dart';
import 'package:flutter_amap_plugin/model/amap_base_model.dart';

class AMapInputTipsModel extends AMapBaseModel {

  //提示区域编码
  String adCode;

  //详细地址
  String address;

  //提示区域
  String name;

  //提示名称
  String poiId;

  //Poi的ID
  Coordinate latLng;

  //输入提示结果的类型编码
  String typeCode;

  AMapInputTipsModel.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('latLng')) {
      this.latLng = Coordinate.fromJson(jsonDecode(map['latLng']));
    }

    this.address = map['address'];
    this.name = map['name'];
    this.adCode = map['adCode'];
    this.poiId = map['poiId'];
    this.typeCode = map['typeCode'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'address': address,
      'name': name,
      'adCode': adCode,
      'poiId': poiId,
      'typeCode': typeCode,
    };
    if (latLng != null) {
      map['latLng'] = latLng.toJson();
    }
    return map;
  }
}