
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:daejeoni/common/CardFacility.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardKakaoMap.dart';
import 'package:daejeoni/common/cardTabbar.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/tap01_inst/instGalleryDetail.dart';
import 'package:daejeoni/home/tap01_inst/instGalleryView.dart';
import 'package:daejeoni/home/tap01_inst/instNoticeDetail.dart';
import 'package:daejeoni/home/tap01_inst/instNoticeView.dart';
import 'package:daejeoni/home/tap01_inst/popWritePost.dart';
import 'package:daejeoni/home/tap01_inst/instPostView.dart';
import 'package:daejeoni/home/tap01_inst/instSurveyView.dart';
import 'package:daejeoni/models/ItemPost.dart';
import 'package:daejeoni/models/infoInst.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/models/itemInstGallery.dart';
import 'package:daejeoni/models/itemInstNotice.dart';
import 'package:daejeoni/models/itemInstSurvey.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:logger/logger.dart';
import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class InstDetailView extends StatefulWidget {
  final String title;
  final String insttSn;
  const InstDetailView({
    Key? key,
    required this.insttSn,
    required this.title,
  }) : super(key: key);

  @override
  State<InstDetailView> createState() => _InstDetailViewState();
}

class _InstDetailViewState extends State<InstDetailView> {
  final GlobalKey _posKeyHome = GlobalKey();
  InfoInst _info = InfoInst();
  List<ItemPost> _postList = [];
  List<ItemInstNotice>  _noticeList = [];
  List<ItemInstGallery> _galleryList = [];
  List<ItemInstSurvey>  _surveyList = [];

  final List<TabbarItem> _boardTabitems = [
    TabbarItem(name: "공지사항", tag: "0"),
    TabbarItem(name: "갤러리", tag: "1"),
    TabbarItem(name: "설문조사", tag: "2"),
  ];
  int _tabIndex = 0;
  // final List<MenuButtonRadioItem> _boardItems = [
  //   MenuButtonRadioItem(text:"공지사항", id:"0", select: true),
  //   MenuButtonRadioItem(text:"갤러리", id:"1"),
  //   MenuButtonRadioItem(text:"설문조사", id:"2"),
  // ];

  String _boardSelect = "0";
  bool _bReady = false;
  late SessionData _session;

  double _szRatio = 1.36;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    int delay = 300;
    if (Platform.isAndroid) {
      delay = 30;
    }
    Future.delayed(Duration(milliseconds: delay), () async {
      await _reload();
    });
    super.initState();
  }

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

  Future <void> _reload() async {
    await _reqInfo();
    if(_info.photo_sub_items.isNotEmpty) {
      await calculateImageDimension(_info.photo_sub_items[0].url);
    }

    if(_bReady) {
      if (!_info.isLinkOnly()) {
        await _reqBoardData();
        await _reqPost();
      }
    }
  }

  Future <void> _reqBoardData() async {
    if(_boardSelect=="0") {
      await _reqNotice();
    } else if(_boardSelect=="1") {
      await _reqGallery();
    } else if(_boardSelect=="2") {
      await _reqSurvey();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _bWaiting = false;
  void _showProgress(bool bShow) {
    setState(() {
      _bWaiting = bShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                      color: _info.isLinkOnly() ? Colors.white : Colors.grey[100],
                      child: CustomScrollView(
                        slivers: [
                          _renderSliverAppbar(),
                          _renderHeaderPart(),
                          _renderInstOverview(),
                          _renderInstSpace(),
                          _renderInstInfo(),
                          _renderInstEtc(),
                          _renderInstProgram(),
                          _renderInstMap(),
                          _renderBoard(),
                          _renderInstPost(),
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
                        visible: !_bReady,
                        child: Container(
                          margin: const EdgeInsets.only(top:80),
                          //color: Colors.white,
                          //color: const Color(0x0f000000),
                          child: const Center(
                              child: Text("서버에서 응답이 없습니다.")
                          ),
                        )
                    )
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                        visible: _bReady,
                        child: Container(
                          //padding: const EdgeInsets.fromLTRB(50, 10, 50, 5),
                          margin: EdgeInsets.only(top:10, bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: Colors.white,
                          child: SizedBox(
                            //width: 120,
                            height: 48,
                            child: ButtonState(
                              borderColor: (_info.isLinkOnly()) ? Colors.amber : Colors.pink,
                              enableColor: (_info.isLinkOnly()) ? Colors.amber : Colors.pink,
                              textStyle: TextStyle(
                                  color: (_info.isLinkOnly()) ? Colors.black : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                              text: (_info.isLinkOnly()) ? '홈페이지 바로가기' : '예약현황 및 신청',
                              onClick: () {
                                _goReserveAndView();
                              },
                            ),
                          ),
                        )
                    )
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                        visible: _bWaiting,
                        child: Container(
                          color: const Color(0x1f000000),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                    )
                ),
              ],
            ),
          ),
        )
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
        key: _posKeyHome,
        floating: true,
        centerTitle: true,
        //pinned: true,
        title: const Text("돌봄기관 상세정보"),
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
            visible: _bReady,
            child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () async {
                  await _reload();
                }),
          ),
        ],
        //expandedHeight: 60
    );
  }

  SliverList _renderBoard() {
    final double borderHeight = MediaQuery.of(context).size.height*0.5;
    final gallery_image_width = MediaQuery.of(context).size.width/3.5;
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && !_info.isLinkOnly(),
            child: Container(
              height: borderHeight,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
                child: Column(
                  children: [
                    Container(
                    padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:Center(child: CardTabbar(
                        items: _boardTabitems,
                        index: _tabIndex,
                        onChange: (index, item) async {
                          setState(() {
                            _tabIndex = index;
                            _boardSelect = item.tag;
                          });
                          await _reqBoardData();
                        },
                      ),),
                    ),
                    Expanded(
                        child: Container(
                          padding:const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Visibility(
                                    visible:_boardSelect=="0",
                                    child: InstNoticeView(items: _noticeList,
                                      onClick: (ItemInstNotice item) {
                                        _showNotice(item);
                                      },),
                                )
                              ),

                              Positioned(
                                  child: Visibility(
                                    visible:_boardSelect=="1",
                                    child: InstGalleryView(
                                      imageWidth: gallery_image_width,
                                      items: _galleryList,
                                      onClick: (ItemInstGallery item) {
                                        _showGallery(item);
                                      },),
                                  )
                              ),

                              Positioned(
                                  child: Visibility(
                                    visible:_boardSelect=="2",
                                    child: SurveyView(items: _surveyList,
                                      onSurvey: (ItemInstSurvey item) {
                                        _doSurvey(item);
                                      },
                                    ),
                                  )
                              ),
                            ],
                          ),
                    )),
                  ],
                ),
              ),
          )
        ])
    );
  }

  SliverList _renderHeaderPart() {
    double picHeight = (MediaQuery.of(context).size.width-20)/_szRatio;
    //final double picHeight = MediaQuery.of(context).size.width * 0.64;
    String dist = "${(_info.myDstnc * 100).truncate() / 100} Km";
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_info.getHiName(), style: ItemG1N14,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:Text(_info.insttNm,
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
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. photo
                    Visibility(
                      visible: _info.photo_sub_items.isNotEmpty,
                      child:Container(
                        height: picHeight,
                        width: double.infinity,
                        //margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: (_info.photo_sub_items.isNotEmpty)
                            ? CardPhotos(
                                fit : BoxFit.fill,
                                items: _info.photo_sub_items,)
                            : Container(),
                      ),
                    ),

                    // 주소
                    Container(
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
                                      Expanded(child: Text(_info.insttAdres, style: ItemBkN14,))
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(_info.insttAdresDetail, 
                                      style: ItemG1N14,),
                                  )
                                ],
                            )
                          ),
                          const SizedBox(width: 10,),
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
                        ],
                      ),
                    ),

                    // 연락처
                    Visibility(
                      visible: _info.insttCoTelno.isNotEmpty,
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
                                        Text(_info.insttCoTelno, style: ItemBkN14,)
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
                                      callPhone(_info.insttCoTelno);
                                    }
                                )
                            ),
                            //SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),

                    // 평점
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 60,
                            child: Text("평점", style: ItemG1N14,),
                          ),
                          RatingBarIndicator(
                            rating: _info.grade,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 18.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 10,),
                          Text("${_info.grade}", style: ItemBkB14,),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        ]));
  }

  SliverList _renderInstOverview() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && _info.insttDc.isNotEmpty,
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
                    Image.asset("assets/inst/mark_01.png", height: 16, fit: BoxFit.fitHeight,),
                    const SizedBox(width: 10,),
                    const Text(
                      "기관소개",
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
                    _info.insttDc,
                    maxLines: 20,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          ),
        ])
    );
  }

  SliverList _renderInstSpace() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && _info.insttSpce.isNotEmpty,
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
                    Image.asset("assets/inst/mark_02.png", width: 14, fit: BoxFit.fitWidth,),
                    const SizedBox(width: 10,),
                    const Text(
                      "공간현황",
                      style: ItemBkB18,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CardFacility(dataString: _info.insttSpce,),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          )
        ])
    );
  }

  SliverList _renderInstInfo() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && !_info.isLinkOnly(),
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
                        Image.asset("assets/inst/mark_03.png", width: 14, fit: BoxFit.fitWidth,),
                        const SizedBox(width: 10,),
                        const Text(
                          "기관정보",
                          style: ItemBkB18,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _itemRow(3, "이용대상", _info.insttAge, false),
                    _itemRow(3, "자격요건", _info.insttRqisit, false),
                    _itemRow(3, "이용시간", "학기중 : ${_info.insttTime1}"
                        "\n방학중 : ${_info.insttTime2}"
                        "\n휴무일 : ${_info.insttTime3}\n", false),
                    _itemRow(3, "이용방법", _info.useType(), false),
                    _itemRow(3, "돌봄유형", _info.careType(), false),
                    _itemRow(3, "이용료", _info.insttChrge, false),
                    _itemRow(3, "급-간식\n유무", "급식 : ${_info.insttMlsv}"
                        "\n간식 : ${_info.insttSnsv}", false),
                    _itemRow(3, "셔틀유무", (_info.insttShuttle=="Y") ? "유" : "무", false),
                    const SizedBox(
                      height: 50,
                    ),

                    Row(
                      children: [
                        Image.asset("assets/inst/mark_04.png", width: 14, fit: BoxFit.fitWidth,),
                        const SizedBox(width: 10,),
                        const Text(
                          "이용정원",
                          style: ItemBkB18,
                        ),
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      color: Colors.grey,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        child: Row(
                          children: [
                            Expanded(
                              flex:2,
                                child: Container(
                                  margin:const EdgeInsets.only(right: 1),
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xFFF3F3F3),
                                  child: const Center(child: Text("상시", style: ItemG1N14,),),
                                )
                            ),
                            Expanded(
                              flex:3,
                                child: Container(
                                  margin:const EdgeInsets.only(right: 1),
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Center(child: Text(_info.insttTotalPsn, style: ItemBkN14,),),
                                )
                            ),
                            Expanded(
                              flex:2,
                                child: Container(
                                  margin:const EdgeInsets.only(right: 1),
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xFFF3F3F3),
                                  child: const Center(child: Text("일시", style: ItemG1N14,),),
                                )
                            ),
                            Expanded(
                                flex:3,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Center(child: Text(_info.insttTempPsn, style: ItemBkN14,),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
          )
        ])
    );
  }

  SliverList _renderInstEtc() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && _info.infoEtc().isNotEmpty,
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
                      Image.asset("assets/inst/mark_05.png", width: 14, fit: BoxFit.fitWidth,),
                      const SizedBox(width: 10,),
                      const Text(
                        "기타정보",
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
                      _info.infoEtc(),
                      maxLines: 20,
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ])
    );
  }

  SliverList _renderInstProgram() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && !_info.isLinkOnly(),
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
                      Image.asset("assets/inst/mark_06.png", width: 14, fit: BoxFit.fitWidth,),
                      const SizedBox(width: 10,),
                      const Text(
                        "프로그램",
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
                      _info.insttProgrm,
                      //maxLines: 20,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ])
    );
  }

  SliverList _renderInstMap() {
    final mapHeight = MediaQuery.of(context).size.width * 0.7;
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && !_info.isLinkOnly(),
            child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            "기관위치",
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
                                tag: "INST_DETAIL",
                                title: _info.insttNm,
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
                                      const Text("기관 길찾기", style: ItemBkB14,),
                                      Visibility(
                                        visible: _info.insttAdres.isNotEmpty,
                                        child: Text(_info.insttAdres,
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
                                destination: Location(name: _info.insttNm,
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

  SliverList _renderInstPost() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _bReady && !_info.isLinkOnly(),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              padding: const EdgeInsets.fromLTRB(10,10,10,50),
              color: Colors.white,
                child:Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: Row(
                        children: [
                          Image.asset("assets/inst/mark_08.png", width: 14, fit: BoxFit.fitWidth,),
                          const SizedBox(width: 10,),
                          const Text(
                            "이용후기",
                            style: ItemBkB18,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            height: 42,
                            child: ButtonState(
                              //padding: EdgeInsets.all(10),
                              borderRadius:20.0,
                              borderColor: Colors.cyan,
                              enableColor: Colors.cyan,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                              text: '후기등록',
                              onClick: () async {
                                if(await ConfirmSigned(context, _session)) {
                                  showWritePost(
                                    context: context,
                                    insttSn: _info.insttSn.toString(),
                                    onResult: (bool bDirty, ItemPost item) async {
                                      if(bDirty) {
                                        showToastMessage("이용후기가 등록되었습니다.");
                                        await _reqPost();
                                        setState(() {});
                                      }
                                    }
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          const Text("총 ", style:ItemBkN16),
                          Text("${_postList.length}", style:ItemBuN16),
                          const Text("건의 이용후기가 있습니다.", style:ItemBkN16),
                        ],
                      ),
                    ),
                    const Divider(thickness: 5,),
                    InstPostView(items: _postList,
                      onDelete: (ItemPost item) async {
                        showYesNoDialogBox(
                            height: 240,
                            context: context,
                            title: "확인",
                            message: "후기를 삭제하시겠습니까?",
                            onResult: (bOK) async {
                              if(bOK) {
                                bool flag = await _delPost(item);
                                if (flag) {
                                  showToastMessage("이용 후기가 삭제되었습니다.");
                                  await _reqPost();
                                  setState(() {});
                                }
                              }
                            });
                      },
                    ),
                  ],
                ),
              ),
          )
        ])
    );
  }

  void _goLink(String url) {

    if (kDebugMode) {
      print(url);
    }

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _itemRow(int maxLines, String label, String value, bool bLink) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 70,
                child: Text(label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -1.5,
                    height: 1.5,
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
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          left: BSG5,
                        ),
                      ),
                      child:Text(value,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          letterSpacing: -1.5,
                          height: 1.5,
                          color: (!bLink && value.isNotEmpty) ? Colors.black : Colors.blueAccent,
                        )
                      ))
              ),
            ),
          ],
        ));
  }

  String _getPublicPanelLayerIdkey() {
    var rng = Random();
    var d = DateTime.now();
    var currentDate = "${d.year}${d.month}${d.day}";
    var currentTime = "${d.hour}${d.minute}${d.second}";
    return "$currentDate${rng.nextInt(10)}$currentTime${rng.nextInt(10)}";
  }

  Future <void> _doSurvey(ItemInstSurvey item) async {
    // http://10.10.10.6:8080/appService/qestnar_write.do?jwtToken=jwt토큰&scrtyKey=PwVf0mo8waDZ5eMF9VryROJgQNXOUzAa+onwuPEZ5Xk=&qustnrSn=QUSTNR_0523LDRN04063197&uniqueKey=2023530010080

    String scrtyKey = item.scrtyKey.replaceAll("+", "%2B");
    String url = getUrlParam(
      website: '$SERVER/appService/qestnar_write.do',
      data: {
        "jwtToken":_session.AccessToken,
        "qustnrSn":item.qustnrSn,
        "scrtyKey":scrtyKey,
        "uniqueKey":_getPublicPanelLayerIdkey(),
      },
    );

    Navigator.push(
      context,
      Transition(
          child: WebExplorer(
            title: "설문조사",
            url: url,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _goReserveAndView() async {
    if(_info.isLinkOnly()) {
      //String linkUrl = "${_info.extrlLinkDomn}/extr-link/view.do?key=${_info.extrlLinkScrtyKey}";
      if(_info.getExtLink().isNotEmpty) {
        _goLink(_info.getExtLink());
      }
    } else {

      if(await ConfirmSigned(context, _session)) {
        String url = getUrlParam(
          website: '$SERVER/appService/instt_attend.do',
          data: {
            "jwtToken": _session.AccessToken,
            "insttSn": _info.insttSn
          },
        );

        Navigator.push(
          context,
          Transition(
              child: WebExplorer(
                title: "돌봄신청",
                url: url,
              ),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
        );
      }
    }
    //  ? '홈페이지 바로가기' : '예약현황 및 신청',
  }

  void _showNotice(ItemInstNotice item) {
    Navigator.push(
      context,
      Transition(
          child: InstNoticeDetail(
            insttSn: _info.insttSn.toString(),
            item: item,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  void _showGallery(ItemInstGallery item) {
    Navigator.push(
      context,
      Transition(
          child: InstGalleryDetail(
            insttSn: _info.insttSn.toString(),
            item: item,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  // { "insttSn": "7", "gpsLcLat": "36.3477465774122", "gpsLcLng": "127.334127593699"}
  Future <void> _reqInfo() async {
    _showProgress(true);
    // gps.mapY, gps.mapX
    ItemFavoriteGps gps = _session.getCurrentFavoriteInfo();
    await Remote.apiPost(
        context: context,
        session: _session,
        method: "appService/instt/detail.do",
        params: {"insttSn":widget.insttSn.toString(), "gpsLcLat": gps.mapY, "gpsLcLng": gps.mapX },
        onError: (String error) {},
        onResult: (dynamic data) async {
          if (kDebugMode) {
            var logger = Logger();
            logger.d(data);
          }
          var content = data['data'];
          if(content != null) {
            _info = InfoInst.fromJson(content);
            // var list = ItemPhoto.fromSnapshot(content['files']);
            // _info.setPhotoList(list);
            _bReady = true;
          }
          // else {
          //   _bReady = false;
          // }
        },
    );
    _bReady = true;
    _showProgress(false);
  }

  Future <bool> _delPost(ItemPost item) async {
    bool rst = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/reply/delete.do",
      params: { "insttReplySn": item.insttReplySn },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }

        if(data['status'].toString() == "200") {
          rst = true;
        }
      },
    );
    return rst;
  }

  Future <void> _reqPost() async {
    _showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/reply/list.do",
      params: {"insttSn":widget.insttSn.toString(), "page":"1", "countPerPage":10 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }

        var content = data['data']['list'];
        if(content != null) {
          _postList = ItemPost.fromSnapshot(content);
          for (var element in _postList) {
            if(element.mberId==_session.UserID) {
              element.isMe = true;
            }
          }
        } else {
          _postList = [];
        }
      },
    );
    _showProgress(false);
  }

  Future <void> _reqNotice() async {
    _showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/notice_list.do",
      params: {"insttSn":widget.insttSn.toString(), "page":"1", "countPerPage":10 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        var content = data['data']['list'];
        if(content != null) {
          _noticeList = ItemInstNotice.fromSnapshot(content);
        } else {
          _noticeList = [];
        }
      },
    );
    _showProgress(false);
  }

  Future <void> _reqGallery() async {
    _showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/gallery_list.do",
      params: {"insttSn":widget.insttSn.toString(), "page":"1", "countPerPage":10 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        var content = data['data']['list'];
        if(content != null) {
          _galleryList = ItemInstGallery.fromSnapshot(content);
        } else {
          _galleryList = [];
        }
      },
    );
    _showProgress(false);
  }

  /*
  { "mberId": "416-80-62450", "page": "1", "countPerPage": "10" }
   */
  Future <void> _reqSurvey() async {
    _showProgress(true);
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/instt/qestnar_list.do",
      params: {"mberId":_info.mberId,"page":"1", "countPerPage":10 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        var content = data['data']['list'];
        if(content != null) {
          _surveyList = ItemInstSurvey.fromSnapshot(content);
        } else {
          _surveyList = [];
        }
      },
    );
    _showProgress(false);
  }


}

