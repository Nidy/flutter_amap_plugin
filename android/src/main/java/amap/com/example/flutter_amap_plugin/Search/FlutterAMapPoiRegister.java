package amap.com.example.flutter_amap_plugin.Search;

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import amap.com.example.flutter_amap_plugin.FlutterAmapPlugin;
import amap.com.example.flutter_amap_plugin.Map.Coordinate;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * @author YangJijun <yangjijun@petrochina.com.cn>
 */
public class FlutterAMapPoiRegister implements MethodChannel.MethodCallHandler, PoiSearch.OnPoiSearchListener {
    public static final String SEARCH_POI_CHANNEL_NAME = "plugin/amap/search/poi";
    private PoiSearch.Query mQuery;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.arguments instanceof String) {
            AMapQueryPoiModel poiModel = new Gson().fromJson(call.arguments.toString(), AMapQueryPoiModel.class);
            mQuery = new PoiSearch.Query(poiModel.keyWord, poiModel.ctgr, poiModel.city);
            mQuery.setPageSize(20);
            mQuery.setPageNum(poiModel.pageNum); // 设置查页码，默认查询第一页
            searchPoi(poiModel);
        }

    }

    private void searchPoi(AMapQueryPoiModel poiModel) {
        if (poiModel != null && poiModel.location != null) {
            LatLonPoint lp = new LatLonPoint(poiModel.location.latitude,
                    poiModel.location.longitude);
            PoiSearch poiSearch = new PoiSearch(
                    FlutterAmapPlugin.registrar.activity().getApplicationContext(),
                    mQuery);
            poiSearch.setOnPoiSearchListener(this);
            poiSearch.setBound(new PoiSearch.SearchBound(lp, 5000, true));
            // 设置搜索区域为以lp点为圆心，其周围2000米范围
            poiSearch.searchPOIAsyn();// 异步搜索
        }
    }
    @Override
    public void onPoiSearched(PoiResult poiResult, int i) {
        if (i != 1000) {
            FlutterAmapPlugin.poiChannel.invokeMethod("onPoiSearchError", "获取POI兴趣点失败");
            return;
        }

        if (poiResult == null || poiResult.getPois() == null) {
            FlutterAmapPlugin.poiChannel.invokeMethod("onPoiSearchError", "未发现有效兴趣点");
            return;
        }

        List<PoiItem> poiItems = poiResult.getPois();
        List<Map<String, Object>> list = new ArrayList<>();
        for (PoiItem item : poiItems) {
            Map<String, Object> map = new HashMap<>();
            map.put("address", item.getSnippet());
            map.put("name", item.getTitle());
            map.put("latLng", new Gson().toJson(
                    new Coordinate(item.getLatLonPoint().getLatitude(), item.getLatLonPoint().getLongitude())));
            map.put("province", item.getProvinceName());
            map.put("city", item.getCityName());
            map.put("district", item.getAdName());
            map.put("area", item.getBusinessArea());
            list.add(map);
        }
        FlutterAmapPlugin.poiChannel.invokeMethod("onPoiSearchDone", list);
    }

    @Override
    public void onPoiItemSearched(PoiItem poiItem, int i) {

    }
}
