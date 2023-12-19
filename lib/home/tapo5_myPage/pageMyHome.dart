// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:io';

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardFace.dart';
import 'package:daejeoni/common/cardMenuItem.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/home/auth/password.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/tap00_home/showSpaceList.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrActCourse.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrActDeliveryClass.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrActStudy.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrCareCrops.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrChild.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrInstReserveCal.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrRegProgram.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSParent.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSShare.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSpace.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrStampCal.dart';
import 'package:daejeoni/home/tapo5_myPage/popUserInfo.dart';
import 'package:daejeoni/home/website.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/InfoMember.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:daejeoni/models/ItemChild.dart';

class CardTile extends StatelessWidget {
  final String text;
  final String imagePath;
  final Function() onTap;
  const CardTile({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(10,10,0,10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.fitHeight,),
            ),
            const SizedBox(width: 10,),
            Text(text, style: ItemBkN14),
          ],
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}

class PageMyHome extends StatefulWidget {
  final Function() onDrawer;
  final Function() onNotice;
  final Function() onSignin;
  final Function(int page) onPage;
  const PageMyHome({Key? key,
    required this.onDrawer,
    required this.onNotice,
    required this.onSignin,
    required this.onPage,
  }) : super(key: key);

  @override
  State<PageMyHome> createState() => _PageMyHomeState();
}

class _PageMyHomeState extends State<PageMyHome> {
  final GlobalKey _posKeyHome = GlobalKey();

  List<CardMenuItem> child_memu = [];
  /*
  [
    CardMenuItem(tag: "", title: "홍길동(9세)", assetsPath: "assets/mypage/avter_01.png"),
    CardMenuItem(tag: "", title: "홍길순(8세)", assetsPath: "assets/mypage/avter_02.png"),
    CardMenuItem(tag: "", title: "홍길무(7세)", assetsPath: "assets/mypage/avter_03.png"),
    CardMenuItem(tag: "", title: "홍길자(5세)", assetsPath: "assets/mypage/avter_04.png"),
  ];
   */

  final List<CardMenuItem> custom_memu = [
    CardMenuItem(tag: "101", title: "기관예약 신청내역", assetsPath: "assets/mypage/section_01.png"), //CardMenuItem(tag: "102", title: "스탬프 조회하기", assetsPath: "assets/mypage/section_02.png"),
  ];

  final List<CardMenuItem> care_comm_memu = [
    CardMenuItem(tag: "201", title: "손오공돌봄공동체\n신청하기", assetsPath: "assets/mypage/section_03.png"),
    CardMenuItem(tag: "202", title: "손오공돌봄공동체\n신청내역", assetsPath: "assets/mypage/section_04.png"),
    CardMenuItem(tag: "203", title: "공동육아나눔터\n신청하기", assetsPath: "assets/mypage/section_05.png"),
    CardMenuItem(tag: "204", title: "공동육아나눔터\n신청내역", assetsPath: "assets/mypage/section_06.png"),
    CardMenuItem(tag: "205", title: "돌봄봉사단\n신청하기", assetsPath: "assets/mypage/section_07.png"),
    CardMenuItem(tag: "206", title: "돌봄봉사단\n신청내역", assetsPath: "assets/mypage/section_08.png"),
  ];

  List<CardMenuItem> care_act_memu = [
    CardMenuItem(tag: "301", title: "양성과정\n신청하기", assetsPath: "assets/mypage/section_09.png"),
    CardMenuItem(tag: "302", title: "양성과정\n신청내역", assetsPath: "assets/mypage/section_10.png"),
    CardMenuItem(tag: "305", title: "배달강좌 \n신청하기", assetsPath: "assets/mypage/section_11.png"),
    CardMenuItem(tag: "303", title: "배달강좌 이력 및\n일지작성", assetsPath: "assets/mypage/section_11.png"),
    //CardMenuItem(tag: "305", title: "배달강좌 \n신청하기", assetsPath: "assets/mypage/section_11.png"),
    CardMenuItem(tag: "304", title: "돌봄활동가\n마이페이지", assetsPath: "assets/mypage/my_icon03.png"),
  ];

  final List<CardMenuItem> program_memu = [
    CardMenuItem(tag: "001", title: "문화/행사\n신청현황", assetsPath: "assets/mypage/my_icon01.png"),
    CardMenuItem(tag: "002", title: "공간 신청하기", assetsPath: "assets/mypage/my_icon02.png"),
    CardMenuItem(tag: "003", title: "공간 신청현황", assetsPath: "assets/mypage/my_icon03.png"),
  ];

  Future <void> doAction(CardMenuItem item) async {
    print("doAction(${item.tag}) : ${item.title}");

    switch(item.tag) {
      case "001":
        _doMgrProgram();
        break;
      case "002":
        _showSpaceMore();
        break;
      case "003":
        _doMgrSpace();
        break;

      case "101":
        _doMgrInstCal();
        break;
      case "102":
        _doMgrStampCal();
        break;

      case "201":
        doWriteSShare(context, _session);
        break;
      case "202":
        _doMgrSShare();
        break;
      case "203":
        doWriteSParent(context, _session);
        break;
      case "204":
        _doMgrSParent();
        break;
      case "205":
        doWriteCareCrops(context, _session);
        break;
      case "206":
        _doMgrCareCrops();
        break;
      case "301":
        doWriteActCourse(context, _session);
        break;
      case "302":
        _doMgrActCourse();
        break;
      case "303":
        _doMgrActDeliveryClass();
        break;
      case "304":
        doActMyPage(context, _session, true);
        //_doMgrActDeliveryClass();
        break;
      case "305": // 돌봄활동가->배달강좌 신청사기
        doApplyActCourse(context, _session);
        break;
        break;
    }
  }

  void _showSpaceMore() {
    Navigator.push(
      context,
      Transition(
          child: const ShowSpaceList(
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  late SessionData _session;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);

    if(_session.Level=="0") {
      care_act_memu.removeAt(2);
      care_act_memu.removeAt(2);
      care_act_memu.removeAt(2);
    } else {
      care_act_memu.removeAt(0);
      care_act_memu.removeAt(0);
    }

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 50;
    }
    Future.delayed(Duration(milliseconds: delay),() async {
      await _reqData();
    });
    setState(() {});
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.0,
        child: Stack(
          children: [
            Positioned(
                left: 10,
                top: 0,
                right: 10,
                bottom: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Container(
                    //padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    color: Colors.white,
                    child: CustomScrollView(
                      slivers: [
                        _renderSliverAppbar(),
                        _renderUserInfo(),
                        _renderProgramCard(),
                        _renderChildCard(),
                        _renderCustomCard(),
                        _renderCommunityCard(),
                        _renderActivityCard(),
                        _renderSetting(),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
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
          // 새로고침
          Visibility(
            visible: true,
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
                onPressed: () async {
                  await _reqData();
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
          // // 로그인
          // Visibility(
          //   visible: _session.IsSigned != "Y", //(_bSearch && _tabIndex != 0),
          //   child: IconButton(
          //       icon: Image.asset("assets/quick/user.png",
          //         height: 21, fit: BoxFit.fitHeight,
          //       ),
          //       onPressed: () {
          //         setState(() {
          //           widget.onSignin();
          //         });
          //       }),
          // ),
        ],
        //expandedHeight: 70,
    );
  }

  SliverList _renderUserInfo() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Visibility(
            visible: _session.IsSigned == "Y",
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                padding: const EdgeInsets.only(bottom:5, top:15),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(10),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.grey.withOpacity(0.5),
                //       spreadRadius: 1,
                //       offset: const Offset(0, 0.5), // changes position of shadow
                //     ),
                //   ],
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width:44,
                          height: 44,
                          child: CardFace(photoUrl: ""),
                        ),

                        Expanded(
                          child:Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(_session.infoMember!.mberNm,
                                  maxLines: 1,
                                  style: ItemBkB16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(_session.getUserGrade(), style: ItemBkN14,),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 60,
                          height: 24,
                          child: ButtonState(
                            textStyle: ItemG1N12,
                            text: '정보변경',
                            onClick: () {
                              _doMgrMyInfo();
                            },),
                        )
                      ],
                    ),
                  ],
                ),
              )
          ),
          const Divider(),
        ]));
  }


  SliverList _renderProgramCard() {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   padding: EdgeInsets.fromLTRB(15,20,15,0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       SizedBox(
        //         child: Image.asset("assets/mypage/title_01.png", width: 18, height: 18,),
        //       ),
        //       SizedBox(width: 10,),
        //       Text("전체 프로그램", style: ItemBkB16,),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 15,),
        // Divider(height: 1,),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: CardMenu(
            items: program_memu,
            isItemVer:true,
            crossAxisCount: 3,
            childAspectRatio:1.4,
            crossAxisSpacing:10,
            itemGap: 5,
            btnColor:const Color(0xFFF5F6FA),
            onSelect: (item) {
              doAction(item);
            },
          ),
        ),
      ]),
    );
  }
  SliverList _renderChildCard() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15,20,15,0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("assets/mypage/title_01.png", width: 18, height: 18,),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text("등록된 나의 자녀 (${child_memu.length})", style: ItemBkB16,),
                  )
              ),

              SizedBox(
                width: 60,
                height: 24,
                child: ButtonState(
                  textStyle: ItemG1N12,
                  text: '정보변경',
                  onClick: () {
                    _doMgrChild();
                  },),
              )
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Divider(height: 1,),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: CardMenu(
            items: child_memu,
            isItemVer:true,
            crossAxisCount: 4,
            childAspectRatio:0.8,
            crossAxisSpacing:5,
            itemGap: 5,
            iconSize: 32,
            btnColor:Colors.transparent,//Color(0xFFF5F6FA),
            onSelect: (item) {
              doAction(item);
            },
          ),
        ),
      ]),
    );
  }
  SliverList _renderCustomCard() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15,20,15,0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("assets/mypage/title_02.png", width: 18, height: 18,),
              ),
              const SizedBox(width: 10,),
              const Text("맞춤형 서비스", style: ItemBkB16,),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Divider(height: 1,),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CardMenu(
            items: custom_memu,
            onSelect: (item) {
              doAction(item);
            },
          ),
        ),
      ]),
    );
  }
  SliverList _renderCommunityCard() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15,20,15,0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("assets/mypage/title_03.png", width: 18, height: 18,),
              ),
              const SizedBox(width: 10,),
              const Text("돌봄공동체", style: ItemBkB16,),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Divider(height: 1,),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CardMenu(
            items: care_comm_memu,
            onSelect: (item) {
              doAction(item);
            },
          ),
        ),
      ]),
    );
  }
  SliverList _renderActivityCard() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(15,20,15,0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("assets/mypage/title_04.png", width: 18, height: 18,),
              ),
              const SizedBox(width: 10,),
              const Text("돌봄활동가", style: ItemBkB16,),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        const Divider(height: 1,),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CardMenu(
            items: care_act_memu,
            onSelect: (item) {
              doAction(item);
            },
          ),
        ),
      ]),
    );
  }
  SliverList _renderSetting() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15,20,15,15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset("assets/mypage/title_03.png", width: 18, height: 18,),
                ),
                const SizedBox(width: 10,),
                const Text("환경설정", style: ItemBkB16,),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 30),
            child: Column(
              children: [
                // ListTile(
                //   title: const Text("PUSH 알림", style: ItemBkN18),
                //   trailing: Switch(
                //     inactiveThumbColor: Colors.white,
                //     inactiveTrackColor: Colors.grey,
                //     activeTrackColor: ColorB0,
                //     activeColor: ColorB0,
                //     value: true,
                //     onChanged: (value) {
                //       setState(() {
                //         //_settingInfo.useVibrateMode = value;
                //       });
                //     },
                //   ),
                // ),

                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 15,),
                CardTile(text: "비밀번호 변경", imagePath: 'assets/quick/password.png',
                  onTap: () {
                    _dochangePassword();
                  },),
                CardTile(text: "로그아웃", imagePath: 'assets/mypage/section_13.png',
                  onTap: () {
                    _doLogout();
                  },),
                CardTile(text: "회원탈퇴", imagePath: 'assets/quick/secession.png',
                  onTap: () {
                    _doWithdrawal();
                  },),
              ],
            ),
          )
        ])
    );
  }

  Future <void> _doMgrChild() async {
    var dirty = await Navigator.push(context,
      Transition(child: const MgrChild(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );

    if(dirty==true) {
      await _reqChild();
    }
  }

  Future <void> _doMgrActDeliveryClass() async {
    await Navigator.push(context,
      Transition(child: const MgrActDeliveryClass(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrActStudy() async {
    await Navigator.push(context,
      Transition(child: const MgrActStudy(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrActCourse() async {
    await Navigator.push(context,
      Transition(child: const MgrActCourse(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrProgram() async {
    await Navigator.push(context,
      Transition(child: const MgrRegProgram(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrCareCrops() async {
    await Navigator.push(context,
      Transition(child: const MgrCareCrops(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrSParent() async {
    await Navigator.push(context,
      Transition(child: const MgrSParent(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrSShare() async {
    await Navigator.push(context,
      Transition(child: const MgrSShare(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrInstCal() async {
    await Navigator.push(context,
      Transition(child: const MgrInstReserveCal(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrStampCal() async {
    await Navigator.push(context,
      Transition(child: const MgrStampCal(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doMgrSpace() async {
    await Navigator.push(context,
      Transition(child: const MgrSpace(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _dochangePassword() async {
    await Navigator.push(context,
      Transition(child: const ChangePassword(),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _doLogout() async {
    _showProgress(true);
    await doLogout(context, _session);
    _showProgress(false);
    widget.onPage(0);
  }

  // 서버에서 데이터를 가져온다.
  Future <void> _reqData() async {
     _showProgress(true);
     await _reqUserInfo();
     await _reqChild();
     _showProgress(false);
  }

  Future<void> _reqUserInfo() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/token.do",
      params: {},
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          _session.setUserInfo(InfoMember.fromJson(data['data']));
        }
      },
    );
  }

  Future<void> _doWithdrawal() async {
    showYesNoDialogBox(
        context: context,
        title: "회원탈퇴",
        message: "회원 가입정보를 삭제합니다.\n삭제된 정보는 복구되지 않습니다"
            "\n\n\n대전아이에서 탈퇴하시겠습니까?",
        onResult: (bOK) async {
          if(bOK) {
            await Remote.apiPost(
              context: context,
              session: _session,
              method: "appService/member/member_delete.do",
              params: {"mberSn":_session.infoMember!.mberSn},
              onError: (String error) {},
              onResult: (dynamic data) async {
                if (kDebugMode) {
                  var logger = Logger();
                  logger.d(data);
                }
                if(data['status'].toString()=="200") {
                  showToastMessage(data['message']);
                  _session.setLogout(true);
                  widget.onPage(0);
                }
              },
            );
          }
        }
    );
  }

  Future <void> _doMgrMyInfo() async {
    // await updateUserInfo(
    //     context: context,
    //     title: '내정보',
    //     onResult: (bool bDirty) {
    //       if(bDirty) {
    //         _session.notifyListeners();
    //       }
    // });
    await Navigator.push(context,
          Transition(
              child: UserInfo(
                title: "사용자 정보",
                onClose: (bool bDirty) {
                  if(bDirty) {
                    _session.notifyListeners();
                  }
              },
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }

  Future <void> _reqChild() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs.do",
      params: {},
      onError: (String error) {},
      onResult: (dynamic data) async {
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            var list = ItemChild.fromSnapshot(content);
            child_memu = [];
            for (var element in list) {
              child_memu.add(
                  CardMenuItem(
                    tag: element.parntsSn,
                    assetsPath: (element.parntsSexdstn=="1") ? "assets/mypage/avter_01.png":"assets/mypage/avter_02.png",
                    title: "${element.parntsChldrnNm} (${element.age()})",
                    subTitle: element.getDesc()
              ));
            }
            setState(() {});
          }
        }
      },
    );
  }
}
