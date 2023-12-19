
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';

Future <void> findPassword(BuildContext context, SessionData session, bool bShowBrower) async {
  String url = getUrlParam(
    website: '$SERVER/appService/gotoUrl.do',
    data: {
      "returnUrl":"/dolbom/member/find-mber.do",
      "jwtToken":session.AccessToken
    },
  );

  if(bShowBrower) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    Navigator.push(
      context,
      Transition(
          child: WebExplorer(
            title: "비밀번호",
            url: url,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
}

Future <void> webTest(BuildContext context, SessionData session) async {
  String url = getUrlParam(
    website: '$SERVER/appService/gotoUrl.do',
    data: {
      "returnUrl":"/dolbom/member/mypage.do",
      "jwtToken":session.AccessToken
    },
  );

  await Navigator.push(
    context,
    Transition(
        child: WebExplorer(
          title: "웹 테스트",
          url:url,
        ),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

// 우편번호 감색 팝업으로 크롬 브라우져 연결함.
Future <void> goRegist(BuildContext context, SessionData session) async {
  String url = getUrlParam(
    website: '$SERVER/dolbom/member/join-agree.do',
    data: {
      "returnUrl":"/dolbom/main.do",
      "jwtToken":session.AccessToken
    },
  );

  // 우편번호 감색 팝업으로 크롬 브라우져 연결함.
  launchUrl(
      Uri.parse(url),
      webViewConfiguration:const WebViewConfiguration(
        headers: {'User-Agent': USER_AGENT}
      ),
      mode: LaunchMode.externalApplication
  );
}

Future<void> goHomePage(BuildContext context, SessionData session) async {
  String url = getUrlParam(
    website: '$SERVER/appService/gotoUrl.do',
    data: {
      "returnUrl":"/dolbom/main.do",
      "jwtToken":session.AccessToken
    },
  );
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future <void> showWebsite(BuildContext context,
    SessionData session,
    String title,
    String targetUrl,
    bool bShowBrower, {
      Map<String,dynamic> param = const {},
    }
    ) async {

  //print(targetUrl);

  Map<String,dynamic> data = {
    "returnUrl":targetUrl,
    "jwtToken":session.AccessToken
  };

  if(param.isNotEmpty) {
    data.addAll(param);
  }
  String url = getUrlParam(
    website: '$SERVER/appService/gotoUrl.do',
    data: data,
  );

  if(bShowBrower) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    Navigator.push(
      context,
      Transition(
          child: WebExplorer(
            title: title,
            url: url,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
}

Future <void> registSite(BuildContext context, SessionData session, bool bShowBrower) async {
  String url = getUrlParam(
    website: '$SERVER/appService/gotoUrl.do',
    data: {
      "returnUrl":"/dolbom/member/join-agree.do",
      "jwtToken":session.AccessToken
    },
  );

  if(bShowBrower) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    Navigator.push(
      context,
      Transition(
          child: WebExplorer(
            title: "웹 테스트",
            url: url,
          ),
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
    );
  }
}

Future <void> doWriteSShare(BuildContext context, SessionData session,) async {
  showWebsite(context, session, "손오공공동돌봄체신청","/dolbom/pages/sonogong-dolbom-cmmnty/intrcn.do", false );
}

Future <void> doWriteSParent(BuildContext context, SessionData session) async {
  showWebsite(context, session, "공동육아나눔터 신청","/dolbom/cmmnty/nanum/agree.do", false );
}

Future <void> doWriteCareCrops(BuildContext context, SessionData session,) async {
  showWebsite(context, session, "돌봄봉사단 신청","/dolbom/cmmnty/srvc/agree.do", false );
}

Future <void> doWriteActCourse(BuildContext context, SessionData session,) async {
  showWebsite(context, session, "양성과정 신청","/dolbom/actvst/agree.do", false );
}

Future <void> doWriteSpace(BuildContext context, SessionData session,) async {
  showWebsite(context, session, "공간신청","/dolbom/spce/list.do", false );
}

Future <void> doActMyPage(BuildContext context, SessionData session, bool bExt) async {
  showWebsite(context, session, "돌돔활동가 페이지","/dolbom/pages/actvst/mypage.do", bExt );
}

Future <void> doApplyActCourse(BuildContext context, SessionData session,) async {
  showWebsite(context, session, "배달강좌 신청","/dolbom/edu/dlvr/list.do", false );
}