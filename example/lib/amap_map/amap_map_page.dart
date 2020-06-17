import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class MapPage extends StatefulWidget {
  final String title;

  const MapPage({Key key, this.title}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AMapMapController _controller;
  var _annotations = [
    AMapAnnotationModel(
      coordinate: Coordinate(39.992520, 116.336170),
      title: '11111',
      subTitle: 'sub111',
      annotationIcon: 'images/default_marker.png',
    ),
    AMapAnnotationModel(
      coordinate: Coordinate(39.998293, 116.348904),
      title: '22222',
      subTitle: 'sub111',
      annotationIcon: 'images/amap_start.png',
    ),
    AMapAnnotationModel(
      coordinate: Coordinate(40.004087, 116.353915),
      title: '33333',
      subTitle: 'sub111',
      annotationIcon: 'images/default_marker.png',
    ),
    AMapAnnotationModel(
      coordinate: Coordinate(31.712799, 117.168188),
      title: '44444',
      subTitle: 'sub111',
      annotationIcon: 'images/default_marker.png',
    ),
  ];

  var _annotations2 = [
    AMapAnnotationModel(
      coordinate: Coordinate(39.992520, 116.336170),
      title: '11111',
      subTitle: 'sub111',
      annotationIcon: 'images/default_marker.png',
    ),
    AMapAnnotationModel(
      coordinate: Coordinate(39.998293, 116.348904),
      title: '22222',
      subTitle: 'sub111',
      annotationIcon: 'images/amap_start.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              _controller.clearAllAnnotations().then((value) {
                _controller.addAnnotation(
                  options: AMapAnnotationOptions(
                    annotationCoordinates: _annotations2,
                    annotationIcon: 'images/default_marker.png',
                  ),
                );
              });
            },
            child: Text('reset'),
          ),
          RaisedButton(
            onPressed: () {
              _controller.clearAllAnnotations();
            },
            child: Text('clear'),
          ),
        ],
      ),
      body: Container(
        child: AMapMapView(
          onMapViewCreate: (controller) {
            _controller = controller;
            _controller.initMapChannel();
            _controller.addAnnotation(
              options: AMapAnnotationOptions(
                annotationCoordinates: _annotations,
                annotationIcon: 'images/default_marker.png',
              ),
            );
          },
          onMapStartLodingMap: () {
            print('onMapStartLodingMap');
          },
          onMapFinishLodingMap: () {
            print('onMapFinishLodingMap');
          },
          onMapAnnotationTap: (index) {
            Navigator.of(context)
                .push((MaterialPageRoute(builder: (BuildContext context) {
              return AMapNavView(
                onNavViewCreate: (controller) {
                  controller.startAMapNav(
                    coordinate: _annotations[index].coordinate,
                  );
                  controller.initNavChannel(context);
                },
              );
            })));
          },
          options: AMapMapOptions(
            mapType: AMapMapType.standard,
            zoomLevel: 14,
            showsUserLocation: true,
            showsCompass: false,
            showTraffic: true,
            showsScale: false,
            zoomEnabled: true,
            userTrackingMode: AMapUserTrackingMode.follow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
