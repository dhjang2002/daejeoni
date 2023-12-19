
import 'package:daejeoni/home/auth/login.dart';
import 'package:daejeoni/home/tap00_home/showProgramDetail.dart';
import 'package:daejeoni/home/tap01_inst/instDetailView.dart';
import 'package:daejeoni/home/tap02_sos/sosDetail.dart';
import 'package:daejeoni/home/tap03_experience/expDetail.dart';
import 'package:daejeoni/models/ItemContent.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/push/showPushMessage.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';

void goBack(BuildContext context) {
  Navigator.of(context).pop(false);
}

void goHome(BuildContext context) {
  //Navigator.of(context).pop(false);
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void goPushHome(BuildContext context) {
  //Navigator.of(context).pop(false);
  //Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.push(
    context,
    Transition(
        child: const ShowPushMessage(bShowDetail: true,),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

void goMyHome(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void goSessionInvalid(BuildContext context) {
  //Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.push(
    context,
    Transition(
        child: const Login(),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

Future <void> pushContentFromId(BuildContext context, SessionData session, String contentOid) async {
  ItemContent? item = await getItem(context, session, contentOid);
  if(item != null) {
    pushContent(context,  item, "pushContentFromId()");
  }
}

Future <void> pushContent(BuildContext context, ItemContent item, String from) async {
  if (kDebugMode) {
    print("pushContent($from): === > ${item.content_type}");
  }

  switch(item.content_type) {
    case "SOS":
      Navigator.push(
          context,
          Transition(
              child: SosDetail(title:"돌봄SOS",content_oid: item.content_oid,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      break;
    case "MAP":
      Navigator.push(
          context,
          Transition(
              child: ExpDetail(title:"체험MAP", content_oid: item.content_oid,),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      break;
    case "INS":
      Navigator.push(
          context,
          Transition(
              child: InstDetailView(title:"돌봄기관",insttSn: item.content_oid.toString(),),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      break;

    case "PRG":
      Navigator.push(
        context,
        Transition(
            child: ShowProgramDetail(
              item: null,
              eduSn:item.content_oid.toString(),
            ),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      );

      // Navigator.push(
      //     context,
      //     Transition(
      //         child: InstDetailView(title:"돌봄기관",insttSn: item.content_oid.toString(),),
      //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      break;
  }
}

Future <ItemContent?> getItem(BuildContext context, SessionData session, String contentOid) async {
  ItemContent? content;
  await Remote.apiPost(
    context: context,
    session: session,
    method: "appService/map/detail.do",
    params: {
      "mapSn" : "10",
    },
    onError: (String error) {

    },
    onResult: (dynamic data) {
      if (kDebugMode) {
        var logger = Logger();
        logger.d(data);
      }
      var content = data['data'];
      if(content != null) {
        List list = [];
        if (content is List) {
          list = ItemContent.fromMapSnapshot(content);
        }
        else {
          list = ItemContent.fromMapSnapshot([content]);
        }

        if(list.isNotEmpty) {
          content = list[0];
        }
      }
    },
  );

  return content;
}

