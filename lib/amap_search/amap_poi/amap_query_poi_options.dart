import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/common/coordinate.dart';
import 'package:flutter_amap_plugin/model/amap_base_model.dart';

class AMapQueryPoiOptions extends AMapBaseModel {

  ///当前坐标
  final Coordinate location;

  //查询字符串，多个关键字用“|”分割
  final String keyWord;

  //POI 类型的组合，比如定义如下组合：餐馆|电影院|景点 （POI类型请在网站“相关下载”处获取）
  final String ctgr;

  //待查询城市（地区）的城市编码 citycode、城市名称（中文或中文全拼）、行政区划代码adcode
  final String city;

  final int pageNum;

  AMapQueryPoiOptions({
    @required this.location,
    @required this.keyWord,
    @required this.city,
    this.ctgr = '',
    this.pageNum = 0});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'keyWord': keyWord,
      'city': city,
      'pageNum': pageNum,
    };
    if (this.location != null) {
      map['location'] = location.toJson();
    }
    return map;
  }
}