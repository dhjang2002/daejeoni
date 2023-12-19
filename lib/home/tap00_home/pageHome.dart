// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names
import 'dart:io';
import 'package:daejeoni/common/buttonImage.dart';
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/tap00_home/showCareList.dart';
import 'package:daejeoni/home/tap00_home/showNoticeList.dart';
import 'package:daejeoni/home/tap00_home/showProgramDetail.dart';
import 'package:daejeoni/home/tap00_home/showProgramList.dart';
import 'package:daejeoni/models/itemCare.dart';
import 'package:daejeoni/models/itemNotice.dart';
import 'package:daejeoni/models/itemProgram.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class PageHome extends StatefulWidget {
  final Function() onDrawer;
  final Function() onNotice;
  final Function() onSignin;
  final Function(int page) onPage;
  const PageHome({Key? key,
    required this.onDrawer,
    required this.onNotice,
    required this.onSignin,
    required this.onPage,
  }) : super(key: key);
  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final GlobalKey _posKeyHome = GlobalKey();

  //final _MaxSpaceCount   = 5;
  final _MaxProgramCount = 5;
  final _MaxCareCount = 5;
  final _MaxNoticeCount  = 3;

  // 메인 목록
  List<ItemProgram>    _programList = [];
  List<ItemCare>       _careList = [];
  //List<ItemSpace>      _spaceList = [];
  List<ItemNotice>     _noticeList = [];

  late SessionData _session;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 50;
    }

    Future.delayed(Duration(milliseconds: delay), () async {
      await reqSymmary(context, _session);
      await _reqProgram();
      await _reqCare();
      //await _reqSpace();
      await _reqNotice();
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      opacity: 0.0,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height-60,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      _renderSliverAppbar(),
                      _renderWellcomeUser(),
                      _renderWellcomeUnknown(),
                      _renderNavigator(),
                      _renderProgram(),
                      _renderCare(),
                      //_renderSpace(),
                      _renderNotice(),
                    ],
                  ),
                ),
              )
          ),
          Positioned(
              bottom: 30, right: 5,
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
              )
          ),
        ],
      ),
    );
  }

  SliverList _renderNavigator() {
    const double gap = 20*2;
    final double b1_width  = (MediaQuery.of(context).size.width-gap);//b1_height*1107/378; //
    final double b1_height = b1_width*0.4;//378/1107;

    final double b2_width  = b1_width;
    final double b2_height = b1_width*378/1107;

    final double n2_width  = b2_width/2-5;
    final double n2_height = n2_width*408/507;
    //final double b2_height = MediaQuery.of(context).size.width*0.45;
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE68F52),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:10),
                  child: const Text("돌봄 MAP", style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5
                  ),),
                ),
                // 397 X 83
                Container(
                  margin: const EdgeInsets.only(top:10),
                  height: b1_height,
                  width: b1_width,
                  color: Colors.transparent,
                  child: Center(
                    child: SizedBox(
                      width: b2_width,
                      height: b2_height,
                      //color: Colors.amber,
                      child: ButtonImage(
                        borderColor:Colors.transparent,
                        path: 'assets/images/banner01.png',
                        onClick: () {
                          widget.onPage(1);
                        },
                      ),
                    ),
                  ),
                ),

                // 537 X 408
                Container(
                  margin: EdgeInsets.only(top:0),
                  height: n2_height,
                  child: Row(
                    children: [
                      //const Spacer(),
                      SizedBox(
                        width:n2_width,
                        child: ButtonImage(
                          borderColor:Colors.transparent,
                          path: 'assets/images/banner02.png',
                          onClick: () {
                            widget.onPage(2);
                          },
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width:n2_width,
                        child: ButtonImage(
                          borderColor:Colors.transparent,
                          path: 'assets/images/banner03.png',
                          onClick: () {
                            widget.onPage(3);
                            //_showProgramMore();
                          },
                        ),
                      ),
                      //const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ])
    );
  }

  SliverList _renderWellcomeUser() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _session.isSigned(),
              child: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(_session.infoMember!.mberNm, style: ItemGrTitle),
                    const Text("님, 환영합니다.", style: ItemBkN20,),
                  ],
                ),
                const SizedBox(height: 5,),
                const Row(
                  children: [
                    Text("어떤 서비스를 찾으시나요?", style: ItemBkN20,),
                  ],
                ),
              ],
            ),
          )
          )
        ]));
  }

  SliverList _renderWellcomeUnknown() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
              visible: !_session.isSigned(),
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Text("환영합니다.", style: ItemGrTitle),
                        //const Text("님, 환영합니다.", style: ItemBkN20,),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text("로그인해주세요.", style: ItemBkN20,),
                      ],
                    ),
                  ],
                ),
              )
          )
        ]));
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
          // 새로고침
          Visibility(
            visible: false,
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
                onPressed: () async {
                  await reqSymmary(context, _session);
                  await _reqProgram();
                  await _reqCare();
                  //await _reqSpace();
                  await _reqNotice();
                }),
          ),

          // 알림
          Visibility(
            visible: true,
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
        expandedHeight: 70
    );
  }

  SliverList _renderNotice() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            padding: const EdgeInsets.fromLTRB(10,10,10,50),
            width: double.infinity,
            color: ColorG6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/icon/fest_icon.png",
                        height: 24, fit: BoxFit.fitHeight,
                      ),

                      const SizedBox(width: 10,),
                      const Text("대전아이의 다양한 소식", style: ItemBkB18,),
                      const Spacer(),
                      Visibility(
                        visible: _noticeList.length>_MaxNoticeCount,
                          child: SizedBox(
                            width: 60,
                            height: 26,
                            child: ButtonState(
                                text: "전체소식",
                                textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                padding: const EdgeInsets.all(5),
                                enableColor: Colors.black,
                                borderColor: Colors.black,
                                onClick: (){
                                  _showNoticeMore();
                                }),
                          ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (_noticeList.length>_MaxNoticeCount) ? _MaxNoticeCount:_noticeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemNotice(_noticeList[index]);
                  },
                ),
                Visibility(
                  visible: _noticeList.isEmpty,
                  child: const SizedBox(height: 50,),
                )
              ],
            ),
          )
        ]));
  }

  Widget _itemNotice(ItemNotice item) {
    final span=TextSpan(text:item.boardCn);
    final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 1,
        //     offset: const Offset(0, 0.5), // changes position of shadow
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _doShowNoticeDetail(item);
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(item.regDt.substring(0,10), style: ItemG1N12,),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.boardSj, style: ItemBkB14, maxLines: 3,
                          textAlign:TextAlign.justify,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Text(item.regDt.substring(0,10), style: ItemG1N14,),
                      // ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,0),
                    child: Text(
                        item.boardCn,
                        style: ItemBkN15, maxLines: (item.showMore) ? 44 : 3,
                        textAlign:TextAlign.justify,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
              visible: false,//tp.didExceedMaxLines,
              child:GestureDetector(
                  onTap: () {
                    setState(() {
                      item.showMore = !item.showMore;
                    });
                  },
                  child:Container(
                      alignment: Alignment.center,
                      child:Icon((!item.showMore) ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                  )
              )
          ),
        ],
      ),
    );
  }
  void _showNoticeMore() {
    Navigator.push(
      context,
      Transition(
          child: const ShowNoticeList(
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doShowNoticeDetail(ItemNotice info) async {
    String url = getUrlParam(
      website: '$SERVER/appService/notice_info.do',
      data: {
        //"returnUrl":targetUrl,
        "jwtToken":_session.AccessToken,
        "boardSn": info.boardSn
      },
    );

    await Navigator.push(
      context,
      Transition(
          child: WebExplorer(title: "상세보기", url: url,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  final PageController _programPageController = PageController();
  final _programPageNotifier = ValueNotifier<int>(0);
  SliverList _renderProgram() {
    double szHeight =  MediaQuery.of(context).size.width*0.89;
    if((_programList.isEmpty)) {
      szHeight = szHeight / 2 ;
    }
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icon/fest_icon.png",
                      height: 24, fit: BoxFit.fitHeight,
                    ),

                    const SizedBox(width: 10,),
                    const Text("아이와 함께하는 문화/행사", style: ItemBkB18,),
                    const Spacer(),
                    Visibility(
                        visible: _programList.length>_MaxProgramCount,
                        child: SizedBox(
                            width: 60,
                            height: 26,
                            child: ButtonState(
                              text: "전체행사",
                              textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                              padding: const EdgeInsets.all(5),
                              enableColor: Colors.black,
                              borderColor: Colors.black,
                              onClick: (){
                                _showProgramMore();
                              }
                          )
                        ),
                    )
                  ],
                ),
                //const Divider(height: 1,),
                const SizedBox(height: 20,),
                SizedBox(
                  height: szHeight,
                  child: Stack(
                    children: [
                      Positioned(
                          child: PageView.builder(
                              controller: _programPageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _programPageNotifier.value = index;
                                });
                              },
                              itemCount: (_programList.length>_MaxProgramCount) ? _MaxProgramCount:_programList.length,
                              itemBuilder: (context, index) {
                                return _itemCardProgramTile(_programList[index]);
                              }
                          ),
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Visibility(
                          visible: _programList.length>1,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0,10,0,10),
                            color: Colors.white,
                            child: CirclePageIndicator(
                              size: 10,
                              selectedSize: 12,
                              itemCount: (_programList.length>_MaxProgramCount) ? _MaxProgramCount:_programList.length,
                              dotColor: Colors.grey,
                              selectedDotColor: Colors.green,
                              currentPageNotifier: _programPageNotifier,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Widget _itemCardProgramTile(ItemProgram item) {
    final imageHeight = MediaQuery.of(context).size.width*0.72;
    String dist = "정보없음";
    if(item.myDstnc>=0.0) {
      dist = "${(item.myDstnc * 100).truncate() / 100} Km";
    }
    return GestureDetector(
        onTap: () {
          _doShowProgramDetail(item);
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                      height: imageHeight*0.9,
                      child: CardPhoto(
                        photoUrl: item.image_url,
                        fit: BoxFit.contain,
                      )

                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    color: Colors.white,
                    child: SingleChildScrollView(
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
                            item.title(),
                            style: const TextStyle(
                              fontSize: 15,
                              letterSpacing: -1.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: item.subTitle().length>2,
                            child: Text(
                            "(${item.subTitle()})",
                            style: const TextStyle(
                              fontSize: 14,
                              letterSpacing: -1.5,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),),

                          const Divider(height: 10,),
                          Text("주최기관 : ${item.openInstt}", style: ItemBkN14,),
                          const SizedBox(height: 10,),
                          Text("참가비용 : ${item.partcptCt}", style: ItemBkN14,),
                          const SizedBox(height: 10,),
                          Text("신청기간 : ${item.rcptBgngDt.substring(0,10).replaceAll("-", ".")}\n\t~ ${item.rcptEndDt.substring(0,10).replaceAll("-", ".")}",
                            style: ItemBkN14,),
                          const SizedBox(height: 10,),
                          Text("행사기간 : ${item.eduBgngDt.substring(0,10).replaceAll("-", ".")}\n\t~ ${item.eduEndDt.substring(0,10).replaceAll("-", ".")}",
                            style: ItemBkN14,),

                          Visibility(
                            visible: item.validateMessage.isNotEmpty,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(item.validateMessage, style: ItemG1N12,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }

  void _showProgramMore() {
    Navigator.push(
      context,
      Transition(
          child: const ShowProgramList(
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
  Future<void> _doShowProgramDetail(ItemProgram item) async {
    Navigator.push(
      context,
      Transition(
          child: ShowProgramDetail(
            item: item,
            eduSn:item.eduSn,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  final PageController _carePageController = PageController();
  final _carePageNotifier = ValueNotifier<int>(0);

  SliverList _renderCare() {
    double szHeight = MediaQuery.of(context).size.width*0.9;
    if((_careList.isEmpty)) {
      szHeight = szHeight / 2 ;
    }
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icon/fest_icon.png",
                      height: 24, fit: BoxFit.fitHeight,
                    ),

                    const SizedBox(width: 10,),
                    const Text("양육정보", style: ItemBkB18,),
                    const Spacer(),
                    Visibility(
                        visible: _careList.length>_MaxCareCount,
                        child: SizedBox(
                            width: 60,
                            height: 26,
                            child: ButtonState(
                                text: "모든정보",
                                textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                                padding: const EdgeInsets.all(5),
                                enableColor: Colors.black,
                                borderColor: Colors.black,
                                onClick: (){
                                  _showCareMore();
                                }
                            )
                        ),
                    )
                  ],
                ),
                //const Divider(height: 1,),
                const SizedBox(height: 20,),
                SizedBox(
                  height: szHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        child: PageView.builder(
                            controller: _carePageController,
                            onPageChanged: (index) {
                              setState(() {
                                _carePageNotifier.value = index;
                              });
                            },
                            itemCount: (_careList.length>_MaxCareCount) ? _MaxCareCount:_careList.length,
                            itemBuilder: (context, index) {
                              return _itemCardCareTile(_careList[index]);
                            }
                        ),
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Visibility(
                          visible: _careList.length>1,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(0,10,0,10),
                            color: Colors.white,
                            child: CirclePageIndicator(
                              size: 10,
                              selectedSize: 12,
                              itemCount: (_careList.length>_MaxCareCount) ? _MaxCareCount:_careList.length,
                              dotColor: Colors.grey,
                              selectedDotColor: Colors.green,
                              currentPageNotifier: _carePageNotifier,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Widget _itemCardCareTile(ItemCare item) {
    final double imageHeight = MediaQuery.of(context).size.width*0.88*4/6;
    return GestureDetector(
      onTap: () {
        _doShowCareDetail(item);
      },
      child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                child: CardPhoto(
                  photoUrl: item.image_url,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.boardSj,
                              maxLines:2,
                              overflow: TextOverflow.ellipsis,
                              style: ItemBkB15,),
                            Text(item.regDt,
                              maxLines:1,
                              overflow: TextOverflow.ellipsis,
                              style: ItemBkN14,),
                            // const SizedBox(height: 5,),
                            // Text("공간면적: ${item.spceAr}, 수용인원: ${item.spcePerson}, 연략처: ${item.spceTelno}",
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 2,
                            //   style: ItemBkN14,),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  void _showCareMore() {
    Navigator.push(
      context,
      Transition(
          child: const ShowCareList(
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
  Future<void> _doShowCareDetail(ItemCare item) async {
    String url = getUrlParam(
      website: '$SERVER/appService/talk_info.do',
      data: {
        "jwtToken":_session.AccessToken,
        "boardSn": item.boardSn
      },
    );

    if (Platform.isAndroid) {
      launchUrl(
          Uri.parse(url),
          webViewConfiguration: const WebViewConfiguration(
              headers: {'User Agent': USER_AGENT}
            //headers: {'userAgent': USER_AGENT}

          ),
          //mode: LaunchMode.inAppWebView
          mode: LaunchMode.externalApplication
      );
    }
    else {
      Navigator.push(
        context,
        Transition(
            child: WebExplorer(title: "상세보기", url: url,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      );
    }
  }

  // 프로그램 데이터
  Future<void> _reqProgram() async {
    _showProgress(true);
    await Remote.apiPost(
        timeOut: 3,
        context: context,
        session: _session,
        method: "appService/parnts/edu_list.do",
        params: {"page" : 1,
          "countPerPage": _MaxProgramCount+1,
          "orderBy":"MAPDATE"
        },
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200")
          {
            var value = data['data'];
            //var pagination = value['pagination'];
            var content = value['list'];
            if(content!=null) {
              _programList = ItemProgram.fromSnapshot(content);
            } else {
              _programList = [];
            }
          }
        },
        onError: (String error) {}
    );
    _showProgress(false);
  }

  // 양육정보
  Future<void> _reqCare() async {
    _showProgress(true);
    await Remote.apiPost(
        timeOut: 3,
        context: context,
        session: _session,
        method: "appService/board/list.do",
        params: {"page" : 1,
          "countPerPage": _MaxCareCount+1,
          "board_id": "board011", "ctgryCd": "",
          "orderBy":"MAPDATE"
        },
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200")
          {
            var value = data['data'];
            //var pagination = value['pagination'];
            var content = value['list'];
            if(content!=null) {
              _careList = ItemCare.fromSnapshot(content);
            } else {
              _careList = [];
            }
          }
        },
        onError: (String error) {}
    );
    _showProgress(false);
  }

  // 프로그램 데이터
  Future<void> _reqNotice() async {
    _showProgress(true);
    await Remote.apiPost(
        timeOut: 3,
        context: context,
        session: _session,
        method: "appService/board/list.do",
        params: { "page" : 1, "countPerPage": _MaxNoticeCount+1, "board_id": "board001" },
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200")
          {
            var value = data['data'];
            //var pagination = value['pagination'];
            var content = value['list'];
            if(content!=null) {
              _noticeList = ItemNotice.fromSnapshot(content);
            } else {
              _noticeList = [];
            }
          }
        },
        onError: (String error) {}
    );
    _showProgress(false);
  }
}
