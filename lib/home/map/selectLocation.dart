// ignore_for_file: must_be_immutable

import 'package:daejeoni/common/InputForm.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/provider/gpsStatus.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kpostal/kpostal.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SelectLocation extends StatefulWidget {
  ItemFavoriteGps? item;
  SelectLocation({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late KakaoMapController _mapController;
  final List<Marker> _markerList = <Marker>[];
  late TextEditingController _fNameController;
  late final ItemFavoriteGps _favorite = ItemFavoriteGps();
  late LatLng _locateTarget;
  late GpsStatus _gpsProvider;


  bool _bSelected = false;
  late SessionData _session;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    _gpsProvider = Provider.of<GpsStatus>(context, listen: false);

    if(widget.item != null) {
      _favorite.mapSn = _favorite.mapSn;
      _favorite.mapTitle = widget.item!.mapTitle;
      _favorite.mapAddr = widget.item!.mapAddr;
      _favorite.mapX = widget.item!.mapX;
      _favorite.mapY = widget.item!.mapY;
      _locateTarget = LatLng(_favorite.mapX, _favorite.mapY);
    } else {
      _locateTarget = LatLng(_gpsProvider.latitude(), _gpsProvider.longitude());
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("즐겨찾기"),//_renderSearch(),
        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26,),
              onPressed: () {
                Navigator.pop(context, false);
              }),
        ),
      ),
      body: _renderBody(),
    );
  }

  void _showLocation(bool bCenter) {
    _locateTarget = LatLng(_favorite.mapX, _favorite.mapY);
    _updateMarker(_locateTarget);
    if(bCenter) {
      _mapController.setCenter(_locateTarget);
    }
    setState(() {
      _bSelected = true;
    });
  }

  Widget _renderBody() {
    return Column(
      children: [
        Visibility(
            visible: _bSelected,
            child: _renderMapInfo()
        ),
        Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                    left: 0,top: 0, right: 0, bottom: 0,
                    child: KakaoMap(
                      zoomControl:false,
                      currentLevel: 5,
                      //center: _locateHome,
                      onMapCreated: (controller) async {
                        if (kDebugMode) {
                          print("onMapCreated(): ....");
                        }
                        _mapController = controller;
                        _goMyLocate();
                      },

                      onMapTap:(LatLng latLng) async {
                        await reqAddress(latLng.longitude, latLng.latitude);
                        _showLocation(false);
                      },
                      //onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {},
                    )
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FloatingActionButton.small(
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.search_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                              onPressed: () {
                                _searchAddress();
                              }
                          ),
                          const Spacer(),
                          FloatingActionButton.small(
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.navigation_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                              onPressed: () {
                                _goMyLocate();
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text("*주소를 검색하거나 위치를 터치하여 등록해주세요.", style: ItemG1N14,),
                      )
                    )),
              ],
            )
        )
      ],
    );
  }

  Widget _renderMapInfo() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text("위치주소: ${_favorite.mapAddr}", style: ItemBkN15,),
            Container(
              padding:const EdgeInsets.only(top:5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: InputForm(
                        onlyDigit: false,
                        readOnly: false,
                        maxLength:32,
                        hintText: "즐겨찾기 명칭 (직장/자택 등)",
                        valueText: _favorite.mapTitle,
                        onChange: (value) {
                          setState(() {
                            _favorite.mapTitle = value;
                          });
                        },
                        onControl: (controller) {
                          _fNameController = controller;
                        },
                      )
                  ),
                  SizedBox(
                    width: 100,
                    child: Container(
                      padding: const EdgeInsets.only(left:10),
                      child: ButtonState(
                        enable: _favorite.mapTitle.isNotEmpty,
                        text: '위치 저장',
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        textStyle: TextStyle(
                          color: _favorite.mapTitle.isNotEmpty ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                        borderColor: Colors.black,
                        enableColor: Colors.black,
                        //enableTextColor: Colors.white,
                        onClick: () async {
                          bool rtn = await _reqAddFavorite();
                          if(rtn) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  void _updateMarker(LatLng? pos) {
    if(_markerList.isNotEmpty) {
      _markerList.clear();
    }

    _markerList.add(
        Marker(
            markerId: "base",
            markerImageSrc: URL_MakerSelect,//URL_MakerBase,
            latLng: _locateTarget
        )
    );

    if(pos != null) {
      _bSelected = true;
      _markerList.add(
          Marker(
            markerId: "target",
            markerImageSrc: URL_MakerSelect,
            latLng: pos,
          )
      );
    }
    _mapController.addMarker(markers: _markerList);
  }

  Future <void> _goMyLocate() async {
    _mapController.setLevel(5);
    _mapController.setCenter(LatLng(_gpsProvider.latitude(), _gpsProvider.longitude()));
    setState(() {});
  }

  Future <void> _searchAddress() async {
    Kpostal result = await Navigator.push(context,
        MaterialPageRoute(builder: (_) => KpostalView(
          //kakaoKey: kakao_javaScriptAppKey,
        ))
    );
    setState(() {
      _bSelected = true;
      _favorite.mapAddr = result.address;
      _favorite.mapX = result.longitude!;
      _favorite.mapY = result.latitude!;
      _favorite.mapDesc = "";
    });
  }

  Future <void> reqAddress(double longitude, double latitude) async {
    _favorite.mapY = latitude;
    _favorite.mapX = longitude;

    await Remote.getAddress(
        longitude: longitude.toString(),
        latitude: latitude.toString(),
        onError: (String error) {},
        onResult: (dynamic data) {
          if (kDebugMode) {
            var logger = Logger();
            logger.d(data);
          }

          // if(kDebugMode) {
          //   String address = data['road_address']['address_name'];
          //   String region = data['road_address']['region_2depth_name'];
          //   String building_name = data['road_address']['building_name'];
          //   print(address);
          //   print(region);
          //   print(building_name);
          // }

          var roadAddress = data['road_address'];
          var dongAddress = data['address'];
          if(dongAddress != null) {
            //_favorite.mapTitle = dongAddress['region_3depth_name'];
            _favorite.mapAddr  = dongAddress['address_name'];
          }

          if(roadAddress != null) {
            //_favorite.mapTitle = roadAddress['building_name'];
            _favorite.mapAddr = roadAddress['address_name'];
          }
        });
  }

  Future <bool> _reqAddFavorite() async {
    bool flag = false;
    if(_favorite.mapTitle.isEmpty) {
      showToastMessage("즐겨찾기명을 입력하세요.");
      return flag;
    }

    if(_favorite.mapAddr.isEmpty) {
      showToastMessage("위치 정보를 지정해주세요.");
      return flag;
    }

    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/mberMap/insert.do",
      params: _favorite.toMap(),
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          flag = true;
        }
        showToastMessage(data['message']);
      },
    );
    return flag;
  }
}
