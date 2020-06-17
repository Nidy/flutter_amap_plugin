//
// Created by 冯顺 on 2019-06-09.
//

import Foundation
import AMapFoundationKit
import AMapSearchKit
import Flutter

public class FlutterAMapSearch: NSObject {
    var _search: AMapSearchAPI!

    public override init() {
        super.init()
    }

    deinit {
        print("FlutterAMapSearch delloc")
    }
}

/// 路线规划
public class FlutterAMapRoutePlan: FlutterAMapSearch, AMapSearchDelegate {

    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self
    }

    public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        if let options = RoutePlanningModel.deserialize(from: call?.arguments as? String) {
            routePlanning(options)
            routeShareUrl(options)
            result("start route planning")
        } else {
            result(FlutterError.init(code: "0", message: "arg not string", details: nil))
        }
    }

    func routePlanning(_ options: RoutePlanningModel!) {
        let request = AMapDrivingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(options.origin.latitude), longitude: CGFloat(options.origin.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        request.strategy = options.strategy
        request.requireExtension = true

        _search.aMapDrivingRouteSearch(request)
    }

    func routeShareUrl(_ options: RoutePlanningModel!) {
        let request = AMapRouteShareSearchRequest()
        request.strategy = options.strategy
        request.startCoordinate = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        request.destinationCoordinate = AMapGeoPoint.location(withLatitude: CGFloat(options.destination.latitude), longitude: CGFloat(options.destination.longitude))
        _search.aMapRouteShareSearch(request)
    }

    public func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.route.paths.count > 0 {
            let path: AMapPath = response.route.paths[0]
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(
                    "onRouteSearchDone",
                    arguments: ["duration": path.duration,
                                "distance": path.distance,
                                "strategy": path.strategy!,
                                "totalTrafficLights": path.totalTrafficLights])
        } else {
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod("routePlanningError", arguments: "路线规划错误:{0000 - 未发现有效路径}")
        }
    }

    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let error = error {
            let error = error as NSError
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod("routePlanningError", arguments: "路线规划错误:{\(error.code) - \(error.localizedDescription)}")
        }
    }

    public func onShareSearchDone(_ request: AMapShareSearchBaseRequest!, response: AMapShareSearchResponse!) {
        SwiftFlutterAmapPlugin.routeChannel.invokeMethod("onShareSearchDone", arguments: ["shareURL": response.shareURL])
    }

    deinit {
        print("route dealloc")
    }
}

/// 地理编码与反编码
public class FlutterAMapConvert: FlutterAMapSearch, AMapSearchDelegate {
    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self
    }

    public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        if call.method == "geoToCoordinate" {
            if let address = call.arguments as? String {
                let request = AMapGeocodeSearchRequest()
                request.address = address
                _search.aMapGeocodeSearch(request)
            }
        } else if call.method == "coordinateToGeo" {
            let request = AMapReGeocodeSearchRequest()
            if let options = Coordinate.deserialize(from: call.arguments as? String) {
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(options.latitude), longitude: CGFloat(options.longitude))
                request.requireExtension = true
                _search.aMapReGoecodeSearch(request)
            }
        }
    }

    public func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count > 0 {
            print("--------\(response.geocodes.count)")
            let latlon = response.geocodes[0].location
            SwiftFlutterAmapPlugin.convertChannel.invokeMethod("onGeoToCoordinate", arguments: ["lat":latlon?.latitude,"lon":latlon?.longitude])
        } else {
            SwiftFlutterAmapPlugin.convertChannel.invokeMethod("onConvertError", arguments:"地址转坐标错误:{未发现有效地址}")
        }
        
    }

    public func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        SwiftFlutterAmapPlugin.convertChannel.invokeMethod("onCoordinateToGeo", arguments: ["address":response.regeocode.formattedAddress])
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let error = error {
            let error = error as NSError
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod("onConvertError", arguments: "地址转换错误:{\(error.code) - \(error.localizedDescription)}")
        }
    }
}

/// POI搜索相关
private let PoiSearchDoneCallback = "onPoiSearchDone"
private let PoiSearchErrorCallback = "onPoiSearchError"
private let InputTipSearchDoneCallback = "onInputSearchDone"
private let InputTipSearchErrorCallback = "onInputSearchError"

public class FlutterAMapPoi: FlutterAMapSearch, AMapSearchDelegate {
    
    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self
    }

    public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        guard call.method == PoiSearchMethod else { return }
        guard let paramStr = call.arguments as? String else { return }
        guard let dict = Helper.stringToJson(jsonStr: paramStr) else { return }
        guard let location = dict["location"] as? [String: Any] else { return }
        
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = dict["keyWord"] as? String
        request.city = dict["city"] as? String
        request.page = (dict["pageNum"] as? Int) ?? 0
        request.types = dict["ctgr"] as? String
        let loc = AMapGeoPoint()
        loc.longitude = (location["longitude"] as? CGFloat) ?? 0.0
        loc.latitude = (location["latitude"] as? CGFloat) ?? 0.0
        request.location = loc
        _search.aMapPOIKeywordsSearch(request)
    }
    
    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(PoiSearchErrorCallback, arguments: "无结果")
        } else if let pois = response.pois {
            var results: [[String: Any]] = []
            for poi in pois {
                let latlng: [String: Any] = ["latitude": poi.location.latitude, "longitude": poi.location.longitude]
                let result: [String: Any] = ["name": poi.name ?? "",
                                             "address": poi.address ?? "",
                                             "latLng": Helper.json2String(jsonObject: latlng),
                                             "province": poi.province ?? "",
                                             "city": poi.city ?? "",
                                             "district": poi.district ?? "",
                                             "area": poi.businessArea ?? ""]
                results.append(result)
            }
            SwiftFlutterAmapPlugin.poiChannel.invokeMethod(PoiSearchDoneCallback, arguments: results)
        }
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let error = error {
            let error = error as NSError
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(PoiSearchErrorCallback, arguments: "搜索出错:{\(error.code) - \(error.localizedDescription)}")
        }
    }
}

public class FlutterAMapInputTip: FlutterAMapSearch, AMapSearchDelegate {
    
    public override init() {
        super.init()
        _search = AMapSearchAPI()
        _search.delegate = self
    }

    public func onMethod(call: FlutterMethodCall!, result: FlutterResult!) {
        guard let paramStr = call.arguments as? String else { return }
        guard let dict = Helper.stringToJson(jsonStr: paramStr) else { return }
        if call.method == InputTipSearchMethod {
            let request = AMapInputTipsSearchRequest()
            request.city = dict["city"] as? String
            request.keywords = dict["keyword"] as? String
            _search.aMapInputTipsSearch(request)
        }
    }
    
    public func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if response.count == 0 {
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(InputTipSearchErrorCallback, arguments: "无结果")
        } else {
            var results: [[String: Any]] = []
            for tip in response.tips {
                let result: [String: Any] = ["poiId": tip.uid ?? "",
                                             "name": tip.name ?? "",
                                             "address": tip.address ?? "",
                                             "adCode": tip.adcode ?? "",
                                             "typeCode": tip.typecode ?? ""]
                results.append(result)
            }
            SwiftFlutterAmapPlugin.inputTipChannel.invokeMethod(InputTipSearchDoneCallback, arguments: results)
        }
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let error = error {
            let error = error as NSError
            SwiftFlutterAmapPlugin.routeChannel.invokeMethod(InputTipSearchErrorCallback, arguments: "搜索出错:{\(error.code) - \(error.localizedDescription)}")
        }
    }
}
