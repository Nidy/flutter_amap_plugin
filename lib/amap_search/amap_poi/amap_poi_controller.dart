import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amap_plugin/amap_search/amap_poi/amap_poi_model.dart';
import 'package:flutter_amap_plugin/amap_search/amap_poi/amap_query_poi_options.dart';

const _poiChannelPrefix = 'plugin/amap/search/poi';

typedef void PoiCallHandler (List<AMapPoiModel> poiModels, Error error);

class AMapPoiController {

  final MethodChannel _poiChannel;

  AMapPoiController() : _poiChannel = MethodChannel(_poiChannelPrefix);

  Future poiQuery({
    @required AMapQueryPoiOptions options,
    @required PoiCallHandler poiCallHandler
  }) async {
    _initPoiChannel(poiCallHandler: poiCallHandler);
    var result = await _poiChannel.invokeListMethod("searchPoiItems", options.toJsonString());
    return result;
  }

  void _initPoiChannel({
    @required PoiCallHandler poiCallHandler
  }) {
    // ignore: missing_return
    _poiChannel.setMethodCallHandler((call) {
      switch (call.method) {
        case "onPoiSearchDone":
          print(call.arguments);
          if (poiCallHandler != null) {
            if (call.arguments != null && call.arguments is List) {
              List<dynamic> datas = call.arguments;
              List<AMapPoiModel> poiList = datas.map((item) =>
                  AMapPoiModel.fromJson(item == null ? null : Map<String, dynamic>.from(item))).toList();
              poiCallHandler(poiList, null);
            } else {
              poiCallHandler(null, FlutterError("arguments null or empty"));
            }
          }
          break;

        case "onPoiSearchError":
          print(call.arguments);
          poiCallHandler(null, FlutterError(call.arguments.toString()));
          break;
      }
    });
  }

}