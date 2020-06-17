package amap.com.example.flutter_amap_plugin.Search;

import java.io.Serializable;

import amap.com.example.flutter_amap_plugin.Map.Coordinate;

/**
 * @author YangJijun <yangjijun@petrochina.com.cn>
 */
public class AMapQueryPoiModel implements Serializable {

    /**
     * 当前位置
     */
    Coordinate location;

    /**
     * 查询字符串，多个关键字用“|”分割
     */
    String keyWord;

    /**
     * POI 类型的组合，比如定义如下组合：餐馆|电影院|景点 （POI类型请在网站“相关下载”处获取）
     */
    String ctgr;

    /**
     * 待查询城市（地区）的城市编码 citycode、城市名称（中文或中文全拼）、行政区划代码adcode
     * 必设参数
     */
    String city;

    /**
     * 查询的页码
     */
    int pageNum;
}
