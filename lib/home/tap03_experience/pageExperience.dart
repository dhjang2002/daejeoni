// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, must_be_immutable
import 'dart:io';

import 'package:daejeoni/common/buttonRoundRect.dart';
import 'package:daejeoni/common/cardEventTile.dart';
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/map/kakaoMapView.dart';
import 'package:daejeoni/home/map/popGpsSelect.dart';
import 'package:daejeoni/home/route.dart';
import 'package:daejeoni/home/tap03_experience/popSearchExp.dart';
import 'package:daejeoni/models/ItemContent.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/provider/gpsStatus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:daejeoni/cache/cacheMapList.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';

final List<MenuButtonCheckItem> exp_items = [
  MenuButtonCheckItem(text: "전체", tag:"", select: true, control: true),
  MenuButtonCheckItem(text: "놀이・힐링", tag:"1", select: false),
  MenuButtonCheckItem(text: "교육・역사", tag:"2", select: false),
  MenuButtonCheckItem(text: "문화・예술", tag:"3", select: false),
];

class PageExperience extends StatefulWidget {
  final Function() onDrawer;
  final Function() onNotice;
  final Function() onSignin;
  int? pageStage;
  Function(int stage)? onStage;
  final Function(int page) onPage;
  PageExperience({Key? key,
    required this.onDrawer,
    required this.onNotice,
    required this.onSignin,
    this.pageStage = STAGE_LIST,
    this.onStage,
    required this.onPage,
  }) : super(key: key);

  @override
  State<PageExperience> createState() => _PageExperienceState();
}

class _PageExperienceState extends State<PageExperience> {
  final GlobalKey _posKeyHome = GlobalKey();

  late RequestParam _reqParam;
  late CacheMapList _cacheData;

  KakaoMapController? _mapController;
  List<ItemContent> _mapContentList = [];
  final List<Marker> _mapMarkerList = <Marker>[];
  final List<Circle> circlesList = [];

  bool isDisposed = false;

  late SessionData _session;

  late GpsStatus _gpsProvider;
  LatLng? _locateHome;
  String  _locateName = "";

  void _setSearchCondition(String keyword) {
    _reqParam.setKeyword(keyword);
    _reqParam.mapCtgryCd = "";
    _reqParam.mapCtgryCdInfo = "";
    for (var element in exp_items) {
      if(element.select) {
        if(_reqParam.mapCtgryCd.isNotEmpty) {
          _reqParam.mapCtgryCd += ",";
        }
        _reqParam.mapCtgryCd += element.tag;

        if(_reqParam.mapCtgryCdInfo.isNotEmpty) {
          _reqParam.mapCtgryCdInfo += ",";
        }
        _reqParam.mapCtgryCdInfo += element.text;
      }
    }
  }

  @override
  void initState() {
    if (kDebugMode) {
      print("PageExperience::initState(stage=${widget.pageStage}).");
    }

    _session     = Provider.of<SessionData>(context, listen: false);
    _gpsProvider = Provider.of<GpsStatus>(context, listen: false);
    _cacheData   = Provider.of<CacheMapList>(context, listen: false);
    _cacheData.clear();
    _cacheData.setTag("MAP");

    _reqParam = RequestParam();
    _reqParam.setMapType("MAP");
    _reqParam.area = "999999";
    _reqParam.setPageToCount(8);
    _reqParam.setOrder("거리순");
    _reqParam.setSession(_session);
    _setSearchCondition("");

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 100;
    }

    _showProgress(true);

    Future.delayed(Duration(milliseconds: delay), () async {
      await _gpsProvider.updateGeolocator(false);
      await _session.updateGpsLocation(_gpsProvider.longitude(),
          _gpsProvider.latitude());
      ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
      _locateHome = LatLng(gps.mapY, gps.mapX);
      _locateName = gps.mapTitle;
      _reqParam.setLocation(gps.mapX, gps.mapY);

      await _reqMapContent();
      await _requestFirst();
      _showProgress(false);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cacheData.clear();
    isDisposed = true;
    //_mapController = null;
  }

  bool _bWait = false;
  void _showProgress(bool bShow) {
    setState(() {
      _bWait = bShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cacheData   = Provider.of<CacheMapList>(context, listen: true);
    _gpsProvider = Provider.of<GpsStatus>(context, listen: true);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              //bottom: 0,
              child: Visibility(
                visible: widget.pageStage == STAGE_LIST,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height-52,
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: CustomScrollView(
                      slivers: [
                        _renderSliverAppbar(),
                        _renderLocateBar(),
                        _renderListHeader(),
                        _renderEmptyData(),
                        _renderListView(),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Visibility(
                visible: widget.pageStage == STAGE_MAP,
                child: (_locateHome != null)
                    ? KakaoMapView(tag:"EXP",
                  locateHome: _locateHome!,
                  locateName: _locateName,
                  contentList: _mapContentList,
                  filterItems: exp_items,
                  modeSelect: false,
                  onBack: () {
                    setState(() {
                      widget.pageStage = STAGE_LIST;
                    });

                    if(widget.onStage != null) {
                      widget.onStage!(STAGE_LIST);
                    }
                  },
                  onSearch: () {
                    _doSearch();
                  },
                  onCreate: (cntl) async {
                    // print(
                    //     "PageExperience::onCreate()...................................... start.");
                    _mapController = cntl;
                    _mapController!.clearMarker();
                    setState(() {});

                    Future.delayed(const Duration(milliseconds: 100), () async {
                      // if (kDebugMode) {
                      //   print(
                      //       "PageExperience::onCreate(): draw marker .......................................");
                      // }

                      _updateMarkerList(false);
                      if (_mapController != null) {
                        _mapController!.addMarker(markers: _mapMarkerList);
                      }

                      Future.delayed(
                          const Duration(milliseconds: 300), () async {
                        if (kDebugMode) {
                          print(
                              "PageExperience::onCreate(): draw marker->ready .......................................");
                        }
                        setState(() {});
                      });
                    });
                  },
                  onFilter: (String idString) async {
                    _reqParam.setCategory(idString);
                    await _requestFirst();
                    if(widget.pageStage==STAGE_MAP) {
                      await _reqMapContent();
                      await _updateMarkerList(false);
                      _mapController!.addMarker(markers: _mapMarkerList);
                      setState(() {});
                    }
                  },
                  changeLocation: () {
                    _doChangeLocation();
                  },
                  onMapChanged: (LatLng latLng, int contentCount, String distance) async {
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> onMapChanged........");
                    await _reqUpdateMapContent(latLng, contentCount, distance);
                    if(widget.pageStage==STAGE_MAP) {
                      _mapController!.clearMarker();
                      setState(() {});
                      _updateMarkerList(false);
                      _mapController!.addMarker(markers: _mapMarkerList);
                      setState(() {});
                    }
                  },
                )
                    : Container(),
              )
          ),
          Align(
              alignment: (_cacheData.isFirst || _gpsProvider.bWait)
                  ? Alignment.center
                  : Alignment.bottomCenter,
              //left: 0,right: 0, bottom: 0,
              child: Visibility(
                visible: (widget.pageStage == STAGE_LIST && (_cacheData.loading || _bWait || _gpsProvider.bWait)),
                child: Container(
                  width: double.infinity,
                  height: 25,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: (_cacheData.hasMore)
                      ? const Center(
                      child: const SizedBox(
                          width: 25,
                          child: const CircularProgressIndicator()))
                      : const Center(child: Icon(Icons.arrow_drop_up)),
                ),
              )
          ),
          Positioned(
              bottom: 20, right: 5,
              child: Visibility(
                visible: widget.pageStage == STAGE_LIST,
                child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    onPressed: (){
                      Scrollable.ensureVisible(
                          _posKeyHome.currentContext!,
                          duration: const Duration(
                              milliseconds: moveMilisceond)
                      );
                    },
                    child: const Icon(Icons.arrow_upward,
                        color: Colors.black)
                ),
              )
          ),
        ],
      ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
        key: _posKeyHome,
        floating: true,
        centerTitle: true,
        //pinned: true,
        title: Image.asset("assets/intro/intro_logo.png",
            height: 38, fit: BoxFit.fitHeight),
        leading: Visibility(
          visible: true, //(_tabIndex == 0), //(_m_isSigned && _bSearch),
          child: IconButton(
              icon: Image.asset(
                "assets/icon/top_menu.png",
                height: app_top_size_menu, fit: BoxFit.fitHeight,
                color: Colors
                    .black, //(_tabIndex == 4) ? Colors.black : Colors.white,
              ),
              onPressed: () {
                widget.onDrawer();
              }),
        ),
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
                onPressed: () async {
                  await _gpsProvider.updateGeolocator(true);
                  await _session.updateGpsLocation(_gpsProvider.longitude(),
                      _gpsProvider.latitude());
                  ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
                  _locateHome = LatLng(gps.mapY, gps.mapX);
                  _locateName = gps.mapTitle;
                  _reqParam.setLocation(gps.mapX, gps.mapY);
                  await _requestFirst();
                  setState(() {});
                }),
          ),

          // 알림
          Visibility(
            visible: true, //(_bSearch && _tabIndex != 0),
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: getNotificationIcon(
                    isDenaied: _session.bDeniedNotice,
                    isRecevied: _session.bOnNotice
                ),
                onPressed: () {
                  setState(() {
                    widget.onNotice();
                  });
                }),
          ),
          // 로그인
          Visibility(
            visible: _session.IsSigned != "Y", //(_bSearch && _tabIndex != 0),
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: Image.asset("assets/quick/user.png",
                  height: app_top_size_user, fit: BoxFit.fitHeight,
                ),
                onPressed: () {
                  setState(() {
                    widget.onSignin();
                  });
                }),
          ),
        ],
        //expandedHeight: 70
    );
  }

  SliverList _renderEmptyData() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _cacheData.isEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                height: MediaQuery.of(context).size.width*0.6,
                child: Image.asset("assets/error/error_req03.png", fit: BoxFit.fitHeight,),
              )
          ),
          Visibility(
            visible: _cacheData.isEmpty,
            child:Container(
              margin: const EdgeInsets.only(top:20),
              alignment: Alignment.center,
              child: const Text("데이터가 없습니다.", style: ItemG1N15,),
            )
          )
    ])
    );
  }

  SliverList _renderLocateBar() {
    _session = Provider.of<SessionData>(context, listen: true);
    ItemFavoriteGps favoriteGps = _session.favoriteGpsList![_session.favoriteIndex];
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.maps_home_work_outlined, size: 20,
                              color: Colors.green,),
                            const SizedBox(width: 10,),
                            Expanded(
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(favoriteGps.mapTitle,
                                      style: ItemBkB12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(favoriteGps.mapAddr,
                                      style: ItemBkN12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                            ),
                          ],
                        )
                    ),

                    Container(
                      height: 30,
                      width: 64,
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: ButtonRoundRect(
                        enable: _session.isSigned(),
                        radious:5,
                        text: '위치변경',
                        fontSize: 12,
                        textColor: Colors.white,
                        backgroundColor:const Color(0xFF589BBC),
                        borderColor:const Color(0xFF589BBC),
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        onClick: () {
                          _doChangeLocation();
                        },
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 15, 5, 0),
                  child: ButtonRoundRect(
                    radious:5,
                    icon: const Icon(Icons.search, size: 18, color: Color(0xFF589BBC),),
                    iconGap: 5,
                    text: '나에게 맞는 상세검색',
                    textColor: const Color(0xFF589BBC),
                    fontSize: 12,
                    backgroundColor:Colors.white,
                    borderColor: const Color(0xFF589BBC),
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    onClick: () {
                      _doSearch();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Text(_reqParam.getInfo(), style: ItemBkN12,),
                ),
              ],
            ),
          )
        ])
    );
  }
  SliverList _renderListHeader() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: true,
              child: Container(
                margin: const EdgeInsets.only(top:20, bottom: 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_reqParam.orderValue} (${_cacheData.page.totalRecordCount})", style: ItemBkB14),
                            Text(_reqParam.orderDesc, style: ItemG1N12),
                          ],
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_reqParam.orderValue, style: ItemBkB14,),
                              Icon(Icons.arrow_drop_down, size: 18,),
                            ],
                          ),
                          onSelected: (String value) {
                            FocusScope.of(context).unfocus();
                            if(value != _reqParam.orderValue) {
                              _reqParam.setOrder(value);
                              _requestFirst();
                            }
                          },
                          itemBuilder: (BuildContext context) => _reqParam.orderList.map((value) => PopupMenuItem(
                            value: value,
                            child: Text(value, style: ItemBkN14,),
                          ))
                              .toList(),
                        ),
                        const SizedBox(width: 20,),
                        SizedBox(
                          height: 30,
                          width: 80,
                          //margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ButtonRoundRect(
                            radious:5,
                            icon: const Icon(Icons.maps_home_work_outlined,
                              size: 12, color: Colors.white,),
                            iconGap: 5,
                            text: '지도보기',
                            fontSize: 10,
                            backgroundColor:Colors.green,
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            onClick: () async {
                              _showMap();
                            },
                          ),
                        ),
                        const SizedBox(width: 5,),
                      ],
                    ),
                    //const Divider(height: 1,),
                  ],
                ),
              )
          ),
        ]));
  }

  SliverGrid _renderListView() {
    final imageSize = MediaQuery.of(context).size.width * 0.22;
    double mainAxisExtent = 110;
    final double rt = getMainAxis(context);
    if(rt<1.18) {
      mainAxisExtent = 160;
    } else if(rt<1.55) {
      mainAxisExtent = 160;
    } else if(rt<2.20) {
      mainAxisExtent = 110;
    } else if(rt<2.70) {
      mainAxisExtent = 110;
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: mainAxisExtent,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (_cacheData.cache.length > 3 &&
              index+1 == _cacheData.cache.length) {
            if (!_cacheData.loading && _cacheData.hasMore) {
              Future.microtask(() {
                _requestMore();
              });
            }
          }

          ItemContent item = _cacheData.cache[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: CardEventTile(
                item: item,
                imageSize: imageSize,
                gapHeight: 2,
                onFavorites: (ItemContent item){},
                onTab: (ItemContent item){
                  pushContent(context, item, "Exp");
                }
            ),
          );
        },
        childCount: _cacheData.cache.length,
      ),
    );
  }

  Future <void> _showMap() async {
    setState(() {
      widget.pageStage = STAGE_MAP;
    });

    if(widget.onStage!=null) {
      widget.onStage!(STAGE_MAP);
    }
  }

  void _doChangeLocation() {
    if(!_session.isSigned()) {
      return;
    }

    DlgGpsSelect(
        context: context,
        title: "위치변경",
        height: 400,
        onResult: ( bOk, item) async {
          ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
          _locateHome = LatLng(gps.mapY, gps.mapX);
          _locateName = gps.mapTitle;
          _reqParam.setLocation(gps.mapX, gps.mapY);
          await _requestFirst();
          await _reqMapContent();
          if(widget.pageStage==STAGE_MAP && _mapController != null) {
            _mapController!.setCenter(_locateHome!);
            List<Circle> circlesList = [
              Circle(
                circleId: "0",
                center: _locateHome!,
                strokeWidth: 1,
                strokeColor: Colors.red,
                strokeOpacity: 0.1,
                strokeStyle: StrokeStyle.solid,
                fillColor: Colors.red,
                fillOpacity: 0.1,
                radius: 1000
              ),
            ];
            _mapController!.addCircle(circles: circlesList);
            _updateMarkerList(false);
            _mapController!.addMarker(markers: _mapMarkerList);
            setState(() {

            });
          }
        }
    );
  }

  void _doSearch() {
    showSearchExp(
        context: context,
        title: '상세검색',
        items: exp_items,
        onResult: (bool bDirty, String keyword, String idString) async {
          _setSearchCondition(keyword);
          await _requestFirst();
          await _reqMapContent();
          if(widget.pageStage==STAGE_MAP) {
            await _updateMarkerList(false);
            setState(() {});
          }
        }
    );
  }

  // 서버에서 데이터를 가져온다.
  Future <void> _requestFirst() async {
    await _cacheData.requestFrom(context: context, param: _reqParam, first: true);
  }

  Future <void> _requestMore() async {
    if(isDisposed) {
      return;
    }
    await _cacheData.requestFrom(context: context, param: _reqParam, first: false);
  }

  Future <void> _reqUpdateMapContent(LatLng latlng, int contentCount, String distance) async {
    Map<String, dynamic> params = _reqParam.getExpParamAll(contentCount, distance);
    params.remove("gpsLcLng");
    params.remove("gpsLcLat");
    params.addAll({'gpsLcLng': latlng.longitude, 'gpsLcLat': latlng.latitude});

    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/map/list.do",
      params: params,
      onError: (String error) {
      },
      onResult: (dynamic data) {
        var value = data['data'];
        var content = value['list'];
        if(content != null) {
          _mapContentList = ItemContent.fromMapSnapshot(content);
        }
        else {
          _mapContentList = [];
        }
      },
    );
  }

  // 서버에서 데이터를 가져온다.
  Future <void> _reqMapContent() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/map/list.do",
      params: _reqParam.getExpParamAll(50, "30"),
      onError: (String error) {},
      onResult: (dynamic data) {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        var value = data['data'];
        var content = value['list'];
        if(content != null) {
          _mapContentList = ItemContent.fromMapSnapshot(content);
        }
        else {
          _mapContentList = [];
        }
      },
    );
  }

  Future <void> _updateMarkerList(bool bFirst) async {
    if(_mapMarkerList.isNotEmpty) {
      _mapMarkerList.clear();
      setState(() {});
    }

    _mapMarkerList.add(
        Marker(
            markerId: "",
            markerImageSrc: URL_MakerSelect,
            latLng: _locateHome!
        )
    );

    if(!bFirst) {
      for (var item in _mapContentList) {
        String maker = URL_MakerMap;
        _mapMarkerList.add(
            Marker(
              width: 34,
              height: 34,
              markerId: item.content_oid.toString(),
              markerImageSrc: maker,
              latLng: LatLng(item.longitude, item.latitude,),
            )
        );
      }
      //setState(() {});
    }
  }

}
