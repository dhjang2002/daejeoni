
// ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously
import 'dart:io';

import 'package:daejeoni/home/auth/regist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/auth/password.dart';
import 'package:daejeoni/home/auth/login.dart';
import 'package:daejeoni/models/ItemMessage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:daejeoni/models/InfoMember.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:transition/transition.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

Widget getNotificationIcon({required bool isDenaied, required bool isRecevied}) {
  if(isDenaied) {
    return const Icon(Icons.notifications_off_outlined,
        size: app_top_size_bell,
        color: Colors.black
    );
  }
  if(isRecevied) {
    return const Icon(Icons.notifications_active_rounded,
        size: app_top_size_bell,
        color: Colors.red
    );
  }

  return const Icon(Icons.notifications_none_rounded,
      size: app_top_size_bell,
      color: Colors.black
  );
}


Future <bool> SigningWithToken(BuildContext context, SessionData session) async {
  bool flag = false;

  if(session.AccessToken.isEmpty || session.AccessToken.length<8) {
    return false;
  }

  await Remote.apiPost(
    bTrace: false,
    context: context,
    session: session,
    method: "appService/member/token.do",
    params: {},
    onError: (String error) {},
    onResult: (dynamic data) async {
      if (kDebugMode) {
        var logger = Logger();
        logger.d(data);
      }
      //showToastMessage("[3<]:Ok.");
      if(data['status'].toString()=="200" && data['data'] != null) {
        session.setUserInfo(InfoMember.fromJson(data['data']));
        await session.setSigning(session.infoMember!.mberId);
      }
      // else {
      //   showToastMessage(data['message']);
      // }
    },
  );
  return flag;
}

Future <bool> ConfirmSigned(BuildContext context, SessionData session) async {
  if(!session.isSigned()) {
    //showToastMessage("로그인 후 사용해주세요.");
    await doLoginProc(context, session, false);
    if(session.isSigned()) {
      return true;
    }
    return false;
  }
  return true;
}

Future <void> setFirebaseSubcribed(SessionData session) async {
  if(session.infoMember!.mberSn != "0") {
    if (session.Type == "PARNTS") {
      await FirebaseMessaging.instance.subscribeToTopic("PAR");
      session.addTopic("PAR");
      if (session.Level == "1") {
        await FirebaseMessaging.instance.subscribeToTopic("ACT");
        session.addTopic("ACT");
      }
    } else {
      await FirebaseMessaging.instance.subscribeToTopic("INS");
      session.addTopic("INS");
      if (session.Level == "1") {
        await FirebaseMessaging.instance.subscribeToTopic("ACT");
        session.addTopic("ACT");
      }
    }
    await session.setTopics();
  }
}

Future <void> unsubscribeFromMultipleTopics(SessionData session, List<String> topics) async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  for (String topic in topics) {
    await firebaseMessaging.unsubscribeFromTopic(topic);
    session.delTopic(topic);
    if (kDebugMode) {
      print('Unsubscribed from topic: $topic');
    }
  }

  await session.setTopics();
}

Future <void> doLoginProc(BuildContext context, SessionData session, bool bFirst) async {
  //print("doLoginProc(bFirst:$bFirst)");

  if(session.isSigned()) {
    return;
  }

  if(bFirst && session.AutoLogin != "Y") {
    await checkNoticeReceived(context, session);
    return;
  }

  if(session.AutoLogin == "Y") {
    await SigningWithToken(context, session);
  }

  if(!session.isSigned()) {
    if(!bFirst) {
      await doLogin(context);
    }
  }

  await reqSymmary(context, session);
  if(session.isSigned()) {
    await session.updatePushToken(context);
    await setFirebaseSubcribed(session);
    await session.updateFavoriteGpsList(context);
  }

  await checkNoticeReceived(context, session);
}

// 서버에서 데이터를 가져온다.
Future <void> reqSymmary(BuildContext context, SessionData session) async {
  if(!session.isSigned()) {
    // session.cntChild = "등록자녀 0명";
    // session.cntProgram = "신청 0건";
    // session.cntSpace = "신청 0건";
    // session.cntNotify = "알림 0건";
    // session.setNotify();
    return;
  }

  await Remote.apiPost(
    context: context,
    session: session,
    method: "appService/main/main.do",
    params: {},
    onError: (String error) {},
    onResult: (dynamic data) {
      // if (kDebugMode) {
      //   var logger = Logger();
      //   logger.d(data);
      // }

      if(data['status'].toString() == "200") {
        var info = data['data'];
        session.cntChild = "등록자녀 ${info['childs_count']}명";
        session.cntProgram = "신청 ${info['program_apply_count']}건";
        session.cntSpace = "신청 ${info['spce_apply_count']}건";
        session.cntNotify = "알림 ${info['notice_count']}건";
        session.setNotify();
      }
    },
  );
}

Future <void> doLogin(BuildContext context,) async {
  await Navigator.push(context,
    Transition(child: const Login(),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

Future <void> doLogout(BuildContext context, SessionData session ) async {
  await unsubscribeFromMultipleTopics(session, ["ACT","INS", "PAR"]); // "DEV",
  if(session.isSigned()) {
    session.setLogout(false);
  }
}

Future <void> dochangePassword(BuildContext context) async {
  await Navigator.push(context,
    Transition(child: const ChangePassword(),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

void doRegist(BuildContext context) {
  Navigator.push(
    context,
    Transition(
        child: const Regist(
          title: "회원가입",
        ),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

Future <String> NaverSigning(BuildContext context) async {
  String access_token = "";
  // FlutterNaverLogin.initSdk(
  //     clientId: clientId, clientName: clientName, clientSecret: clientSecret)
  final NaverLoginResult result = await FlutterNaverLogin.logIn();
  if(result.status==NaverLoginStatus.loggedIn) {
    NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
    access_token = token.accessToken;
  }
  return access_token;
}

Future <String> kakaoSigning(BuildContext context) async {
  String access_token = "";

  bool isInstalled = await isKakaoTalkInstalled();
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (isInstalled) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      access_token = token.accessToken;
      //print('카카오톡으로 로그인 성공');
    } catch (error) {
      //print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return access_token;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      //showToastMessage("Kakao 로그인을 사용할 수 없습니다.");
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        access_token = token.accessToken;
        //print('카카오계정으로 로그인 성공');
      } catch (error) {
        showToastMessage('카카오 계정으로 로그인 실패 $error');
        //print('카카오계정으로 로그인 실패 $error');
      }
    }
  }
  else {
    //showToastMessage("Kakao 로그인을 사용할 수 없습니다.");
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      access_token = token.accessToken;
      print('카카오계정으로 로그인 성공');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }

  /*
  bool talkInstalled = await isKakaoTalkInstalled();
  if (!talkInstalled) {
    showOkDialogBox(
        context: context,
        title: "안내",
        message: "Kakao Talk 앱을 설치하여 사용하십시오."
    );
    return "";
  }
  else
  {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      access_token = token.accessToken;
      //print('카카오톡으로 로그인 성공 $access_token');
    } catch (e) {
      //showToastMessage('카카오 계정으로 로그인 할 수 없습니다.');
      //print('카카오계정으로 로그인 실패');
      // 유저에 의해서 카카오톡으로 로그인이 취소된 경우 카카오계정으로 로그인 생략 (ex 뒤로가기)
      // if (e is PlatformException && e.code == 'CANCELED') {
      //   return access_token;
      // }

      // 카카오톡에 로그인이 안되어있는 경우 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        access_token = token.accessToken;
        //print('카카오톡으로 로그인 성공 $access_token');
      } catch (e) {
        //print('카카오계정으로 로그인 실패');
        showToastMessage('카카오계정으로 로그인 실패');
      }
    }
  }
  */
  return access_token;
}

Future <void> checkNoticeReceived(BuildContext context, SessionData session) async {
  await Remote.apiPost(
      timeOut: 1,
      context: context,
      session: session,
      method: "appService/pushNtcn/list.do",
      params: {
        "page" : 1,
        "countPerPage": 1,
        "pushToken": session.FirebaseToken,
        "pushTopic": session.FireBaseTopics
      },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        var content = data['data']['list'];
        if (content != null) {
          var list = ItemPush.fromSnapshot(content);
          if(list.isNotEmpty) {
            await session.updateNoticeStatus(false, list[0].pushNtcnSn.toString());
          }
        }
      }
  );
}

Future <void> checkExamine(BuildContext context, SessionData session) async {
  await Remote.apiPost(
      timeOut: 3,
      context: context,
      session: session,
      method: "appService/pushNtcn/ready.do",
      params: {},
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }

        String status = "F"; // 심사완료
        int build = 0;
        if(data['status'].toString()=="200") {
          if (Platform.isAndroid) {
            status = (data['data']['android'] != null) ? data['data']['android'].toString() : "F";
            build  = (data['data']['android-ver'] != null) ? int.parse(data['data']['android-ver'].toString()) : 99999;
          } else {
            status = (data['data']['ios'] != null) ? data['data']['ios'].toString() : "F";
            build  = (data['data']['ios-ver'] != null) ? int.parse(data['data']['ios-ver'].toString()) : 99999;
          }
          session.bIsExamine = (status=="R"); // 심사중
          session.iExamineBuildNum  = build;
          session.setNotify();
          if (kDebugMode) {
            print("session.bIsExamine=${session.bIsExamine}");
            print("session.iExamineBuildNum=${session.iExamineBuildNum}");
            print("session.iDevBuildNum=${session.iDevBuildNum}");
          }
        }
      }
  );
}
