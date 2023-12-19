// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously
import 'package:daejeoni/home/route.dart';
import 'package:daejeoni/home/tap00_home/showNoticeList.dart';
import 'package:daejeoni/home/tap01_inst/pageInstList.dart';
import 'package:daejeoni/home/tap02_sos/pageCareSos.dart';
import 'package:daejeoni/home/tap00_home/pageHome.dart';
import 'package:daejeoni/home/tap03_experience/pageExperience.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrChild.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrRegProgram.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSpace.dart';
import 'package:daejeoni/home/tapo5_myPage/popUserInfo.dart';
import 'package:daejeoni/home/website.dart';
import 'package:daejeoni/provider/gpsStatus.dart';
import 'package:daejeoni/push/postPush.dart';
import 'package:daejeoni/push/showPushMessage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/push/localNotification.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tap04_board/pageBoard.dart';
import 'package:daejeoni/home/tapo5_myPage/pageMyHome.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  static const int tabCount = 6;

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  late final _tabController = TabController(length: tabCount, vsync: this);
  late SessionData _session;
  late GpsStatus _gpsProvider;
  late DateTime _preBackpress;

  int _instPageState = STAGE_LIST;
  int _sosPageState  = STAGE_MAP;
  int _expPageState  = STAGE_LIST;

  bool _bReady = false;
  bool _bWaitInit = false;
  int _tabIndex = 0;
  int _pageIndex = 0;
  int _backIndex = 0;
  bool _hideBottomBar = false;

  String _versionInfo = "";
  String _serverInfo = "";

  bool _bInitMessage = false;
  Future <void> _setVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _versionInfo = "${packageInfo.version} (${packageInfo.buildNumber})";
    _serverInfo  = SERVER.split("//").elementAt(1);
    _session.iDevBuildNum = (packageInfo.buildNumber.isNotEmpty) ? int.parse(packageInfo.buildNumber) : 0;
    if (kDebugMode) {
      print("_versionInfo:$_versionInfo");
      print("_serverInfo:$_serverInfo");
    }
  }

  Future <void> procFirebaseMassing() async {
    if (kDebugMode) {
      print("procFirebaseMassing()::start.");
    }

    await requestNotificationPermission();

    messaging.getToken().then((token) {
      if (kDebugMode) {
        print("procFirebaseMassing()::getToken(): ---- > $token");
      }
      _session.FirebaseToken = (token != null)  ? token : "";
    });

    // 사용자가 클릭한 메시지를 제공함.
    messaging.getInitialMessage().then((message) {
      if (kDebugMode) {
        print("getInitialMessage(user tab) -----------------> ");
      }

      if(message != null && message.notification != null) {
        String action = "";
        if(message.data["action"] != null) {
          action = message.data["action"];
        }

        if (kDebugMode) {
          print("title=${message.notification!.title.toString()},\n"
              "body=${message.notification!.body.toString()},\n"
              "action=$action");
        }

        _bInitMessage = true;
        checkNoticeReceived(context, _session);
      }

      // if foreground state here.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print("Foreground Status(active) -----------------> ");
        }

        if(message.notification != null) {
          String action = "";
          action = message.data.toString();//message.data["boardSn"];
          // if(message.data["boardSn"] != null) {
          //   action = message.data.toString();//message.data["boardSn"];
          // }

          if (kDebugMode) {
            print("title=${message.notification!.title.toString()},\n"
                "body=${message.notification!.body.toString()},\n"
                "action=$action");
          }

          if(message.notification?.android != null) {
            notification.show(
                title:message.notification!.title.toString(),
                body:message.notification!.body.toString(),
                action: action
            );
          }
          checkNoticeReceived(context, _session);
        }
      });

      // 엡이 죽지않고 백그라운드 상태일때...
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        if (kDebugMode) {
          print("Background Status(alive) -----------------> ");
        }

        if(message.notification != null) {
          String action = message.data.toString();
          // if(message.data["action"] != null) {
          //   action = message.data["action"];
          // }
          if (kDebugMode) {
            print("title=${message.notification!.title.toString()},\n"
                "body=${message.notification!.body.toString()},\n"
                "action=$action");
          }

          // if(message.notification?.android != null) {
          //   notification.show(
          //       title:message.notification!.title.toString(),
          //       body:message.notification!.body.toString(),
          //       action: "onMessageOpenedApp"
          //
          //   );
          // }
          await checkNoticeReceived(context, _session);
          goPushHome(context);
        }
      });

    });
  }

  Future <void> _updateLocation() async {
    await _gpsProvider.updateGeolocator(true);
    await _session.updateGpsLocation(_gpsProvider.longitude(), _gpsProvider.latitude());
  }

  Future <void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      //print('알림 권한이 승인되었습니다.');
      _session.bDeniedNotice = true;
      showToastMessage("알림 수신이 거부되었습니다.");
    }
  }

  void openAndroidSettingsApp() async {
    const url = 'package:com.android.settings';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showToastMessage("설정 앱을 열 수 없습니다.");
    }
  }

  @override
  void initState() {
    _bInitMessage = false;
    _bReady = false;
    _bWaitInit = true;
    _preBackpress   = DateTime.now();
    _session = Provider.of<SessionData>(context, listen: false);
    _gpsProvider = Provider.of<GpsStatus>(context, listen: false);
    _session.init();
    _session.loadData();

    Future.delayed(Duration(milliseconds: 250), () async {
      await _setVersionInfo();
      WidgetsBinding.instance.addObserver(this);
      await notification.init(context);
      await notification.requestPermissions();
      await notification.cancel();
      await procFirebaseMassing();
      await checkExamine(context, _session);
      await _updateLocation();

      setState(() {
        _bReady = true;
      });

      // 앱 설치후 최초 실행시 이전 topic 정보를 초기화 한다.
      //print("IsFirst(${_session.IsFirst})  *****************************");
      if(_session.IsFirst != "N") {
        await unsubscribeFromMultipleTopics(_session, ["DEV","ACT","INS", "PAR"]);
        await FirebaseMessaging.instance.subscribeToTopic("ALL");
        _session.addTopic("ALL");
        await _session.setIsFirstClear();
      }

      if (kDebugMode) {
        await FirebaseMessaging.instance.subscribeToTopic("DEV");
        _session.addTopic("DEV");
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic("DEV");
        _session.delTopic("DEV");
      }

      await _session.setTopics();

      setState(() {
        _bWaitInit = false;
      });

      await doLoginProc(context, _session, true);

      if(_bInitMessage) {
        _onShowPushMessage(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    _session = Provider.of<SessionData>(context, listen: true);
    if (!_bReady) {
      return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                  child: Center(
                      child: ClipRect(
                        child: Container(
                          color: Colors.white,
                          child:Image.asset(
                            "assets/icon/ic_launcher.png",
                            //width: 180,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          )
                      ),
                    )
                  )
              ),
              Positioned(
                  child: Visibility(
                    visible: _bWaitInit,
                      child: Center(
                        child: CircularProgressIndicator(),
                      )
                  )
              ),
            ],
          )
      );
    }

    const double barItemImageHeight=20;
    return Scaffold(
      key: _scaffoldStateKey,
      drawer: _renderDrawer(),
      bottomNavigationBar: Visibility(
        visible: !_hideBottomBar,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          onTap: (int index) async {
            if (_tabIndex == index) {
              return;
            }

            if(index==4 || index==5) {
                if(await ConfirmSigned(context,_session)) {
                  _goPage(index);
                }
            } else {
              _goPage(index);
            }
          },

          currentIndex: _tabIndex,
          items: [
            BottomNavigationBarItem(
                label: "홈",
                icon: Container(
                  padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 0)
                        ? "assets/tab/icon01_on.png"
                        : "assets/tab/icon01.png",
                  height: barItemImageHeight,
                  fit: BoxFit.fitHeight,
                ))
            ),
            BottomNavigationBarItem(
                label: "돌봄기관",
                icon: Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 1)
                          ? "assets/tab/icon02_on.png"
                          : "assets/tab/icon02.png",
                      height: barItemImageHeight,
                      fit: BoxFit.fitHeight,
                    )
                )
            ),
            BottomNavigationBarItem(
                label: "체험기관",
                icon: Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 2)
                          ? "assets/tab/icon04_on.png"
                          : "assets/tab/icon04.png",

                      height: barItemImageHeight,
                      fit: BoxFit.fitHeight,
                    )
                )
            ),
            BottomNavigationBarItem(
                label: "의료기관",
                icon: Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 3)
                          ? "assets/tab/icon03_on.png"
                          : "assets/tab/icon03.png",
                      height: barItemImageHeight,
                      fit: BoxFit.fitHeight,
                    )
                )
            ),
            BottomNavigationBarItem(
                label: "소통창구",
                icon: Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 4)
                          ? "assets/tab/icon05_on.png"
                          : "assets/tab/icon05.png",
                      height: barItemImageHeight,
                      fit: BoxFit.fitHeight,
                    )
                )
            ),
            BottomNavigationBarItem(
                label: "마이페이지",
                icon: Container(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child:Image.asset(
                      (_tabIndex == 5)
                          ? "assets/tab/icon06_on.png"
                          : "assets/tab/icon06.png",
                      height: barItemImageHeight,
                      fit: BoxFit.fitHeight,
                    )
                )
            ),
          ],
        ),
      ),
        body: WillPopScope(
            onWillPop: onWillPop,
            child: _buildTabHome()
        ),
    );
  }

  bool _bWait = false;
  void _showProgress(bool bShow) {
    setState(() {
      _bWait = bShow;
    });
  }

  Widget _buildTabHome() {
    if (!_bReady) {
      return Container();
    }
    return Stack(
      children: [
        Positioned(
            child: Container(
            margin: const EdgeInsets.only(bottom:0),
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                // 00: 홈
                PageHome(
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),

                // 01: 돌봄기관
                PageInstList(
                  pageStage: _instPageState,
                  onStage: (stage) { _instPageState = stage; },
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),

                // 02: 체험기관
                PageExperience(
                  pageStage: _expPageState,
                  onStage: (stage){ _expPageState = stage; },
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),

                // 03: 의료기관
                PageCareSos(
                  pageStage: _sosPageState,
                  onStage: (stage){ _sosPageState = stage; },
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),



                // 04: 소통창구 전체상품
                PageBoard(
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),

                // 05: 마이베이지
                PageMyHome(
                  onDrawer: () { _scaffoldStateKey.currentState!.openDrawer();},
                  onNotice: () { _onShowPushMessage(false);},
                  onSignin: () async { await doLoginProc(context, _session, false);},
                  onPage: (int page) {
                    _goPage(page);
                  },
                ),
              ],
            ),
          )
        ),
        Positioned(
            child: Visibility(
                visible: _bWait,
                child: Center(
                  child: CircularProgressIndicator(),
                )
            )
        ),
      ],
    );
  }

  void _goPage(int index) {
    setState((){
      if (index < tabCount) {
        _hideBottomBar = false;
        _tabIndex  = index;
        _backIndex = index;
      } else {
        _hideBottomBar = true;
      }

      _pageIndex = index;
      if(_pageIndex==1) {
        _instPageState = STAGE_LIST;
        _sosPageState  = STAGE_MAP;
        _expPageState  = STAGE_LIST;
      }
      if(_pageIndex==2) {
        _instPageState = STAGE_LIST;
        _sosPageState  = STAGE_MAP;
        _expPageState  = STAGE_LIST;
      }
      if(_pageIndex==3) {
        _instPageState = STAGE_LIST;
        _sosPageState  = STAGE_MAP;
        _expPageState  = STAGE_LIST;
      }
      _tabController.animateTo(index,
          duration: const Duration(milliseconds: 0), curve: Curves.ease);
    });
  }

  Widget _drowerItem({
    required String menuText,
    String? subText = "",
    String? imagePath = "",
    required Function() onTap}){
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.white,
        padding: (imagePath!.isNotEmpty)
            ? const EdgeInsets.fromLTRB(20, 1, 10, 3)
            : const EdgeInsets.fromLTRB(20, 5, 10, 5),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: imagePath.isNotEmpty,
              child: SizedBox(
                width: 24,
                child: Image.asset(imagePath, width: 24, fit: BoxFit.fitWidth,),
              ),
            ),

            Expanded(
                child: Container(
                  padding: (imagePath.isNotEmpty)
                      ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
                      : const EdgeInsets.fromLTRB(0, 5, 5, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuText,
                        style: (imagePath.isNotEmpty) ? ItemBkN14 : ItemBkN16,
                      ),
                      Visibility(
                        visible: subText!.isNotEmpty,
                        child: Text(
                          subText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green
                          ),
                        ),),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }


  Widget _renderDrawer() {
    final String axisInfo = getMainAxisInfo(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      child: SafeArea(
        child:Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 1. title bar
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 20),
                        child: Row(
                          children: [
                            Image.asset("assets/intro/intro_logo.png",
                                height: 38, fit: BoxFit.fitHeight),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: app_top_size_close,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),

                      // 2. user info
                      Visibility(
                        visible: _session.isSigned(),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          padding: const EdgeInsets.fromLTRB(10,0,5,0),
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.grey,
                                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                title: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(
                                          _session.infoMember!.mberNm,
                                          maxLines: 2,
                                          style: ItemBkB18,
                                          overflow: TextOverflow.ellipsis,
                                        ),),
                                        GestureDetector(
                                          onTap: () async {
                                            // await updateUserInfo(
                                            //     context: context,
                                            //     title: '내정보',
                                            //     onResult: (bool bDirty) {
                                            //       if(bDirty) {
                                            //         _session.notifyListeners();
                                            //       }
                                            //     });
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
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(left:10),
                                            width: 64,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/quick/write.png", height: 14, fit: BoxFit.fitHeight,),
                                                const Text("정보수정", style: ItemG1N12,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      _session.getUserGrade(),
                                      maxLines: 1,
                                      style: ItemBkN14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    //const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),),
                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: _drowerItem(
                            menuText: '자녀정보',
                            subText: _session.cntChild,
                            imagePath: 'assets/quick/img01.png',
                            onTap: () {
                              Navigator.push(context,
                                Transition(child: const MgrChild(),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                              );
                            }
                        ),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child:  _drowerItem(
                            menuText: '문화/행사 신청현황',
                            subText: _session.cntProgram,
                            imagePath: 'assets/quick/img02.png',
                            onTap: () {
                              Navigator.push(context,
                                Transition(child: const MgrRegProgram(),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                              );
                            }
                        ),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child:_drowerItem(
                            menuText: '공간신청 현황',
                            subText: _session.cntSpace,
                            imagePath: 'assets/quick/img03.png',
                            onTap: () {
                              Navigator.push(context,
                                Transition(child: const MgrSpace(),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                              );
                            }),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: _drowerItem(
                            menuText: '알림',
                            subText: "PUSH 메시지",//_session.cntNotify,
                            imagePath: 'assets/quick/img04.png',
                            onTap: () {
                              _onShowPushMessage(false);
                            }),
                      ),

                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(),
                      ),

                      /*
                      Visibility(
                        visible: _session.isSigned(),
                        child: _drowerItem(
                            menuText: '로그아웃',
                            subText: "",
                            imagePath: 'assets/mypage/section_13.png',
                            onTap: () {
                              _doLogout();
                            }
                        ),
                      ),
                      */
                      Visibility(
                        visible: _session.isSigned(),
                        child: const Divider(thickness: 3, color: Color(0xFFF0F0F0),),
                      ),

                      Visibility(
                        visible: !_session.isSigned(),
                        child: _drowerItem(
                            menuText: '로그인',
                            imagePath: "",
                            onTap: () async {
                              await doLoginProc(context, _session, false);
                            }),
                      ),

                      Visibility(
                        visible: !_session.isSigned(),
                        child: const Divider(),
                      ),

                      _drowerItem(
                          menuText: '공지사항',
                          imagePath: "",
                          onTap: () {
                            Navigator.push(
                              context,
                              Transition(
                                  child: const ShowNoticeList(
                                  ),
                                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                            );
                          }),
                      const Divider(),
                      _drowerItem(
                          menuText: '소통창구',
                          imagePath: "",
                          onTap: () {
                            _goPage(4);
                            Future.microtask(() {
                              Navigator.pop(context);
                            });
                          }
                      ),

                      Visibility(
                        visible: !_session.isSigned(),
                        child:
                        const Divider(),
                      ),

                      Visibility(
                        visible: !_session.isSigned(),
                        child: _drowerItem(
                          menuText: '회원가입',
                          imagePath: '',
                          onTap: () {
                            //goRegist(context, _session);
                            doRegist(context);
                          }),),

                      const Divider(),
                      _drowerItem(
                          menuText: '센터 홈페이지',
                          imagePath: "",
                          onTap: () {
                            goHomePage(context, _session);
                          }),

                      Visibility(
                        visible: kDebugMode,
                        child: _drowerItem(
                            menuText: '푸시 발송',
                            imagePath: "",
                            onTap: () async {
                              Navigator.push(
                                context,
                                Transition(
                                    child: const PostPush(),
                                    transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
                              );
                              // _doPostPush(
                              //     "알림보내기",
                              //     "테스트 메시지",
                              //     "ALL",
                              //     '{ "id":100, "key":"1234" }'
                              // );
                            }
                        ),
                      ),
                    ],
                  ),
                )
            )
            ),
            // app info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("빌드정보:", style: ItemBkN12,),
                      const SizedBox(width: 5,),
                      Text("버전: $_versionInfo", style: ItemBkN12,),
                      const SizedBox(width: 5,),
                      Text(axisInfo, style: ItemBkN12),
                    ],
                  ),
                  //Text("Topics: ${_session.FireBaseTopics}", style: ItemBkN12,),
                  // Text("서버: $_serverInfo", style: ItemBkN12),
                  // const Text("빌드일자: $buildDate", style: ItemBkN12),
                  // Text("실행환경: $axisInfo", style: ItemBkN12),
                  Container(
                    margin: const EdgeInsets.only(top:5),
                    width: double.infinity,
                    //color: Colors.amber,
                    child:const Text(
                      //softWrap:false,
                        "손에손잡고 오손도손 공들여 함께 키우는 대전아이",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.normal
                        )),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child:Text(
                        "대전광역시다함께돌봄원스톱통합지원센터",
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 1,),
                      TextButton(
                          onPressed: () {
                            showWebsite(context, _session,
                                "개인정보처리방침","/dolbom/pages/policy/privacy.do", false );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text("개인정보처리방침",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                              )
                          )
                      ),
                      // Spacer(),
                      TextButton(
                        onPressed: () {
                          showWebsite(context, _session,
                              "이용약관","/dolbom/pages/policy/agree.do", false );
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                        ),
                        child: const Text("이용약관",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ),
                      // Spacer(),
                      TextButton(
                        onPressed: () {
                          showWebsite(context, _session,
                              "저작권정책","/dolbom/pages/policy/copyright.do", false );
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                        ),
                        child: const Text("저작권정책",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // backKey event 처리

  Future <bool> onWillPop() async {
    if (_closeDrower()) {
      _closeDrower();
      return false;
    }

    if(_pageIndex==1 && _instPageState != STAGE_LIST) {
      setState(() {
        _instPageState = STAGE_LIST;
      });
      return false;
    }

    if(_pageIndex==2 && _sosPageState != STAGE_MAP) {
      setState(() {
        _sosPageState = STAGE_MAP;
      });
      return false;
    }

    if(_pageIndex==3 && _expPageState != STAGE_LIST) {
      setState(() {
        _expPageState = STAGE_LIST;
      });
      return false;
    }

    if(_pageIndex != 0) {
      if (_pageIndex > _tabIndex) {
        _goPage(_backIndex);
        return false;
      }
      else {
        if (_tabIndex != 0) {
          _goPage(0);
          return false;
        }
      }
    }

    //print("check Clossing....");
    final timegap = DateTime.now().difference(_preBackpress);
    final cantExit = timegap >= const Duration(seconds: 2);
    _preBackpress = DateTime.now();

    //print("check Clossing....cantExit[$cantExit]");

    if (cantExit) {
      showToastMessage("한번 더 누르면 앱을 종료합니다.");
      return false; // false will do nothing when back press
    }

    Fluttertoast.cancel();
    return true; // true will exit the app
  }

  // 메뉴바 닫기
  bool _closeDrower() {
    if (_scaffoldStateKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
      return true;
    }
    return false;
  }

  /*
  Future <void> _doLogout() async {
    _showProgress(true);
    await doLogout(context, _session);
    _showProgress(false);
    _goPage(0);
  }
  */
  Future <void> _onShowPushMessage(bool bShowDetail) async {
    // notification.cancel();
    // notification.show(title:"알림테스트", body:"알림 테스트입니다.", action: "test");
    Navigator.push(
      context,
      Transition(
          child: ShowPushMessage(bShowDetail: bShowDetail,),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
}
