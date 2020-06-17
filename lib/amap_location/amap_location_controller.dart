import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amap_plugin/amap_location/amap_location_model.dart';
import '../amap_location/amap_location_options.dart';
import '../common/coordinate.dart';

const _locChannelPrefix = 'plugin/amap/location';

typedef void LocationCallHandler(Location location, Error error);

class AMapLocationController {
  final MethodChannel _locChannel;

  AMapLocationController() : _locChannel = MethodChannel(_locChannelPrefix);

  void initLocationChannel({
    @required LocationCallHandler onLocationCallHandler,
  }) {
    // ignore: missing_return
    _locChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'locationError':
          print(handler.arguments);
          if (onLocationCallHandler != null) {
            onLocationCallHandler(null, FlutterError(handler.arguments));
          }
          break;
        case 'locationSuccess':
          print(handler.arguments);
          stopLocation();
          if (onLocationCallHandler != null && handler.arguments is Map) {
            onLocationCallHandler(
                Location.fromJson(Map<String, dynamic>.from(handler.arguments)), null);
          }
          break;
        case 'reGeocodeSuccess':
          print(handler.arguments);
          stopLocation();
          if (onLocationCallHandler != null && handler.arguments is Map) {
            onLocationCallHandler(
                Location.fromJson(Map<String, dynamic>.from(handler.arguments)), null);
          }
          break;
        default:
      }
    });
  }

  Future initLocation({
    @required LocationCallHandler onLocationCallHandler,
  }) async {
    initLocationChannel(onLocationCallHandler: onLocationCallHandler);
    var result = await _locChannel.invokeMethod('initLocation');
    return result;
  }

  Future startSingleLocation({
    @required AMapLocationOptions options,
  }) async {
    var result = await _locChannel.invokeMethod(
        'startSingleLocation', options.toJsonString());
    return result;
  }

  Future stopLocation() async {
    var result = await _locChannel.invokeMethod('stopLocation');
    return result;
  }
}
