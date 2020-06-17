package amap.com.example.flutter_amap_plugin.Search;

import com.amap.api.services.help.Inputtips;
import com.amap.api.services.help.InputtipsQuery;
import com.amap.api.services.help.Tip;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
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
public class FlutterAMapInputTipsRegister implements MethodChannel.MethodCallHandler, Inputtips.InputtipsListener {

    public static final String SEARCH_INPUTTIPS_CHANNEL_NAME = "plugin/amap/search/inputtips";

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.arguments instanceof String) {
            JSONObject jb;
            try {
                jb = new JSONObject((String) call.arguments);
                InputtipsQuery query = new InputtipsQuery(jb.getString("keyword"),
                        jb.getString("city"));
                Inputtips inputtips = new Inputtips(
                        FlutterAmapPlugin.registrar.activity().getApplicationContext(),
                        query);
                inputtips.setInputtipsListener(this);
                inputtips.requestInputtipsAsyn();
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onGetInputtips(List<Tip> list, int i) {
        if (i != 1000) {
            FlutterAmapPlugin.inputtipsChannel.invokeMethod("onInputSearchError", "获取输入提示失败");
            return;
        }

        if (list == null || list.size() < 1) {
            FlutterAmapPlugin.inputtipsChannel.invokeMethod("onInputSearchError", "未找到与输入匹配的地点");
            return;
        }
        List<Map<String, Object>> inputList = new ArrayList<>();
        for (Tip tip : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("adCode", tip.getAdcode());
            map.put("address", tip.getAddress());
            map.put("name", tip.getName());
            map.put("poiId", tip.getPoiID());
            map.put("latLng", new Gson().toJson(
                    new Coordinate(tip.getPoint().getLatitude(), tip.getPoint().getLongitude())));
            map.put("typeCode", tip.getTypeCode());
            inputList.add(map);
        }
        FlutterAmapPlugin.inputtipsChannel.invokeMethod("onInputSearchDone", inputList);
    }
}
