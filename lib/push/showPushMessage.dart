// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:io';

import 'package:daejeoni/common/buttonRoundRect.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/tap00_home/showCareList.dart';
import 'package:daejeoni/home/tap00_home/showNoticeList.dart';
import 'package:daejeoni/home/tap00_home/showProgramDetail.dart';
import 'package:daejeoni/home/tap00_home/showProgramList.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrActCourse.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrCareCrops.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrInstReserveCal.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSParent.dart';
import 'package:daejeoni/home/tapo5_myPage/mgrSShare.dart';
import 'package:daejeoni/push/localNotification.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemMessage.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class ShowPushMessage extends StatefulWidget {
  final bool bShowDetail;
  const ShowPushMessage({
    Key? key,
    required this.bShowDetail
  }) : super(key: key);

  @override
  State<ShowPushMessage> createState() => _ShowPushMessageState();
}

class _ShowPushMessageState extends State<ShowPushMessage> {

  bool _bReady = false;
  List<ItemPush> _itemList = [];
  late SessionData _session;
  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    int delay = 100;
    if (Platform.isAndroid) {
      delay = 30;
    }

    Future.delayed(Duration(milliseconds: delay), () async {
      notification.cancel();
      await _reqMessage();
      if (widget.bShowDetail) {
        if (_itemList.isNotEmpty && _itemList[0].pushTarget.isNotEmpty) {
          _pushDetail(_itemList[0].pushTarget);
        } else {
          setState(() {
            _bReady = true;
          });
        }
      } else {
        setState(() {
          _bReady = true;
        });
      }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("PUSH 알림"),
          leading: IconButton(
              icon: Image.asset(
                "assets/icon/top_back.png",
                height: app_top_size_back,
                fit: BoxFit.fitHeight,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Visibility(
              visible: true,
              child: IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 26,
                  ),
                  onPressed: () {
                    _reqMessage();
                  }),
            ),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          child: (_bReady ) ? Container(color: Colors.white, child: _renderBody()) : Container(),
        ));
  }

  Widget _renderBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: _itemList.length,
                itemBuilder: (context, index) {
                  return _itemMessage(_itemList[index]);
                }
            )
        ),
      ],
    );
  }

  Widget _itemMessage(ItemPush item) {
    final span=TextSpan(text:item.pushContent);
    final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width
    //print("tp.didExceedMaxLines=${tp.didExceedMaxLines}");
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //const Spacer(),
              Text(item.regDt.substring(0,19), style: ItemBkN12,),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:Text(item.pushTitle, style: ItemBkB15, maxLines: 3,
                textAlign:TextAlign.justify,
                overflow: TextOverflow.ellipsis,),
              ),
              const SizedBox(width: 10,),
              Visibility(
                visible: item.pushTarget.isNotEmpty,
                child: Container(
                  height: 28,
                  width: 60,
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: ButtonRoundRect(
                    enable: true,
                    radious:5,
                    text: '바로가기',
                    fontSize: 10,
                    textColor: Colors.white,
                    backgroundColor:const Color(0xFF589BBC),
                    borderColor:const Color(0xFF589BBC),
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    onClick: () {
                      _showDetail(item.pushTarget);
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,5,0,0),
            child: Text(item.pushContent,
                style: ItemBkN14, maxLines: (item.showMore) ? 44 : 3,
                textAlign:TextAlign.justify,
                overflow: TextOverflow.ellipsis),
          ),
          Visibility(
            visible:kDebugMode,
            child:Text(
              item.pushTarget, style: ItemR1B12, maxLines: 3,
              textAlign:TextAlign.justify,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Row(
            children: [
              const Spacer(),
              Visibility(
                  visible: tp.didExceedMaxLines,//!item.showMore,
                  child: TextButton(
                      onPressed: (){
                        setState(() {
                          item.showMore = !item.showMore;
                        });
                      },
                      child: Icon((item.showMore)
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_outlined)
                  )
              ),
              const Spacer(),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future <void> _pushDetail(String pushTarget) async {
    // board,601"
    // mypage,"
    pushTarget = pushTarget.replaceAll(",", "|");
    String target = pushTarget;
    String targetSn = pushTarget;
    var list = pushTarget.split("|");
    if(list.isNotEmpty) {
      target = list[0];
      if(list.length>1) {
        targetSn = list[1];
      }
    }

    // 부적절한 데이터인 경우.
    if(targetSn.isNotEmpty) {
      if(int.tryParse(targetSn)==null) {
        targetSn = "";
      }
    }

    if (kDebugMode) {
      print ("pushDetail:pushTarget=$pushTarget, target=$target, targetSn=$targetSn");
    }

    switch(target) {
      case "me":
        {
          if(!await ConfirmSigned(context, _session)) {
            return;
          }

          if(targetSn=="M1") {    // 돌봄공동체 신청내역
            Navigator.pushReplacement(context,
              Transition(child: const MgrSShare(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M2") { // 공동육아나눔터
            await Navigator.pushReplacement(context,
              Transition(child: const MgrSParent(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M3") { // 돌봄봉사단
            await Navigator.pushReplacement(context,
              Transition(child: const MgrCareCrops(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M4") { // 돌봄활동가 양성과정 신청내역
            await Navigator.pushReplacement(context,
              Transition(child: const MgrActCourse(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M5") { // 기관예약 신청내역
            await Navigator.pushReplacement(context,
              Transition(child: const MgrInstReserveCal(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          }
          break;
        }

      case "program":{
        if(targetSn.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            Transition(
                child: ShowProgramDetail(
                  eduSn: targetSn,
                ),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            Transition(
                child: const ShowProgramList(
                ),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
      }
      break;

      case "care": {
        if(targetSn.isNotEmpty) {
          String url = getUrlParam(
            website: '$SERVER/appService/talk_info.do',
            data: {
              //"returnUrl":targetUrl,
              "jwtToken": _session.AccessToken,
              "boardSn": targetSn
            },
          );

          Navigator.pushReplacement(
            context,
            Transition(
                child: WebExplorer(title: "상세보기", url: url,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            Transition(
                child: const ShowCareList(),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
      }
      break;

      case "board":
        if(targetSn.isNotEmpty) {
          String url = getUrlParam(
            website: '$SERVER/appService/notice_info.do',
            data: {
              //"returnUrl":targetUrl,
              "jwtToken":_session.AccessToken,
              "boardSn": targetSn
            },
          );

          Navigator.pushReplacement(
            context,
            Transition(
                child: WebExplorer(title: "상세보기", url: url,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            Transition(
                child: const ShowNoticeList(),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        break;
      default:
        {
          if(targetSn.isNotEmpty) {
            String url = getUrlParam(
              website: '$SERVER/appService/notice_info.do',
              data: {
                //"returnUrl":targetUrl,
                "jwtToken": _session.AccessToken,
                "boardSn": targetSn
              },
            );

            Navigator.pushReplacement(
              context,
              Transition(
                  child: WebExplorer(title: "상세보기", url: url,),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          }
          break;
        }
    }
  }
  Future <void> _showDetail(String pushTarget) async {
    // board,601"
    // mypage,"
    pushTarget = pushTarget.replaceAll(",", "|");
    String target = pushTarget;
    String targetSn = pushTarget;
    var list = pushTarget.split("|");
    if(list.isNotEmpty) {
      target = list[0];
      if(list.length>1) {
        targetSn = list[1];
      }
    }

    // 부적절한 데이터인 경우.
    if(targetSn.isNotEmpty) {
      if(int.tryParse(targetSn)==null) {
        targetSn = "";
      }
    }

    if (kDebugMode) {
      print ("pushDetail:pushTarget=$pushTarget, target=$target, targetSn=$targetSn");
    }

    switch(target) {
      case "me":
        {
          if(!await ConfirmSigned(context, _session)) {
            return;
          }

          if(targetSn=="M1") {    // 돌봄공동체 신청내역
            Navigator.push(context,
              Transition(child: const MgrSShare(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M2") { // 공동육아나눔터
            await Navigator.push(context,
              Transition(child: const MgrSParent(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M3") { // 돌봄봉사단
            await Navigator.push(context,
              Transition(child: const MgrCareCrops(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M4") { // 돌봄활동가 양성과정 신청내역
            await Navigator.push(context,
              Transition(child: const MgrActCourse(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M5") { // 기관예약 신청내역
            await Navigator.push(context,
              Transition(child: const MgrInstReserveCal(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          }
          break;
        }

      case "program":{
        if(targetSn.isNotEmpty) {
          Navigator.push(
            context,
            Transition(
                child: ShowProgramDetail(
                  eduSn: targetSn,
                ),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.push(
            context,
            Transition(
                child: const ShowProgramList(
                ),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
      }
      break;

      case "care": {
        if(targetSn.isNotEmpty) {
          String url = getUrlParam(
            website: '$SERVER/appService/talk_info.do',
            data: {
              //"returnUrl":targetUrl,
              "jwtToken": _session.AccessToken,
              "boardSn": targetSn
            },
          );

          Navigator.push(
            context,
            Transition(
                child: WebExplorer(title: "상세보기", url: url,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.push(
            context,
            Transition(
                child: const ShowCareList(),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
      }
      break;

      case "board":
        if(targetSn.isNotEmpty) {
          String url = getUrlParam(
            website: '$SERVER/appService/notice_info.do',
            data: {
              //"returnUrl":targetUrl,
              "jwtToken":_session.AccessToken,
              "boardSn": targetSn
            },
          );

          Navigator.push(
            context,
            Transition(
                child: WebExplorer(title: "상세보기", url: url,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        else {
          Navigator.push(
            context,
            Transition(
                child: const ShowNoticeList(),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
        }
        break;
      default:
        {
          if(targetSn.isNotEmpty) {
            String url = getUrlParam(
              website: '$SERVER/appService/notice_info.do',
              data: {
                //"returnUrl":targetUrl,
                "jwtToken": _session.AccessToken,
                "boardSn": targetSn
              },
            );

            Navigator.push(
              context,
              Transition(
                  child: WebExplorer(title: "상세보기", url: url,),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          }
          break;
        }
    }
  }
  /*
  Future<void> _showDetail(String pushTarget) async {
    // board,601"
    // mypage,"
    pushTarget = pushTarget.replaceAll(",", "|");
    String target = pushTarget;
    String targetSn = pushTarget;
    var list = pushTarget.split("|");
    if(list.isNotEmpty) {
      target = list[0];
      if(list.length>1) {
        targetSn = list[1];
      }
    }

    // 부적절한 데이터인 경우.
    if(targetSn.isNotEmpty) {
      if(int.tryParse(targetSn)==null) {
        targetSn = "";
      }
    }

    if (kDebugMode) {
      print ("pushDetail:pushTarget=$pushTarget, target=$target, targetSn=$targetSn");
    }

    switch(target) {
      case "me":
        {
          if(!await ConfirmSigned(context, _session)) {
            return;
          }

          if(targetSn=="M1") {    // 돌봄공동체 신청내역
            Navigator.push(context,
              Transition(child: const MgrSShare(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M2") { // 공동육아나눔터
            await Navigator.push(context,
              Transition(child: const MgrSParent(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M3") { // 돌봄봉사단
            await Navigator.push(context,
              Transition(child: const MgrCareCrops(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M4") { // 돌봄활동가 양성과정 신청내역
            await Navigator.push(context,
              Transition(child: const MgrActCourse(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          } else if(targetSn=="M5") { // 기관예약 신청내역
            await Navigator.push(context,
              Transition(child: const MgrInstReserveCal(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
            );
          }
            break;
        }

      case "program":{
        Navigator.push(
          context,
          Transition(
              child: ShowProgramDetail(
                eduSn: targetSn,
              ),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
        );
        }
        break;

      case "board":
      default:
        {
          String url = getUrlParam(
            website: '$SERVER/appService/notice_info.do',
            data: {
              //"returnUrl":targetUrl,
              "jwtToken":_session.AccessToken,
              "boardSn": targetSn
            },
          );

          Navigator.push(
            context,
            Transition(
                child: WebExplorer(title: "상세보기", url: url,),
                transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
          );
          break;
        }
    }
  }
  */
  // { "page" : 1, "countPerPage": 50, "pushToken": "abcdaaa", "pushTopic":"PAR,ALL,ACT" },
  Future<void> _reqMessage() async {
    _showProgress(true);
    await Remote.apiPost(
        context: context,
        session: _session,
        method: "appService/pushNtcn/list.do",
        params: {
          "page" : 1,
          "countPerPage": 30,
          "pushToken": _session.FirebaseToken,
          "pushTopic": _session.FireBaseTopics
        },
        onError: (String error) {},
        onResult: (dynamic data) async {
          if (kDebugMode) {
            var logger = Logger();
            logger.d(data);
          }
          var content = data['data']['list'];
          if (content != null) {
            _itemList = ItemPush.fromSnapshot(content);
          } else {
            _itemList = [];
          }
        }
    );

    if(_itemList.isNotEmpty) {
      await _session.updateNoticeStatus(true, _itemList[0].pushNtcnSn.toString());
    }
    _showProgress(false);
  }
}
