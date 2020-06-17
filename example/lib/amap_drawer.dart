import 'package:flutter/material.dart';
import './amap_map/amap_map_page.dart';
import './amap_map/amap_nav_page.dart';
import './amap_map/amap_location_page.dart';
import './amap_map/amap_route_page.dart';
import './amap_map/amap_convert_page.dart';
import './amap_map/amap_poi_page.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class AMapDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Drawer(
        child: Container(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                color: Color(0xff1E1E1E),
              ),
            ),
            ListTile(
              title: Text('地图展示'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MapPage(
                    title: '地图展示',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('导航展示'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NavPage(
                    title: '导航展示',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('安卓导航组件'),
              onTap: () {
                AMapNavController().startComponent(
                    coordinate: Coordinate(31.712799, 117.168188));
              },
            ),
            ListTile(
              title: Text('获取单次定位'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LocationPage(
                    title: '获取单次定位',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('路线规划'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return RoutePlanningPage(
                    title: '获取规划信息',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('地理编码'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ConvertPage(
                    title: '地理编码信息',
                  );
                }));
              },
            ),
            ListTile(
              title: Text('POI搜索'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AMapPoiPage(
                    title: 'POI搜索结果',
                  );
                }));
              },
            ),
          ],
        )),
      ),
    );
  }
}
