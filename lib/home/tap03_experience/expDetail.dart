// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardKakaoMap.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/zPhotoViewer.dart';
import 'package:daejeoni/models/infoMap.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class ExpDetail extends StatefulWidget {
  final String title;
  final int content_oid;
  const ExpDetail({
    Key? key,
    required this.content_oid,
    required this.title,
  }) : super(key: key);

  @override
  State<ExpDetail> createState() => _ExpDetailState();
}

class _ExpDetailState extends State<ExpDetail> {
  final GlobalKey _posKeyHome = GlobalKey();
  InfoMap _info = InfoMap();
  late SessionData _session;
  bool _bReady = false;

  double _szRatio = 1.36;
  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    int delay = 300;
    if (Platform.isAndroid) {
      delay = 30;
    }
    Future.delayed(Duration(milliseconds: delay), () async {
      await requestData();
      if(_info.photo_items.isNotEmpty) {
        await calculateImageDimension(_info.photo_items[0].url);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // bool _isInAsyncCall = false;
  // void _showProgress(bool bShow) {
  //   setState(() {
  //     _isInAsyncCall = bShow;
  //   });
  // }

  Future <Size> calculateImageDimension(String imageUrl) {
    bool isOk = true;
    Completer<Size> completer = Completer();
    Image image = Image(
        image: CachedNetworkImageProvider(
            imageUrl,
            errorListener: (){
              if (kDebugMode) {
                print("calculateImageDimension()::Invalid Image url................");
              }
              isOk = false;
            }
        )
    );

    if(isOk) {
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size = Size(
                myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(size);
            _szRatio = size.aspectRatio;
            if (kDebugMode) {
              print("calculateImageDimension()::Image info: ${size.width}X ${size.height} [${size.aspectRatio}]");
            }
          },
        ),
      );
    }
    return completer.future;
  }

  // Future <bool> _onWillPop() async {
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Container(
              color: Colors.grey[100],
              child: CustomScrollView(
                slivers: [
                  _renderSliverAppbar(),
                  _renderHeaderPart(),
                  _renderSpec(),
                  _renderInstMap(),
                ],
              ),
            ),
          ),
        ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    String title = _info.getGroup(); //_info.getPlayName();
    return SliverAppBar(
        key: _posKeyHome,
        floating: true,
        centerTitle: false,
        //pinned: true,
        title: Text(title),
        leading: IconButton(
            icon: Image.asset(
              "assets/icon/top_back.png",
              height: app_top_size_back,
              fit: BoxFit.fitHeight,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () async {
                  Future.delayed(Duration(milliseconds: 300), () async {
                    await requestData();
                    if(_info.photo_items.isNotEmpty) {
                      await calculateImageDimension(_info.photo_items[0].url);
                    }
                    setState(() {});
                  });
                }),
          ),
        ],
        //expandedHeight: 70
    );
  }

  SliverList _renderHeaderPart() {
    double picHeight = (MediaQuery.of(context).size.width-20)/_szRatio;
    String dist = "${(_info.myDstnc * 100).truncate() / 100} Km";
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_info.getGroup(), style: ItemG1N14,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:Text(_info.mapTitle,
                        //textAlign: TextAlign.center,
                        style: ItemBkB18,
                      ),),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.orange,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.amber,
                      ),
                      child: Center(
                        child: Text(dist, style: const TextStyle(fontSize: 12, color: Colors.white),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Visibility(
              visible: _bReady,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. photo
                    Visibility(
                      visible: _info.photo_items.isNotEmpty,
                      child:Container(
                        height: picHeight,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (_info.photo_items.isNotEmpty) ? CardPhotos(
                          fit : BoxFit.fitHeight,
                          items: _info.photo_items,
                          // onZoom: (url) {
                          //   _showZoomPhoto(url);
                          // },
                        ) : Container(),
                      ),
                    ),

                    // 주소
                    Visibility(
                      visible: _info.mapAddr.isNotEmpty,
                      child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 60,
                            child: Text("주소", style: ItemG1N14,),
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/inst/pin.png",
                                        height: 14, fit: BoxFit.fitHeight,),
                                      const SizedBox(width: 5,),
                                      Expanded(child: Text(_info.mapAddr, style: ItemBkN14,))
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(_info.mapDetailAddr,
                                      style: ItemG1N14,),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 10,),
                          /*
                          GestureDetector(
                            onTap: () async {
                              await shareInfo(subject: "", text: _info.link, imagePaths: []);
                            },
                            child: const Icon(
                              Icons.share,
                              size: 20,
                              color: Colors.blueAccent,
                            ),
                          ),
                          */
                        ],
                      ),
                    ),
                    ),

                    // 연락처
                    Visibility(
                      visible: _info.mapTel.isNotEmpty,
                      child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 60,
                            child: Text("연락처", style: ItemG1N14,),
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/inst/call.png", height: 14, fit: BoxFit.fitHeight,),
                                      const SizedBox(width: 5,),
                                      Text(_info.mapTel, style: ItemBkN14,)
                                    ],
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                              width: 60,
                              height: 26,
                              child: ButtonState(
                                  text: "전화걸기",
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                  padding: const EdgeInsets.all(5),
                                  enableColor: Colors.black,
                                  borderColor: Colors.black,
                                  onClick: (){
                                    callPhone(_info.mapTel);
                                  }
                              )
                          ),
                          //SizedBox(width: 10,),
                        ],
                      ),
                    ),
                    )
                  ],
                ),
              )
          ),
        ]));
  }

  SliverList _renderSpec() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: _info.mapCn.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/inst/mark_03.png", height: 16, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 10,),
                        const Text(
                          "상세정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _info.mapCn,
                        maxLines: 20,
                        textAlign: TextAlign.justify,
                        style: ItemBkN14,
                      ),
                    ),
                ],
              ),
            )
          ),
        ])
    );
  }

  SliverList _renderInstMap() {
    final mapHeight = MediaQuery.of(context).size.width * 0.7;
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady ,
            child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/inst/mark_07.png", height: 16, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 10,),
                        const Text(
                          "위치정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: mapHeight,
                      width: double.infinity,
                      child: (_bReady)
                          ? CardKakaoMap(
                        tag:"EXP_DETAIL",
                        title: _info.mapTitle,
                        guestureLock:true,
                        //level: 7,
                        lat: _info.latitude,
                        lon: _info.longitude,)
                          : Container(),
                    ),

                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Image.asset("assets/inst/map.png", height: 40, fit: BoxFit.fitHeight,),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("길찾기", style: ItemBkB14,),
                                    Visibility(
                                      visible: _info.mapAddr.isNotEmpty,
                                      child:Text(_info.mapAddr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ItemG1N12,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              color: Colors.transparent,
                              child: Center(
                                child: Image.asset("assets/inst/pin-1.png", height: 28, fit: BoxFit.fitHeight,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if(await NaviApi.instance.isKakaoNaviInstalled()) {
                          NaviApi.instance.navigate(
                              option: NaviOption(coordType: CoordType.wgs84),
                              destination: Location(name: _info.mapTitle,
                                  y: _info.longitude.toString(),
                                  x: _info.latitude.toString()
                              )
                          );
                        }
                        else {
                          showToastMessage("Kakao 네비게이션이 설치되지 않았습니다.");
                        }
                      },
                    ),

                    const SizedBox(height: 20,),
                  ],
                )),
          )
        ])
    );
  }

  // void _goLink(String url) {
  //   launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  // }

  Future <void> requestData() async {
    //_showProgress(true);
    ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
    await Remote.apiPost(
        context: context,
        session: _session,
        method: "appService/map/detail.do",
        params: {"mapSn":widget.content_oid.toString(), "gpsLcLat": gps.mapY, "gpsLcLng": gps.mapX},
        onError: (String error) {},
        onResult: (dynamic data) async {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }

          var content = data['data'];
          if(content != null) {
            _info = InfoMap.fromJson(content);
          }
        },
    );
    _bReady = true;
    //_showProgress(false);
  }

  void _showZoomPhoto(String url) {
    Navigator.push(
        context,
        Transition(
            child: ZoomPhotoViewer(
              url: url,
            ),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
  }
}

