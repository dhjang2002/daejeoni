// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/common/InputForm.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PostPush extends StatefulWidget {
  const PostPush({Key? key}) : super(key: key);

  @override
  State<PostPush> createState() => _PostPushState();
}

class _PostPushState extends State<PostPush> {
  final List<MenuButtonCheckItem> topicItems = [
    MenuButtonCheckItem(text: "모든회원",   tag:"ALL",    select: false, control: false),
    MenuButtonCheckItem(text: "부모회원",   tag:"PAR",   select: false),
    MenuButtonCheckItem(text: "기관회원",   tag:"INS",   select: false),
    MenuButtonCheckItem(text: "돌봄활동가", tag:"ACT",  select: false),
    MenuButtonCheckItem(text: "개발자",    tag:"DEV",  select: true),
  ];
  String title="";
  String message="";
  String topics = "DEV";
  String action = "board|577";

  late SessionData _session;
  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    title = "알림 테스트 - ${DateTime.now().toString().substring(0,19)}";
    message = "테스트 발송 메시지입니다.";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PUSH 보내기"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0.5,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),

      // 601
      body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
          child:Column(
          children: [
          Expanded(child: _renderBody()),
          Visibility(
            visible: true,
            child:ButtonSingle(
                visible: true,
                isBottomPading: false,
                text: "PUSH 발송",
                enable: true,//_bEnable,
                onClick: () {
                  _doPostPush(title, message, topics, action);
                  Navigator.pop(context);
                }
            ),
          ),
          //const SizedBox(height: 20,),
          ],
        )
      ),
    );
  }

  Widget _renderBody() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: const Text("* 발송대상(Topic):", style: ItemBkB14,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: MenuButtonCheck(
              modeSelect:true,
              items: topicItems,
              crossAxisCount:5,
              crossAxisSpacing:3,
              childAspectRatio:1.9,
              btnColor:Colors.blueAccent,
              borderColor:Colors.blueAccent,
              textSelColor:Colors.white,
              onAll: (MenuButtonCheckItem item){},
              onChange: (List<MenuButtonCheckItem> items) {
                topics = "";
                bool checked = false;
                for (var element in items) {
                  if(!element.control && element.select) {
                    checked = true;
                  }
                  if(element.select) {
                    if(topics.isNotEmpty) {
                      topics = "$topics,";
                    }
                    topics += element.tag.toString();
                  }
                }
                //items[0].select = !checked;
                setState(() {});
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("*︎ 타이틀:", style: ItemBkB14,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: InputForm(
              onlyDigit: false,
              hintText: '타이틀을 입력하세요',
              valueText: title,
              maxLines: 1,
              onChange: (value) {
                title = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("* 메시지:", style: ItemBkB14,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: InputForm(
              onlyDigit: false,
              hintText: '메시지를 입력하세요',
              valueText: message,
              maxLines: 10,
              minLines: 5,
              onChange: (value) {
                message = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text('* Action: "{category|sn}"', style: ItemBkB14,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: InputForm(
              onlyDigit: false,
              hintText: '{catagory|targetSn}',
              valueText: action,
              maxLines: 1,
              onChange: (value) {
                action = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text(
                '- 단순알림(상세정보 없음):"blank"\n'
                '- 공지사항: "board|577"\n'
                '- 양육정보: "care|584"\n'
                '- 프로그램: "program|37"\n'
                '- 손오공돌봄공동체 신청내역: "me|M1"\n'
                '- 공동육아나눔터 신청내역: "me|M2"\n'
                '- 돌봄봉사단 신청내역: "me|M3"\n'
                '- 돌봄활동가 양성과정 신청내역: "me|M4"\n'
                '- 기관 신청내역: "me|M5"',
              style: ItemG1N14,
            ),
          ),
        ],
      ),
    );
  }

  Future <void> _doPostPush(String title, String message, String topic, String target) async {
    _session.bOnNotice = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/pushNtcn/send_push.do",
      params: {
        "title":   title,
        "message": message,
        "topic":   topic,
        "token":   "",
        "target":  target,
      },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        showToastMessage(data['message']);
      },
    );
  }
}
