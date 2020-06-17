import 'package:flutter/material.dart';
import 'package:flutter_amap_plugin/flutter_amap_plugin.dart';

class AMapPoiPage extends StatefulWidget {
  final String title;

  AMapPoiPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateAMapPoiPage();
}

class _StateAMapPoiPage extends State<AMapPoiPage> {
  AMapPoiController _controller = AMapPoiController();
  AMapInputtipsController _inputController = AMapInputtipsController();
  FocusNode _focusNode = FocusNode();
  var _searchController = TextEditingController();

  List<AMapPoiModel> _poiList = List<AMapPoiModel>();
  List<AMapInputTipsModel> _inputTipList = List<AMapInputTipsModel>();
  int _currIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() async {
      if (_searchController.text.length > 0) {
        /// 输入提示
        _inputController.queryInputTips(
            keyword: "天府", city: "成都市", tipsCallHandler: (list, error) {
          if (list != null) {
            print("AMapPoiPage input ===> $list");
            _inputTipList = list;
          }
          if (error != null) {
            print("AMapPoiPage input error===> ${error.toString()}");
          }
          if (this.mounted) {
            setState(() {

            });
          }
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _currIndex,
        children: <Widget>[
          _buildSearchView(),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(_poiList[index].toJsonString()),
                ),
            itemCount: _poiList.isNotEmpty ? _poiList.length : 0,
          ),
        ],
      )
    );
  }
  
  Widget _buildSearchView() {
    return Column(
      children: <Widget>[
        _buildSearchFiled(),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      _inputTipList[index].toJsonString(),
                    ),
                  ),
                  onTap: () async {
                    searchPoi();
                    setState(() {
                      _currIndex = 1;
                    });
                  },
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.blueGrey, height: 0.8),
              itemCount: _inputTipList == null ? 0 : _inputTipList.length),
        ),
      ],
    );
  }

  Widget _buildSearchFiled() {
    return Container(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              maxLines: 1,
              textAlign: TextAlign.left,
              autofocus: false,
              style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 14,
                  color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.search)),
                hintText: '输入地点或商区名称',
                counterText: '',
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: FlatButton(
              color: Colors.white,
              child: Text(
                "取消",
                style: TextStyle(fontSize: 14),
              ),
              textColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {
                _focusNode.unfocus();
                _searchController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void searchPoi() {
    _controller.poiQuery(options: AMapQueryPoiOptions(city: '成都市', keyWord: '天府一街',
        location: Coordinate(30.600239, 104.048542,)), poiCallHandler: (list, error) {
      if (list != null) {
        print("AMapPoiPage ===> $list");
        _poiList = list;
      }
      if (error != null) {
        print("AMapPoiPage error===> ${error.toString()}");
      }
      setState(() {});
    });
  }
}