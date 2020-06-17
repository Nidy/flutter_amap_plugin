package amap.com.example.flutter_amap_plugin.Map;


import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;

public class Coordinate {
    public double latitude;
    public double longitude;

    public Coordinate() {
        //default
    }

    public Coordinate(double lat, double lng) {
        this.latitude = lat;
        this.longitude = lng;
    }

    CameraPosition toCameraPosition() {
        return new CameraPosition(new LatLng(latitude,longitude), 10, 0, 0);
    }

    LatLng toLatLng() {
        return new LatLng(latitude, longitude);
    }
}
