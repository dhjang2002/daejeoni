// ignore_for_file: unused_element, non_constant_identifier_names, file_names, must_be_immutable
import 'dart:async';
import 'dart:io';
import 'package:daejeoni/common/cardEventTile.dart';
import 'package:daejeoni/common/cardGCheck.dart';
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/route.dart';
import 'package:daejeoni/models/ItemContent.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';


class KakaoMapView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final Function(KakaoMapController ctrl) onCreate;
  final Function(String value) onFilter;

  final LatLng locateHome;
  final String locateName;
  final List<MenuButtonCheckItem>? filterItems; // 구분
  final List<GCheckItem>? subFilter1;   // 병원
  final List<GCheckItem>? subFilter2;   // 약국
  final bool modeSelect;
  final List<ItemContent>? contentList;
  final String tag;

  final Function() changeLocation;
  final Function(LatLng latLng, int count, String distance) onMapChanged;

  KakaoMapView({
    Key? key,
    required this.tag,
    required this.onBack,
    required this.onSearch,
    required this.locateHome,
    required this.locateName,
    required this.filterItems,
    required this.modeSelect,
    this.subFilter1,
    this.subFilter2,
    this.contentList = const [],
    // this.markers = const [],
    // this.circlesList = const[],
    required this.onCreate,
    required this.onFilter,
    required this.changeLocation,
    required this.onMapChanged,
  }) : super(key: key);

  @override
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  KakaoMapController? _mapController;
  double diffMax = 0.007;
  int initZoomLevel = 5;
  int currZoomLevel = 5;
  int contentCount  = 50;
  String distance = "10";
  String _currContentOid = "";
  late double _infoMaxHeight;
  late SessionData _session;
  List<Circle> _circlesList = [];
  bool _bReady = false;
  late LatLng mapCenter;

  @override
  void initState() {
    if (kDebugMode) {
      print("KakaoMapView::initState().");
    }
    mapCenter = LatLng(widget.locateHome.latitude, widget.locateHome.longitude);
    // mapCenter.latitude  = widget.locateHome.latitude;
    // mapCenter.longitude = widget.locateHome.longitude;
    _session = Provider.of<SessionData>(context, listen: false);
    _currContentOid = "";

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 100;
    }

    Future.delayed(Duration(milliseconds: delay), () async {
      setState(() {
        _bReady = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _currContentOid = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double rt = getMainAxis(context);
    double childAspectRatio = 2.0;
    if(rt<1.18) {
      childAspectRatio = 2.6;
    } else if(rt<1.55) {
      childAspectRatio = 2.6;
    } else if(rt<2.42) {     // 갤럭시 폴더
      childAspectRatio = 2.0;
    } else if(rt<2.70) {
      childAspectRatio = 1.8;
    }

    if(!_bReady) {
      return Container();
    }
    //final mapView_height = MediaQuery.of(context).size.height-52;
    _infoMaxHeight = MediaQuery.of(context).size.width * 0.65;
    return Material(
      child: SizedBox(
          //height: MediaQuery.of(context).size.height-52,
          width: MediaQuery.of(context).size.width,
          child:Stack(
            children: [
              Positioned(
                  //left: 0,right: 0, top: 0, bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    //height: MediaQuery.of(context).size.height-52,
                    child: KakaoMap(
                      currentLevel:initZoomLevel,
                      zoomControl:false,
                      center: widget.locateHome,
                      onMapTap:(LatLng latLng) {
                        _onMakerTap("");
                      },
                      onMapCreated: (controller) {
                        if (kDebugMode) {
                          print("KakaoMap::onMapCreated().");
                        }
                        _mapController = controller;
                        // setState(() {
                        // });
                        //_goCenter();
                        //_mapController!.clearCircle();
                        _circlesList = [
                          Circle(
                              circleId: "0",
                              center: widget.locateHome,
                              strokeWidth: 1,
                              strokeColor: Colors.red,
                              strokeOpacity: 0.1,
                              strokeStyle: StrokeStyle.solid,
                              fillColor: Colors.red,
                              fillOpacity: 0.1,
                              radius: 1000
                          ),
                        ];
                        _mapController!.addCircle(circles:_circlesList);
                        widget.onCreate(_mapController!);
                        /*
                      int delay = 100;
                      if (Platform.isAndroid) {
                        delay = 100;
                      }
                      Future.delayed(Duration(milliseconds: delay),() {
                        setState(() {});
                        widget.onCreate(_mapController!);
                      });
                       */
                      },
                      onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {
                        _onMakerTap(markerId);
                      },
                      onZoomChangeCallback:(int zoomLevel, ZoomType zoomType) {
                        if(currZoomLevel != zoomLevel) {
                          currZoomLevel = zoomLevel;
                          switch(currZoomLevel) {
                            case 1:
                            case 2:
                              diffMax =  0.0005;
                              contentCount = 25;
                              distance = "3";
                              break;
                            case 3:
                              diffMax =  0.001;
                              contentCount = 50;
                              distance = "3";
                              break;
                            case 4:
                              diffMax =  0.003;
                              contentCount = 70;
                              distance = "5";
                              break;
                            case 5:
                              diffMax =  0.007;
                              contentCount = 100;
                              distance = "10";
                              break;
                            case 6:
                              diffMax =  0.03;
                              contentCount = 100;
                              distance = "30";
                              break;
                            case 7:
                              diffMax =  0.01;
                              distance = "50";
                              contentCount = 200;
                              break;
                            case 8:
                              // diffMax =  0.5;
                              // break;
                            default:
                              diffMax =  1.5;
                              distance = "100";
                              contentCount = 200;
                              break;
                          }
                          print(
                              "onZoomChangeCallback($currZoomLevel) **************************");
                        }
                      },

                      onCenterChangeCallback:(LatLng latlng, int zoomLevel){
                        if(_mapController != null) {
                          // print("onCenterChangeCallback(${latlng
                          //     .latitude}, ${latlng.longitude}):...");
                          double dfLat = (mapCenter.latitude - latlng.latitude)
                              .abs();
                          double dflon = (mapCenter.longitude -
                              latlng.longitude).abs();
                          if (dflon > diffMax || dfLat > diffMax) {
                            mapCenter.latitude  = latlng.latitude;
                            mapCenter.longitude = latlng.longitude;
                            print("MAP Center Moved($currZoomLevel:$diffMax)........");
                            widget.onMapChanged(mapCenter, contentCount, distance);
                          }
                        }
                      },
                      // onBoundsChangeCallback:(LatLngBounds latLngBounds){
                      //   print("onBoundsChangeCallback():...");
                      // }
                    ),
                  ),
              ),

              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Row(
                      children: [
                        FloatingActionButton(
                            heroTag: "${widget.tag}_list",
                            backgroundColor: Colors.white,
                            child: const Icon(
                              Icons.list_alt_outlined,
                              color: Colors.black,
                              size: 28,
                            ),
                            onPressed: () {
                              widget.onBack();
                            }),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                _currContentOid = "";
                                _mapController!.clearCircle();
                                widget.changeLocation();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20, right: 20),
                                padding: (_session.isSigned())
                                    ? const EdgeInsets.fromLTRB(20, 5, 20, 0)
                                    : const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration:  BoxDecoration(
                                  color: const Color(0x4FFFFFFF),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xFFC9CACF),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      "${widget.locateName} 주변",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ItemBkB16,
                                    ),
                                    Visibility(
                                      visible: _session.isSigned(),
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 18,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),

                        FloatingActionButton(
                            heroTag: "${widget.tag}_find",
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.search,
                                color: Colors.black, size: 30),
                            onPressed: () {
                              _currContentOid = "";
                              widget.onSearch();
                            }),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 5, top:120, right: 5,
                child: Visibility(
                  visible: widget.filterItems!.isNotEmpty,//widget.filterItems!.isNotEmpty,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        MenuButtonCheck(
                          margin: EdgeInsets.zero,
                          modeSelect:widget.modeSelect,
                          items: widget.filterItems!,
                          childAspectRatio:childAspectRatio,
                          borderRadius: 10.0,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item) {
                            if(item.select) {
                              for (var element in widget.filterItems!) {
                                if (!element.control) {
                                  element.select = false;
                                }
                              }
                            }
                          },
                          onChange: (List<MenuButtonCheckItem> items) {
                            String idString = "";
                            bool checked = false;
                            for (var element in items) {
                              if(!element.control && element.select) {
                                checked = true;
                              }
                              if(!element.control && element.select) {
                                if(idString.isNotEmpty) {
                                  idString = "$idString,";
                                }
                                idString += element.tag.toString();
                              }
                            }
                            items[0].select = !checked;

                            _currContentOid = "";
                            _mapController!.clearMarker();

                            setState(() {});

                            widget.onFilter(idString);
                          },
                        ),
                        Visibility(
                          visible: widget.tag=="SOS" &&
                              widget.filterItems != null &&
                              widget.filterItems!.length>2 &&
                              (widget.filterItems![1].select || widget.filterItems![2].select),

                          child: Container(
                            margin: const EdgeInsets.only(top:5 ),
                            height: 44,
                            alignment: Alignment.centerLeft,
                            color: Colors.transparent,
                            child: (widget.subFilter1 != null && widget.subFilter1!.isNotEmpty) ? CardGCheck(
                              tag: '',
                              isVertical: false,
                              isUseCode: true,
                              aList: (widget.filterItems![1].select) ? widget.subFilter1! : widget.subFilter2!,
                              initValue: '',
                              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFC9CACF),
                                ),
                              ),
                              onSubmit: (String tag, String answerTag, String answerText) {
                                _currContentOid = "";
                                _mapController!.clearMarker();
                                setState(() {});
                                widget.onFilter(answerText);
                              },
                            ) :  null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Visibility(
                  visible: _currContentOid.isEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(left:10, bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: FloatingActionButton.small(
                              heroTag: "${widget.tag}_home",
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.navigation_outlined,
                                  color: Colors.blueAccent, size: 24),
                              onPressed: () {
                                _goCenter();
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Visibility(
                    visible: _currContentOid.isNotEmpty,
                    child: AnimatedSize(
                      curve: Curves.easeInOutSine,//fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,//const Color(0xFFEAEAEA),
                        child: _showEventInfo(_infoMaxHeight, _infoMaxHeight * 0.4),
                      ),
                    )
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _showEventInfo(double viewHeight, double imageSize) {
    int index = _findContentIndex(_currContentOid);
    if(index<0) {
      return Container();
    }
    ItemContent item = widget.contentList![index];
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 30),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
            )
        ),
        child: CardEventTile(
            item: item,
            imageSize: imageSize,
            onFavorites: (ItemContent item){
            },
            onTab: (ItemContent item){
              Future.microtask(() {
                pushContent(context, item, "MapView");
              });
            }
        )
    );
  }

  int _findContentIndex(String content_oid) {
    int index = -1;
    for(int n=0; n<widget.contentList!.length; n++) {
      //print("[${widget.contentList![n].content_oid}] = ${widget.contentList![n].content_title}");
      if(widget.contentList![n].content_oid.toString()==content_oid) {
        index = n;
        break;
      }
    }
    return index;
  }

  void _closeInfo() {
    setState((){
      _currContentOid = "";
    });
  }

  void _onMakerTap(String content_oid) {
    //print("_onMakerTap(content_oid=$content_oid)");
    setState(() {
      _currContentOid = content_oid;
    });
  }

  Future <void> _goCenter() async {
    if(_mapController != null) {
      _mapController!.setLevel(initZoomLevel);
      _mapController!.setCenter(widget.locateHome);
    }
  }

}
