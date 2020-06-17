package amap.com.example.flutter_amap_plugin.Location;

import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

import amap.com.example.flutter_amap_plugin.FlutterAmapPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterAMapStartLocation implements MethodChannel.MethodCallHandler, AMapLocationListener {
    //声明AMapLocationClientOption对象
    public AMapLocationClientOption mLocationOption = null;

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        mLocationOption = new AMapLocationClientOption();
        if (methodCall.arguments instanceof String) {
            AMapLocationModel model = new Gson().fromJson(methodCall.arguments.toString(), AMapLocationModel.class);
            configOptions(model);
            if (null != FlutterAMapLocationRegister.mLocationClient) {
                FlutterAMapLocationRegister.mLocationClient.setLocationListener(this);
                FlutterAMapLocationRegister.mLocationClient.setLocationOption(mLocationOption);
                //设置场景模式后最好调用一次stop，再调用start以保证场景模式生效
                FlutterAMapLocationRegister.mLocationClient.stopLocation();
                FlutterAMapLocationRegister.mLocationClient.startLocation();
                result.success("start location");
            }
        } else {
            result.error("arg not string", "", 0);
        }

    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (aMapLocation != null && aMapLocation.getErrorCode() == 0) {
            if (mLocationOption.isNeedAddress()) {
                Map<String, Object> map = new HashMap<>();
                map.put("address", aMapLocation.getAddress());
                map.put("city", aMapLocation.getCity());
                map.put("district", aMapLocation.getDistrict());
                map.put("province", aMapLocation.getProvince());
                map.put("country", aMapLocation.getCountry());
                map.put("street", aMapLocation.getStreet());
                map.put("streetNum", aMapLocation.getStreetNum());
                map.put("locationDetail", aMapLocation.getLocationDetail());
                map.put("latitude", aMapLocation.getLatitude());
                map.put("longitude", aMapLocation.getLongitude());
                FlutterAmapPlugin.locChannel.invokeMethod("reGeocodeSuccess", map);
            } else {
                Map<String, Object> map = new HashMap<>();
                map.put("latitude", aMapLocation.getLatitude());
                map.put("longitude", aMapLocation.getLongitude());
                FlutterAmapPlugin.locChannel.invokeMethod("locationSuccess", map);
            }
        } else {
            assert aMapLocation != null;
            FlutterAmapPlugin.locChannel.invokeMethod("locationError",
                    "定位错误:{" + aMapLocation.getErrorCode() + "-" + aMapLocation.getErrorInfo() + "}");
        }
    }

    private void configOptions(AMapLocationModel model) {
        mLocationOption.setHttpTimeOut(model.locationTimeout * 1000);
        if (model.reGeocodeLanguage == 0) {
            mLocationOption.setGeoLanguage(AMapLocationClientOption.GeoLanguage.DEFAULT);
        } else if (model.reGeocodeLanguage == 1) {
            mLocationOption.setGeoLanguage(AMapLocationClientOption.GeoLanguage.ZH);
        } else if (model.reGeocodeLanguage == 2) {
            mLocationOption.setGeoLanguage(AMapLocationClientOption.GeoLanguage.EN);
        }
        if (model.locationModel == 0) {
            mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        } else if (model.locationModel == 1) {
            mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Battery_Saving);
        } else if (model.locationModel == 2) {
            mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Device_Sensors);
        }
        mLocationOption.setOnceLocation(true);
        mLocationOption.setNeedAddress(model.isReGeocode);
    }
}


