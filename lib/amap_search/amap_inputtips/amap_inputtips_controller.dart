
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amap_plugin/amap_search/amap_inputtips/amap_inputtips_model.dart';

const _poiChannelPrefix = 'plugin/amap/search/inputtips';

typedef void InputTipsCallHandler (List<AMapInputTipsModel> poiModels, Error error);

class AMapInputtipsController {
  final MethodChannel _inputChannel;

  AMapInputtipsController() : _inputChannel = MethodChannel(_poiChannelPrefix);

  Future queryInputTips({
    @required String keyword,
    @required String city,
    @required InputTipsCallHandler tipsCallHandler
  }) async {
    Map<String, dynamic> args = Map();
    args['keyword'] = keyword;
    args['city'] = city;
    _initChannel(inputHandler: tipsCallHandler);
    var result = await _inputChannel.invokeMethod("getInputTips", jsonEncode(args));
    return result;
  }

  void _initChannel({@required InputTipsCallHandler inputHandler}) {
    // ignore: missing_return
    _inputChannel.setMethodCallHandler((call) {
      switch(call.method) {
        case "onInputSearchDone":
          if (inputHandler != null) {
            if (call.arguments != null && call.arguments is List) {
              List<dynamic> datas = call.arguments;
              List<AMapInputTipsModel> poiList = datas.map((item) =>
                  AMapInputTipsModel.fromJson(item == null ? null : Map<String, dynamic>.from(item))).toList();
              inputHandler(poiList, null);
            } else {
              inputHandler(null, FlutterError("arguments null or empty"));
            }
          }
          break;
        case "onInputSearchError":
          inputHandler(null, FlutterError(call.arguments.toString()));
          break;
      }
    });
  }
}