// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardKakaoMap.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/models/infoSos.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SosDetail extends StatefulWidget {
  final String title;
  final int content_oid;
  const SosDetail({
    Key? key,
    required this.content_oid,
    required this.title,
  }) : super(key: key);

  @override
  State<SosDetail> createState() => _SosDetailState();
}

class _SosDetailState extends State<SosDetail> {
  final GlobalKey _posKeyHome = GlobalKey();
  InfoSos _info = InfoSos();
  late SessionData _session;
  bool _bReady = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    int delay = 300;
    if (Platform.isAndroid) {
      delay = 30;
    }
    Future.delayed(Duration(milliseconds: delay), () async {
      await requestData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isInAsyncCall = false;
  void _showProgress(bool bShow) {
    setState(() {
      _isInAsyncCall = bShow;
    });
  }

  // Future <bool> _onWillPop() async {
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:_buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[100],
      child: CustomScrollView(
        slivers: [
          _renderSliverAppbar(),
          _renderHeaderPart(),
          _renderMapCtgryCd1(),
          _renderMapCtgryCd2(),
          _renderMapCtgryCd3(),
          _renderInstMap(),
        ],
      ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    String title = _info.title();
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
                  await requestData();
                }),
          ),
        ],
        //expandedHeight: 70
    );
  }

  SliverList _renderHeaderPart() {
    final double picHeight = MediaQuery.of(context).size.width * 0.8;
    String dist = "${(_info.myDstnc * 100).truncate() / 100} Km";
    String info = "야간진료";
    String imageUrl = "";
    if(_info.mapCtgryCd=="1") {
      imageUrl = IMG_SOS01;
    } else if(_info.mapCtgryCd=="2") {
      imageUrl = IMG_SOS02;
    } else {
      imageUrl = IMG_SOS03;
    }
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("[ ${_info.getGroup()} ]", style: ItemBkN14,),
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
                ),

                const SizedBox(height: 5,),
                Visibility(
                  visible: _bReady && _info.mapCtgryCd=="1" && _info.isHsNightOp(),
                  child: Container(
                  //margin: const EdgeInsets.only(left: 10),
                  width:80,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.pink,
                    ),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.pink,
                  ),
                  child: Center(
                    child: Text(info, style: const TextStyle(fontSize: 12, color: Colors.white),),
                  ),
                ),),

                Visibility(
                  visible: _bReady && _info.mapCtgryCd=="2",
                  child: Row(
                    children: [
                      Visibility(
                          visible:_info.isPhNight(),
                          child: Container(
                        width:80,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.green,
                        ),
                        child: const Center(
                          child: Text("야간영업",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      )
                      ),
                      Visibility(
                          visible:_info.isPhHolyday(),
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            width:80,
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.pink,
                              ),
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.pink,
                            ),
                            child: const Center(
                              child: Text("휴일영업",
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
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
                      visible: imageUrl.isNotEmpty,
                      child:Container(
                        height: picHeight,
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (imageUrl.isNotEmpty)
                            ? Image.asset(
                                imageUrl,
                                fit : BoxFit.fill)
                            : Container(),
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
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                    ),
                  ],
                ),
              )
          ),
        ]));
  }

  // 병원
  SliverList _renderMapCtgryCd1() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _info.mapCtgryCd=="1",
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
                          "병원정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    _itemRow(true, 1, "병원종류:", _info.clCdNm, false),
                    _itemRow(true, 1, "개설일자:", _info.estbDd, false),
                    _itemRow(!_info.isHsNightOp(),1, "의사 총 인원수:", _info.drTotCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "의과 일반의 인원수:", _info.mdeptGdrCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "의과 인턴 인원수:", _info.mdeptIntnCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "의과 레지던트 인원수:", _info.mdeptResdntCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "의과 전문의 인원수:", _info.mdeptSdrCnt, false),

                    _itemRow(!_info.isHsNightOp(),1, "치과 일반의 인원수:", _info.detyGdrCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "치과 인턴 인원수:", _info.detyIntnCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "치과 레지던트 인원수:", _info.detyResdntCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "치과 전문의 인원수:", _info.detySdrCnt, false),

                    _itemRow(!_info.isHsNightOp(),1, "한방 일반의 인원수:", _info.cmdcGdrCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "한방 인턴 인원수:", _info.cmdcIntnCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "한방 레지던트 인원수:", _info.cmdcResdntCnt, false),
                    _itemRow(!_info.isHsNightOp(),1, "한방 전문의 인원수:", _info.cmdcSdrCnt, false),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
            )
          ),
        ])
    );
  }

  // 약국
  SliverList _renderMapCtgryCd2() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: _info.mapCtgryCd=="2",
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
                          "약국정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    _itemRow(true, 1, "월요일 근무시간:", "${_info.dutyTime1s} ~ ${_info.dutyTime1c}", false),
                    _itemRow(true,1, "화요일 근무시간:", "${_info.dutyTime2s} ~ ${_info.dutyTime2c}", false),
                    _itemRow(true,1, "수요일 근무시간:", "${_info.dutyTime3s} ~ ${_info.dutyTime3c}", false),
                    _itemRow(true,1, "목요일 근무시간:", "${_info.dutyTime4s} ~ ${_info.dutyTime4c}", false),
                    _itemRow(true,1, "금요일 근무시간:", "${_info.dutyTime5s} ~ ${_info.dutyTime5c}", false),
                    _itemRow(true,1, "토요일 근무시간:", "${_info.dutyTime6s} ~ ${_info.dutyTime6c}", false),
                    _itemRow(true,1, "일요일 근무시간:", "${_info.dutyTime7s} ~ ${_info.dutyTime7c}", false),
                    _itemRow(true,1, "휴무일 근무시간:", "${_info.dutyTime8s} ~ ${_info.dutyTime8c}", false),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
          ),
        ])
    );
  }

  // 기관
  SliverList _renderMapCtgryCd3() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: _info.mapCtgryCd=="3",
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
                          "기관정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Text(_info.mapCn),
                    const SizedBox(
                      height: 20,
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
                        tag:"SOS_DETAIL",
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

  void _goLink(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _itemRow(bool show, int maxLines, String label, String value, bool bLink) {
    return Visibility(
        visible: show,
        child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150,
                child: Text(label,
                  style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color: Colors.grey,
                  ),
                )
            ),
            Expanded(
              child:GestureDetector(
                  onTap: () {
                    if(bLink && value.isNotEmpty) {
                      _goLink(value);
                    }
                  },
                  child: Container(
                      color: Colors.transparent,
                      child:Text(value,
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          style:TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -1.3,
                            height: 1.2,
                            color: (!bLink && value.isNotEmpty) ? Colors.black : Colors.blueAccent,
                          )
                      )
                  )
              ),
            ),
          ],
        )
    )
    );
  }

  Future <void> requestData() async {
    _showProgress(true);
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
            _info = InfoSos.fromJson(content);
          }
        },
    );
    _bReady = true;
    _showProgress(false);
  }
}

