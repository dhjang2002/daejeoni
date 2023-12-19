// ignore_for_file: unused_element, non_constant_identifier_names, file_names, must_be_immutable
import 'dart:async';
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


class ShowKakaoMap extends StatefulWidget {
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
  final List<Marker>? init_markers;
  final String tag;

  final Function() changeLocation;
  ShowKakaoMap({
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
    this.init_markers = const [],
    required this.onCreate,
    required this.onFilter,
    required this.changeLocation,
  }) : super(key: key);

  @override
  State<ShowKakaoMap> createState() => _ShowKakaoMapState();
}

class _ShowKakaoMapState extends State<ShowKakaoMap> {
  KakaoMapController? _mapController;
  String _currContentOid = "";
  late double _infoMaxHeight;
  late SessionData _session;
  List<Circle> circlesList = [];
  List<Marker> markerList = [];
  bool _bReady = false;
  @override
  void initState() {
    if (kDebugMode) {
      print("ShowKakaoMap::initState().");
    }
    _session = Provider.of<SessionData>(context, listen: false);
    if(widget.init_markers!.isNotEmpty) {
      markerList = widget.init_markers!;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _bReady = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _currContentOid = "";
    _mapController = null;
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

    final mapView_height = MediaQuery.of(context).size.height-52;
    _infoMaxHeight = MediaQuery.of(context).size.width * 0.65;
    return Material(
      child: SizedBox(
          height: mapView_height,
          child:Stack(
            children: [
              Positioned(
                  left: 0,right: 0, top: 0, bottom: 0,
                  child: (_bReady) ? KakaoMap(
                    currentLevel:5,
                    zoomControl:false,
                    center: widget.locateHome,
                    onMapCreated: (controller) async {
                      if (kDebugMode) {
                        print("KakaoMap::onMapCreated().");
                      }
                      _mapController = controller;
                      await _goMyLocate();
                      Future.delayed(const Duration(milliseconds: 300), () async {
                        print("KakaoMap::onMapCreated():marker Draw.......");
                        _mapController!.addMarker(markers: markerList);
                        //setState(() {});
                      });
                    },
                    //circles: circlesList,
                    onMapTap:(LatLng latLng) {
                      _onMakerTap("");
                    },
                    //markers: widget.init_markers!,
                    onMarkerTap: (String markerId, LatLng latLng, int zoomLevel) {
                      _onMakerTap(markerId);
                    },
                  ) : Container()
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
                              //widget.onBack();
                              _mapController!.clearMarker();
                              _mapController = null;
                              Navigator.pop(context);
                            }),

                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                _currContentOid = "";
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
                            widget.init_markers!.clear();
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
                                widget.init_markers!.clear();
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
                                _goMyLocate();
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

  Future <void> _goMyLocate() async {
    if(_mapController != null) {
      _mapController!.setLevel(5);
      _mapController!.setCenter(widget.locateHome);

      if(circlesList.isNotEmpty) {
        setState(() {
          circlesList.clear();
        });
      }

      circlesList.add(
        Circle(
          circleId: circlesList.length.toString(),
          center: widget.locateHome,
          strokeWidth: 1,
          strokeColor: Colors.red,
          strokeOpacity: 0.1,
          strokeStyle: StrokeStyle.solid,
          fillColor: Colors.red,
          fillOpacity: 0.1,
          radius: 700,
        ),
      );

      _mapController!.addCircle(circles: circlesList);
      setState(() {});
    }
  }

  // void _updateMarkerList() {
  //   if(widget.markers!.isNotEmpty) {
  //     widget.markers!.clear();
  //   }
  //
  //   widget.markers!.add(
  //       Marker(
  //         //width: 24, height: 24,
  //           markerId: "",
  //           markerImageSrc: URL_MakerSelect,
  //           latLng: widget.locateHome
  //       )
  //   );
  //
  //   for (var item in widget.contentList!) {
  //     widget.markers!.add(
  //         Marker(
  //           width: 34, height: 34,
  //           markerId: item.content_oid.toString(),
  //           markerImageSrc: URL_MakerMap,
  //           latLng: LatLng( item.longitude, item.latitude,),
  //         )
  //     );
  //   }
  // }

  // Future <bool> onWillPop() async {
  //   return false;
  // }
}
