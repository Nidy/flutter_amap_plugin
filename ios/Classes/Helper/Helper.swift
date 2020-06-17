//
//  Helper.swift
//  flutter_amap_plugin
//
//  Created by Smiacter on 2020/6/17.
//

import UIKit

class Helper: NSObject {
    static func stringToJson(jsonStr: String) -> [String: Any]? {
       guard let jsonData = jsonStr.data(using: .utf8, allowLossyConversion: false) else { return nil }
       return try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
    }
    
    static func json2String(jsonObject: [String: Any]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString ?? ""
    }
}
