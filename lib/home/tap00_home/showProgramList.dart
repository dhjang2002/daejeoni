// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:io';

import 'package:daejeoni/cache/cacheProgramList.dart';
import 'package:daejeoni/cache/requestParam.dart';
import 'package:daejeoni/common/buttonRoundRect.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/common/cardTabbar.dart';
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/common/menuButtonRadio.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/map/kakaoMapView.dart';
import 'package:daejeoni/home/map/popGpsSelect.dart';
import 'package:daejeoni/home/tap00_home/popSearchProgram.dart';
import 'package:daejeoni/home/tap00_home/showProgramDetail.dart';
import 'package:daejeoni/models/ItemContent.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/models/itemProgram.dart';
import 'package:daejeoni/provider/gpsStatus.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

List<MenuButtonRadioItem> PgItems_type = [
  MenuButtonRadioItem(text: "전체", tag:"", select: true,),
  MenuButtonRadioItem(text: "프로그램", tag:"PROGRM001", select: false),
  MenuButtonRadioItem(text: "양성과정", tag:"PROGRM003", select: false),
  MenuButtonRadioItem(text: "손오공 돌봄체", tag:"PROGRM004", select: false),
  MenuButtonRadioItem(text: "부모상담", tag:"PROGRM005", select: false),
  MenuButtonRadioItem(text: "공동육아나눔터", tag:"PROGRM006", select: false),
  MenuButtonRadioItem(text: "돌봄봉사단", tag:"PROGRM007", select: false),
  MenuButtonRadioItem(text: "설문조사", tag:"PROGRM008", select: false),
];

/*
CID0002   대덕구
CID0003   동구
CID0004   서구
CID0005   유성구
CID0006   중구
 */
final List<MenuButtonCheckItem> PgItems_area = [
  MenuButtonCheckItem(text: "전체", tag:"", select: true, control: true),
  MenuButtonCheckItem(text: "동구", tag:"CID0003", select: false),
  MenuButtonCheckItem(text: "중구", tag:"CID0006", select: false),
  MenuButtonCheckItem(text: "서구", tag:"CID0004", select: false),
  MenuButtonCheckItem(text: "대덕구", tag:"CID0002", select: false),
  MenuButtonCheckItem(text: "유성구", tag:"CID0005", select: false),
];

class ShowProgramList extends StatefulWidget {
  const ShowProgramList({Key? key}) : super(key: key);

  @override
  State<ShowProgramList> createState() => _ShowProgramListState();
}

class _ShowProgramListState extends State<ShowProgramList> {
  final GlobalKey _posKeyHome = GlobalKey();
  final List<TabbarItem> _boardTabitems = [
    TabbarItem(name: "전체", tag: ""),
    //TabbarItem(name: "접수예정", tag: "1"),
    TabbarItem(name: "진행중", tag: "3"),
    //TabbarItem(name: "지난 행사", tag: "4"),
  ];

  late RequestParam _reqParam;
  late CacheProgramList _cacheData;
  late KakaoMapController? _mapController;
  List<ItemContent>  _mapContentList = [];
  final List<Marker> _mapMarkerList = <Marker>[];

  late SessionData _session;
  bool isDisposed = false;
  int _tabIndex = 0;

  late GpsStatus _gpsProvider;
  LatLng? _locateHome;
  String  _locateName = "";

  late int _pageStage;

  void _setSearchCondition(String? keyword, String? strDateBegin, String? strDateEnd) {
    if(strDateBegin != null) {
      _reqParam.strDateBegin = strDateBegin;
    }
    if(strDateEnd != null) {
      _reqParam.strDateEnd = strDateEnd;
    }

    _reqParam.strState     = _boardTabitems[_tabIndex].tag;

    if(keyword != null) {
      _reqParam.setKeyword(keyword);
    }

    _reqParam.prgType = "";
    _reqParam.prgTypeInfo = "";
    for (var element in PgItems_type) {
      if(element.select) {
        if(_reqParam.prgType.isNotEmpty) {
          _reqParam.prgType += ",";
        }
        _reqParam.prgType += element.tag;
        _reqParam.prgTypeInfo += element.text;
      }
    }

    _reqParam.insttSgg = "";
    _reqParam.insttSggInfo = "";
    for (var element in PgItems_area) {
      if(element.select) {
        if(_reqParam.insttSgg.isNotEmpty) {
          _reqParam.insttSgg += ",";
        }
        _reqParam.insttSgg += element.tag;

        if(_reqParam.insttSggInfo.isNotEmpty) {
          _reqParam.insttSggInfo += ",";
        }
        _reqParam.insttSggInfo += element.text;
      }
    }
  }

  @override
  void initState() {
    _pageStage = STAGE_LIST;

    _session   = Provider.of<SessionData>(context, listen: false);
    _gpsProvider = Provider.of<GpsStatus>(context, listen: false);
    _cacheData = Provider.of<CacheProgramList>(context, listen: false);
    _cacheData.clear();
    _reqParam = RequestParam();
    _reqParam.setMapType("PRG");
    _reqParam.setPageToCount(4);
    //_reqParam.setOrder("거리순");
    _reqParam.setSession(_session);
    _reqParam.setOrderList("이름순,거리순,최신순", "최신순");
    _setSearchCondition("", null, null);

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 100;
    }

    _showProgress(true);

    Future.delayed(Duration(milliseconds: delay), () async {
      await _gpsProvider.updateGeolocator(false);
      await _session.updateGpsLocation(_gpsProvider.longitude(), _gpsProvider.latitude());
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
    _mapController = null;
  }

  bool _bWait = false;
  void _showProgress(bool bShow) {
    setState(() {
      _bWait = bShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cacheData   = Provider.of<CacheProgramList>(context, listen: true);
    return Scaffold(
      body: WillPopScope(
          onWillPop: onWillPop,
          child:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CustomScrollView(
                        slivers: [
                          _renderSliverAppbar(),
                          _renderWellcome(),
                          _renderLocateBar(),
                          _renderTapMenu(),
                          _renderListHeader(),
                          _renderListView(),
                          _renderEmptyData(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: _pageStage == STAGE_MAP,
                      child: (_locateHome != null)
                          ? KakaoMapView(
                        tag: "PRG",
                        locateHome: _locateHome!,
                        locateName: _locateName,
                        contentList: _mapContentList,
                        filterItems: const [],
                        modeSelect: false,
                        onBack: () {
                          setState(() {
                            _pageStage = STAGE_LIST;
                          });
                        },
                        onSearch: () {
                          _doSearch();
                        },
                        onCreate: (cntl) async {
                          _mapController = cntl;
                          _mapController!.clearMarker();
                          setState(() {});

                          Future.delayed(const Duration(milliseconds: 100), () async {
                            // if (kDebugMode) {
                            //   print(
                            //       "PageExperience::onCreate(): draw marker .......................................");
                            // }

                            _updateMarkerList();
                            if (_mapController != null) {
                              _mapController!.addMarker(markers: _mapMarkerList);
                            }

                            Future.delayed(
                                const Duration(milliseconds: 300), () async {
                              // if (kDebugMode) {
                              //   print(
                              //       "PageExperience::onCreate(): draw marker->ready .......................................");
                              // }
                              setState(() {});
                            });
                          });
                        },
                        onFilter: (String idString) async {
                          _setSearchCondition(null, null, null);
                          await _requestFirst();
                          if(_pageStage==STAGE_MAP) {
                            await _reqMapContent();
                            _updateMarkerList();
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
                          if(_pageStage==STAGE_MAP) {
                            _mapController!.clearMarker();
                            setState(() {});
                            _updateMarkerList();
                            _mapController!.addMarker(markers: _mapMarkerList);
                            setState(() {});
                          }
                        },
                      )
                          : Container(),
                    )
                ),
                Align(
                    alignment: (_cacheData.isFirst)
                        ? Alignment.center
                        : Alignment.bottomCenter,
                    //left: 0,right: 0, bottom: 0,
                    child: Visibility(
                      visible: _pageStage == STAGE_LIST && _cacheData.loading || _bWait,
                      child: Container(
                        width: double.infinity,
                        height: 25,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: (_cacheData.hasMore)
                            ? const Center(
                            child: SizedBox(
                                width: 25,
                                child: CircularProgressIndicator()))
                            : const Center(child: Icon(Icons.arrow_drop_up)),
                      ),
                    )
                ),
                Positioned(
                    bottom: 50, right: 5,
                    child: Visibility(
                      visible: _pageStage == STAGE_LIST,
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
              ]
          )
      )
      ),
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

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      key: _posKeyHome,
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("문화/행사"),
      leading: Visibility(
        visible: true,
        child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 26,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      actions: [
        Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.search, size: 26,),
              onPressed: () async {
                _doSearch();
              }),
        ),

        // 새로고침
        Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
              onPressed: () async {
                //_reqParam.page = 1;
                await _requestFirst();
                await _reqMapContent();
              }),
        ),
      ],
      //expandedHeight: 70
    );
  }
  SliverList _renderWellcome() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: const Column(
              children: [
                Row(
                  children: [
                    Text("대전아이와 함께하는", style: ItemBkN20,),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("전체 문화/행사", style: ItemGrTitle,),
                  ],
                ),
              ],
            ),
          )
        ]));
  }
  SliverList _renderTapMenu() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: CardTabbar(
            items: _boardTabitems,
            index: _tabIndex,
            itemWidth: MediaQuery.of(context).size.width/4.2,
            textSize: 13,
            selectColor: Colors.green,
            normalColor: Colors.grey,
            selectBarColor: Colors.green,
            normalBarColor: Colors.grey[100],
            onChange: (index, item) async {
              _reqParam.strState = item.tag;
              setState(() {
                _tabIndex = index;
              });
              await _requestFirst();
            },
          ),
        ),
      ]),
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
                      height: 28,
                      width: 64,
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: ButtonRoundRect(
                        enable: _session.isSigned(),
                        radious: 5,
                        text: '위치변경',
                        fontSize: 11,
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

                const Divider(height: 5,),
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
  SliverList _renderListView() {
    return SliverList.builder(
      itemCount: _cacheData.cache.length,
      itemBuilder: (BuildContext context, int index) {
        if (_cacheData.cache.length > 3 &&
            index+1 == _cacheData.cache.length) {
          if (!_cacheData.loading && _cacheData.hasMore) {
            Future.microtask(() {
              _requestMore();
            });
          }
        }

        //print("index-----------------> $index");
        ItemProgram item = _cacheData.cache[index];
        return _itemCardProgramTile(item);
      },
    );
  }

  Widget _itemCardProgramTile(ItemProgram item) {
    final szHeight = MediaQuery.of(context).size.width*0.76;
    String edInfo= "미정";
    if(item.eduBgngDt.isNotEmpty && item.eduEndDt.isNotEmpty) {
      edInfo = "${item.eduBgngDt.substring(0,10).replaceAll("-", ".")}\n\t~ ${item.eduEndDt.substring(0,10).replaceAll("-", ".")}";
    }

    String dist = "정보없음";//"";
    if(item.myDstnc>=0.0) {
      dist = "${(item.myDstnc * 100).truncate() / 100} Km";
    }

    return GestureDetector(
        onTap: () {
          _doShowProgramDetail(item);
        },
        child: Container(
            height: szHeight,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 45,
                    child: SizedBox(
                      height: szHeight*0.82,
                      child: CardPhoto(
                        photoUrl: item.image_url,
                        fit: BoxFit.fill,
                      ),
                    ),
                ),
                Expanded(
                  flex: 55,
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("[${item.getArea()}]", style: const TextStyle(fontSize: 12, color: Colors.black),),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                //padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: Center(
                                  child: Text(dist, style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.eduSj,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: -1.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 5,),
                        SizedBox(height: 3,),
                        _rowItem("주최기관", Colors.black, item.openInstt),
                        _rowItem("행사기간", Colors.amber, "${item.rangeText(item.eduBgngDt,item.eduEndDt,"\n\t")}"),
                        _rowItem("신청기간", Colors.green, "${item.rangeText(item.rcptBgngDt,item.rcptEndDt, "\n\t")}"),
                        _rowItem("참여대상", Colors.orange, "${item.partcptnTrgt}"),
                        _rowItem("참가비용", Colors.blueAccent, "${item.partcptCt}"),
                        // _rowItem("접수형태", Colors.blueAccent, "${item.applyType()}"),
                        // _rowItem("진행문의", Colors.blueAccent, "${item.progrsInqry}"),
                        // _rowItem("진행장소", Colors.blueAccent, "${item.progrsPlace}"),
                        Visibility(
                          visible: item.validateMessage.isNotEmpty,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                            width: double.infinity,
                            child: Text(item.validateMessage, style: ItemG1N12,),
                          ),
                        ),
                        /*
                        const Spacer(),
                        Visibility(
                          visible: item.validateMessage.isEmpty,
                          child: SizedBox(
                          //padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          width: double.infinity,
                          child: ButtonState(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            enable: item.isAvailable(),
                            enableColor: Colors.green,
                            borderRadius: item.isAvailable() ? 5 : 0,
                            borderColor: item.isAvailable() ? Colors.green : Colors.transparent,
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: item.isAvailable() ? Colors.white : Colors.black
                            ),
                            text: item.isAvailable() ? '신청가능' : '신청마감',
                            onClick: () {
                              _doShowProgramDetail(item);
                            },
                          ),
                        ),
                        ),
                        */
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget _rowItem(String label, Color labelColor, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 22,
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(5),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 1,
              //     offset: const Offset(0, 0.5), // changes position of shadow
              //   ),
              // ],
            ),
            child: Center(
              child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  letterSpacing: -1.5,
              ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(value,
                  overflow: TextOverflow.ellipsis,
                  style: ItemBkN12,),
              )
          ),
        ],
      ),
    );
  }

  void _doSearch() {
    showSearchProgram(
        context: context,
        title: '상세검색',
        items_type:PgItems_type,
        items_area: PgItems_area,
        onResult: (bool bOK,
            String keyword,
            String strState,
            String strType,
            String strDateBegin,
            String strDateEnd) async {
          if(bOK) {
            _setSearchCondition(keyword, strDateBegin, strDateEnd);
            await _requestFirst();
            if(_pageStage==STAGE_MAP) {
              await _reqMapContent();
              _updateMarkerList();
              setState(() {});
            }
          }

        }
    );
  }

  void _doChangeLocation() {
    if(!_session.isSigned()) {
      return;
    }

    BottomGpsSelect(
        context: context,
        title: "위치변경",
        onResult: ( bOk, item) async {
          ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
          _locateHome = LatLng(gps.mapY, gps.mapX);
          _locateName = gps.mapTitle;
          _reqParam.setLocation(gps.mapX, gps.mapY);
          await _requestFirst();
          await _reqMapContent();
          if(_pageStage==STAGE_MAP && _mapController != null) {
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
            _updateMarkerList();
            _mapController!.addMarker(markers: _mapMarkerList);
            setState(() {

            });
          }
        }
    );
  }

  Future<void> _doShowProgramDetail(ItemProgram item) async {
    Navigator.push(
      context,
      Transition(
          child: ShowProgramDetail(
            item:item,
            eduSn: "",
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
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

  void _showMap() {
    setState(() {
      _pageStage = STAGE_MAP;
    });
  }

  Future <bool> onWillPop() async {
    if(_pageStage == STAGE_MAP) {
      setState(() {
        _pageStage = STAGE_LIST;
      });
      return false;
    }
    return true;
  }

  Future <void> _reqUpdateMapContent(LatLng latlng, int contentCount, String distance) async {
    Map<String, dynamic> params = _reqParam.getPrgParamAll(contentCount, int.parse(distance));
    params.remove("gpsLcLng");
    params.remove("gpsLcLat");
    params.addAll({'gpsLcLng': latlng.longitude, 'gpsLcLat': latlng.latitude});

    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/parnts/edu_list.do",
      params: params,
      onError: (String error) {
      },
      onResult: (dynamic data) {
        var value = data['data'];
        var content = value['list'];
        if(content != null) {
          _mapContentList = ItemContent.fromPrgSnapshot(content);
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
      method: "appService/parnts/edu_list.do",
      params: _reqParam.getPrgParamAll(50, 30),
      onError: (String error) {},
      onResult: (dynamic data) {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }

        var value = data['data'];
        var content = value['list'];
        if(content != null) {
          _mapContentList = ItemContent.fromPrgSnapshot(content);
        }
        else {
          _mapContentList = [];
        }
      },
    );
    _updateMarkerList();
  }

  void _updateMarkerList() {

    if(_mapMarkerList.isNotEmpty) {
      _mapMarkerList.clear();
    }

    _mapMarkerList.add(
        Marker(
          //width: 24, height: 24,
            markerId: "",
            markerImageSrc: URL_MakerSelect,
            latLng: _locateHome!
        )
    );

    for (var item in _mapContentList) {
      _mapMarkerList.add(
          Marker(
            width: 34, height: 34,
            markerId: item.content_oid.toString(),
            markerImageSrc: URL_MakerPrg,
            latLng: LatLng( item.longitude, item.latitude,),
          )
      );
    }

    // print(_mapMarkerList.toString());
  }

}
