// ignore_for_file: file_names

import 'dart:io';

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/models/infoSpace.dart';
import 'package:daejeoni/models/itemSpace.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:daejeoni/webview/WebExplorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

class ShowSpaceDetail extends StatefulWidget {
  final ItemSpace item;
  const ShowSpaceDetail({
    Key? key,
    required this.item
  }) : super(key: key);

  @override
  State<ShowSpaceDetail> createState() => _ShowSpaceDetailState();
}

class _ShowSpaceDetailState extends State<ShowSpaceDetail> {
  late SessionData _session;
  bool _bready = false;
  bool _bWaiting = false;
  //bool _bAvailable = true;

  InfoSpace _info = InfoSpace();
  
  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    int delay = 300;
    if (Platform.isAndroid) {
      delay = 30;
    }
    Future.delayed(Duration(milliseconds: delay), () async {
      await _reqInfo();
      setState(() {
        _bready = true;
      });
    });
    super.initState();
  }

  _showProgress(bool flag) {
    setState(() {
      _bWaiting = flag;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                  child: CustomScrollView(
                    slivers: [
                      _renderSliverAppbar(),
                      _renderContent(),
                      //_renderApply(),
                      _renderDesc(),
                      _renderShare(),
                      _renderApply(),
                    ],
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                      visible: _bWaiting || !_bready,
                      child: Container(
                        color: const Color(0x1f000000),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                  )
              ),
            ],
          ),
        ),
    );
  }

  SliverAppBar _renderSliverAppbar() {
    return SliverAppBar(
      //key: _posKeyHome,
      floating: true,
      centerTitle: true,
      //pinned: true,
      title: const Text("공간지원"),
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
          visible: true,
          child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
                size: 26,
              ),
              onPressed: () async {
                await _reqInfo();
                setState(() {});
              }),
        ),
      ],
      //expandedHeight: 60
    );
  }

  SliverToBoxAdapter _renderContent() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,20,10,20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _itemCardProgramWide(_info),
          ],
        ),
      ),
    );
  }

  Widget _itemCardProgramWide(InfoSpace item) {
    //final double imageWidth  = MediaQuery.of(context).size.width*0.95;
    //final double imageHeight = imageWidth*1.58;
    final double picHeight = MediaQuery.of(context).size.width * 0.8;
    return GestureDetector(
      onTap: () {
        //_doShowSpaceDetail(item);
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/icon/calendar.png",
                      height: 18, fit: BoxFit.fitHeight,
                    ),

                    const SizedBox(width: 5,),
                    Expanded(child: Text(_info.spceNm, style: ItemBkB18,))

                  ],
                ),
              ),
              Container(
                height: picHeight,
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: (_bready) ? CardPhotos(
                  fit : BoxFit.fill,
                  items: _info.photo_items,
                ) : Container(),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: Html(data: _info.spceDc),
              ),

              // 3. 프로그램 구성
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(0,30,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("공간정보", style: ItemBkB18,),
                    const SizedBox(height: 20,),
                    _rowItem("공간이름", item.spceNm , false, false),
                    _rowItem("공간면적", item.spceAr , false, false),
                    _rowItem("수용인원", item.spcePerson , false, false),
                    _rowItem("부대시설", item.spceEqpmn , false, false),
                    _rowItemHtml("가능시간", item.spceTm , false, false),
                    _rowItem("연락처", item.spceTelno , false, true),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const szLabel = 70.0;
    //const rowHeight = 52.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BSG5,
          left: BSG5,
          right: BSG5,
          bottom: (bLast)
              ? BSG5
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: szLabel,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   border: const Border(right: BSG5,),
            // ),
            child: Text(label, style: ItemBkN14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10,10,10,10),
                  alignment: Alignment.centerLeft,
                  //height: rowHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BSG5,),
                  ),
                  child: Text(value, style: ItemBkN14,),
                )
            ),
          ),

          Visibility(
            visible: useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:20),
                  alignment: Alignment.centerLeft,
                  //height: rowHeight,
                  color: Colors.white,
                  child: SizedBox(
                    width: 80,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(8),
                      enable: false,
                      text: value,
                      //borderColor: Colors.amber,
                      textStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black
                      ),
                      onClick: () {
                        //_doEdit(false, "정보수정", item);
                      },
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
  Widget _rowItemHtml(String label, String value, bool useState, bool bLast) {
    const labelSize = 70.0;
    //const rowHeight = 52.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BSG5,
          left: BSG5,
          right: BSG5,
          bottom: (bLast)
              ? BSG5
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            //height: rowHeight,
            padding: const EdgeInsets.only(left: 5),
            width: labelSize,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
              //border: const Border(right: BSG5,),
            ),
            child: Text(label, style: ItemBkN14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:5),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BSG5,),
                  ),
                  //height: rowHeight,
                  //color: Colors.white,
                  child: Html(data: value),
                )
            ),
          ),

          Visibility(
            visible: useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:20),
                  alignment: Alignment.centerLeft,
                  //height: rowHeight,
                  color: Colors.white,
                  child: SizedBox(
                    width: 80,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(8),
                      enable: false,
                      text: value,
                      //borderColor: Colors.amber,
                      textStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black
                      ),
                      onClick: () {
                        //_doEdit(false, "정보수정", item);
                      },
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _renderApply() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,0,10,50),
        child: Column(
          children: [
            Container(
              //margin: EdgeInsets.fromLTRB(10, 50, 10, 50),
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              //color: Colors.amber,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ButtonState(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        text: '진행문의',
                        enableColor: Colors.white,
                        borderColor: Colors.black,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: -0.5
                        ),
                        onClick: () {
                          callPhone(_info.spceTelno);
                          //_doApply(widget.item);
                        },
                      )
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                      flex: 1,
                      child: ButtonState(
                        enable: _info.isAvailable(),
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        text: '대여신청',
                        enableColor: const Color(0xFF59BB9C),
                        borderColor: _info.isAvailable() ? const Color(0xFF59BB9C): Colors.grey,
                        textStyle: TextStyle(
                            color: _info.isAvailable() ? Colors.white:Colors.black,
                            fontSize: 14,
                            letterSpacing: -0.5
                        ),
                        onClick: () {
                          if(_info.isAvailable()) {
                            _doApply(_info);
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  SliverToBoxAdapter _renderShare() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0,10,0,50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                IconButton(
                  onPressed: (){},
                  icon: Image.asset(
                    "assets/icon/share_9351.png",
                    width: 36,
                    height: 36,
                    //color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(15),
              child: const Center(
                  child: Text("함께하고 싶은 공간정보를 공유하세요.", style: ItemBkN14)
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  SliverToBoxAdapter _renderApply() {
    final padding = MediaQuery.of(context).size.width * 0.25;
    return SliverToBoxAdapter(
      child: Container(
        //physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0,20,0,50),
        child: Column(
          children: [
            Container(
              //margin: EdgeInsets.fromLTRB(left, top, right, bottom),
              padding: EdgeInsets.fromLTRB(padding,0,padding,10),
              child: ButtonSingle(
                text: '대여 신청하기',
                isBottomPading: false,
                onClick: () {
                  _doApply(_info);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  */
  SliverToBoxAdapter _renderDesc() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10,20,10,30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0,0,0,10),
              child: const Text("유의사항", style: ItemBkB18,),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: Html(data: _info.spceEtc),
            ),

          ],
        ),
      ),
    );
  }

  Future <void> _doApply(InfoSpace info) async {
    if(await ConfirmSigned(context, _session)) {
      String url = getUrlParam(
        website: '$SERVER/appService/spce_apply.do',
        data: {
          "jwtToken": _session.AccessToken,
          "spceSn": info.spceSn,
        },
      );
      Navigator.push(
        context,
        Transition(
            child: WebExplorer(title: "신청하기", url: url,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
      );
    }
  }

  // 공간대여
  Future<void> _reqInfo() async {
    _showProgress(true);
    await Remote.apiPost(
        context: context,
        session: _session,
        method: "appService/spce/info.do",
        params: {"spceSn": widget.item.spceSn},
        onResult: (dynamic data) {
          // if (kDebugMode) {
          //   var logger = Logger();
          //   logger.d(data);
          // }
          if (data['status'].toString() == "200")
          {
            var content = data['data'];
            if(content!=null) {
              _info = InfoSpace.fromJson(content);
            } else {
              //_spaceList = [];
            }
          }
        },
        onError: (String error) {}
    );
    _showProgress(false);
  }
}
