// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names

import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:daejeoni/models/InfoMember.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SessionData with ChangeNotifier {

  bool    bIsExamine;
  int     iExamineBuildNum;
  int     iDevBuildNum;
  bool    bDeniedNotice;
  bool    bOnNotice;
  String? NoticeId;

  String  IsFirst;
  String  IsSigned;
  String? UserID;
  String  AccessToken;
  String  FirebaseToken;
  String  FireBaseTopics;
  List<String>?  FireBaseTopicList;
  String? AutoLogin;

  String  Level;
  String  Type;
  InfoMember? infoMember;

  int favoriteIndex;
  ItemFavoriteGps? favoriteBase;
  List<ItemFavoriteGps>? favoriteGpsList;

  String cntChild = "";
  String cntProgram = "";
  String cntSpace = "";
  String cntNotify = "";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SessionData({
    this.bIsExamine = true,
    this.iExamineBuildNum = 0,
    this.iDevBuildNum = 0,
    this.IsFirst = "",
    this.FireBaseTopics="",
    this.Level = "0",
    this.Type  = "",
    this.bOnNotice = false,
    this.bDeniedNotice  = false,
    this.IsSigned = "N",
    this.AccessToken = "",
    this.UserID = "",
    this.FirebaseToken = "",
    this.FireBaseTopicList,
    this.NoticeId = "",
    this.infoMember,
    this.AutoLogin = "N",
    this.favoriteIndex = 0,
    this.favoriteBase,
    this.favoriteGpsList,
    this.cntChild = "등록자녀 0명",
    this.cntProgram = "신청 0건",
    this.cntSpace = "신청 0건",
    this.cntNotify = "알림 0건",
  });

  void init() {
    FireBaseTopicList = [];
    favoriteGpsList = [];
    favoriteIndex = 0;
    favoriteBase = ItemFavoriteGps(
      mapTitle: "현위치",
      mapAddr: "주소정보 없음",
      mapX: 0.0,
      mapY: 0.0,
      bCurrent: true,
    );
    favoriteGpsList!.add(favoriteBase!);
  }

  void setNotify() {
    notifyListeners();
  }

  Future <void> updatePushToken(BuildContext context) async {
    if(isSigned() && infoMember!.appNtcnTkn2 != FirebaseToken) {
      await Remote.apiPost(
        context: context,
        session: this,
        method: "appService/member/member_update.do",
        params:  {"mberSn": infoMember!.mberSn,  "appNtcnTkn2": FirebaseToken },
        onError: (String error) {},
        onResult: (dynamic data) async {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
        },
      );
    }
  }

  Future <void> updateFavoriteGpsList(BuildContext context) async {

    if(favoriteGpsList!.isNotEmpty) {
      favoriteGpsList!.clear();
    }

    favoriteGpsList!.add(favoriteBase!);

    if(IsSigned=="Y") {
      await Remote.apiPost(
        context: context,
        session: this,
        method: "appService/mberMap/list.do",
        params: {},
        onError: (String error) {},
        onResult: (dynamic data) async {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200") {
            var content = data['data']['list'];
            if (content != null) {
              var list = ItemFavoriteGps.fromSnapshot(content);
              if (list.isNotEmpty) {
                favoriteGpsList!.addAll(list);
              }
            }
          }
        },
      );
    }
  }

  ItemFavoriteGps getCurrentFavoriteInfo() {
    if(!isSigned()) {
      favoriteIndex = 0;
    }
    return favoriteGpsList![favoriteIndex];
  }

  Future <void> updateGpsLocation(double lon, double lat) async {
    if (kDebugMode) {
      print("updateGpsLocation start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }

    favoriteBase!.mapX = lon;
    favoriteBase!.mapY = lat;

    await Remote.getAddress(
      longitude: lon.toString(),
      latitude: lat.toString(),
      onError: (error){},
      onResult: (dynamic data){
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }

        var road_address = data['road_address'];
        var address = data['address'];
        if(road_address != null) {
          favoriteBase!.mapAddr = road_address['address_name'].toString();
        } else if(address != null) {
          favoriteBase!.mapAddr = address['address_name'].toString();
        }
        else {
          favoriteBase!.mapAddr = "알수없음";
        }
      },
    );

    notifyListeners();

    if (kDebugMode) {
      print("updateGpsLocation end >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }
  }

  @override
  String toString(){
    return 'SessionData {'
        'IsSigned:$IsSigned, '
        'token:$AccessToken, '
        'FirebaseToken:$FirebaseToken, '
        'FireBaseTopic:${FireBaseTopicList.toString()}, '
        'UserID:$UserID, '
        'signInfo:${infoMember.toString()} '
        '}';
  }

  String getUserGrade() {
    if(infoMember!.mberSn == "0") {
      return "비회원";
    }

    if(Type=="PARNTS") {
      if (Level == "1") {
        return "부모회원 / 돌봄활동가";
      }
      return "부모회원";
    } else {
      if (Level == "1") {
        return "기관회원 / 돌봄활동가";
      }
      return "기관회원";
    }
  }

  bool isSigned() {
    return (IsSigned=="Y") ? true : false;
  }

  void setUserInfo(InfoMember info) {
    infoMember = info;
    Level = infoMember!.mberActvstLevel;
    Type = infoMember!.mberType;
  }

  Future<void> setSigning(String ids) async {
    IsSigned   = "Y";
    if(ids.isNotEmpty) {
      UserID = ids;
      await _storage.write(key: 'UserID',      value: UserID);
    }
  }

  // 신규 로그인 처리
  Future<void> setLogin(String token) async {
    IsSigned   = "Y";
    if(token.isNotEmpty) {
      AccessToken = token;
      await _storage.write(key: 'Token',       value: AccessToken);
    }

    await _storage.write(key: 'AutoLogin',     value: AutoLogin);
    notifyListeners();
  }

  Future <void> setLogout(bool isDelete) async {
    AccessToken = "";
    IsSigned  = "N";
    AutoLogin = "N";
    await _storage.write(key: 'AutoLogin',   value: AutoLogin);
    await _storage.write(key: 'Token', value: AccessToken);
    if(isDelete) {
      UserID = "";
      await _storage.write(key: 'UserID', value: UserID);
    }
    notifyListeners();
  }

  Future <void> updateNoticeStatus(bool bConfirmed, String noticeId) async {
    bool flag = (NoticeId!.isNotEmpty && NoticeId != noticeId);
    if(bConfirmed) {
      bOnNotice = false;
    }
    else {
      if (flag != bOnNotice) {
        bOnNotice = true;
      }
    }

    NoticeId = noticeId;
    await _storage.write(key: 'NoticeId', value: NoticeId);
    setNotify();
  }

  // Future <void> setNoticeId(String noticeId) async {
  // }

  void addTopic(String topic) {
    FireBaseTopicList ??= [];
    if(!FireBaseTopicList!.contains(topic)) {
      FireBaseTopicList!.add(topic);
    }
  }

  void delTopic(String topic) {
    FireBaseTopicList ??= [];
    if(FireBaseTopicList!.contains(topic)) {
      FireBaseTopicList!.remove(topic);
    }
  }

  // topic 구성이 변경되면 저장한다.
  Future <void> setTopics() async {
    FireBaseTopics = fromFirebaseTopicList();
    print("setTopics() : $FireBaseTopics");
    await _storage.write(key: 'FireBaseTopics', value: FireBaseTopics);
  }

  // String getFirebaseTopics() {
  //   return FireBaseTopics;
  // }

  // 현재 구독중인 topic를 추출한다.
  String fromFirebaseTopicList() {
    String topics = "";
    for (var element in FireBaseTopicList!) {
      if(topics.isNotEmpty) {
        topics += ",";
      }
      topics += element;
    }
    return topics;
  }

  void toFirebaseTopicList() {
    List list = FireBaseTopics.split(",");
    FireBaseTopicList = [];
    for (var element in list) {
      FireBaseTopicList!.add(element);
    }

    print("toFirebaseTopicList() : $FireBaseTopics");
  }

  Future <void> setFirebaseToken(String firebaseToken) async {
    if(FirebaseToken != firebaseToken) {
      FirebaseToken = firebaseToken;
      await _storage.write(key: 'FirebaseToken', value: FirebaseToken);
      notifyListeners();
    }
  }

  Future <void> setIsFirstClear() async {
    IsFirst = "N";
    await _storage.write(key: 'IsFirst', value: IsFirst);
  }

  Future <void> loadData() async {
    AccessToken = "";
    infoMember = InfoMember();
    if(await _storage.containsKey(key:'Token')) {
      String? v = await _storage.read(key: 'Token');
      if(v!=null) {
        AccessToken = v;
      }
    }

    if(await _storage.containsKey(key:'NoticeId')) {
      NoticeId = await _storage.read(key: 'NoticeId');
    }

    FirebaseToken = "";
    if(await _storage.containsKey(key:'FirebaseToken')) {
      String? t = await _storage.read(key: 'FirebaseToken');
      if(t != null) {
        FirebaseToken = t;
      }
    }

    IsFirst = "";
    if(await _storage.containsKey(key:'IsFirst')) {
      String? t = await _storage.read(key: 'IsFirst');
      if(t != null) {
        IsFirst = t;
      }
    }

    FireBaseTopics = "";
    if(await _storage.containsKey(key:'FireBaseTopics')) {
      String? t = await _storage.read(key: 'FireBaseTopics');
      if(t != null) {
        FireBaseTopics = t;

        // 최종 구독중인 topic 정보 로드.
        toFirebaseTopicList();
      }
    }

    // if(await _storage.containsKey(key:'FireBaseTopicSaved')) {
    //   FireBaseTopic = await _storage.read(key: 'FireBaseTopic');
    // }

    if(await _storage.containsKey(key:'AutoLogin')) {
      AutoLogin = await _storage.read(key: 'AutoLogin');
    }

    if(await _storage.containsKey(key:'UserID')) {
      UserID = await _storage.read(key: 'UserID');
    }
    notifyListeners();
  }

}