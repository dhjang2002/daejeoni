// ignore_for_file: file_names, constant_identifier_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSShareInfo.dart';
import 'package:daejeoni/models/ItemSCard.dart';
import 'package:daejeoni/models/ItemSShare.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/Launcher.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrSShare extends StatefulWidget {
  const MgrSShare({Key? key}) : super(key: key);

  @override
  State<MgrSShare> createState() => _MgrSShareState();
}

class _MgrSShareState extends State<MgrSShare> {
  List<ItemSShare>  _infoList = [];
  List<ItemSCard>   _cardList = [];
  late SessionData _session;
  bool _bready = false;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      await _reqSelectInfo();
      await _reqSelectCard();
      setState(() {
        _bready = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("손오공돌봄공동체"),
        elevation: 0.5,
        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26,),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        actions: [
          // 새로고침
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(Icons.refresh_outlined, size: app_top_size_refresh,),
                onPressed: () async {
                  await _reqSelectInfo();
                  await _reqSelectCard();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildDrag() {
    return DraggableScrollableSheet(
        builder: (context, controller) {
          return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _infoList.length+1,
          itemBuilder: (context, index) {
            if(index<_infoList.length) {
              return _showInfoItem(_infoList[index]);
            } else {
              if(_infoList.isEmpty) {
                return _addButton(true);
              }
              else {
                return Container();
              }
            }
          }
      );
        }
    );
  }
  Widget _buildBody() {
    if(!_bready) {
      return Container();
    }

    String sid  = "";
    if(_infoList.isNotEmpty) {
      sid = _infoList[0].sonogongId;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: Row(
                  children: [
                    const Text("손오공돌봄공동체 신청내역", style: ItemBkB18,),
                    const Spacer(),
                    Visibility(
                      visible: _infoList.isNotEmpty,
                      child: SizedBox(
                        width: 60,
                        child: ButtonState(
                          padding: const EdgeInsets.all(5),
                          text: "수정",
                          borderColor: Colors.grey,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          ),
                          onClick: () {
                            _doEdit(false, "정보수정", _infoList[0]);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),

            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _infoList.length+1,
                itemBuilder: (context, index) {
                  if(index<_infoList.length) {
                    return _showInfoItem(_infoList[index]);
                  } else {
                    if(_infoList.isEmpty) {
                      return _addButton(true);
                    }
                    else {
                      return Container();
                    }
                  }
                }
            ),

            Visibility(
              visible: (_infoList.isNotEmpty),
              child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("손오공돌봄공동체 발급키", style: ItemBkB18,),
                          const Spacer(),
                          Visibility(
                            visible: _infoList.isNotEmpty,
                            child: SizedBox(
                              width: 80,
                              child: ButtonState(
                                padding: const EdgeInsets.all(8),
                                text: "공유하기",
                                enableColor: const Color(0xFF7CB9B1),
                                borderColor: const Color(0xFF7CB9B1),
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                ),
                                onClick: () {
                                  _onShare(_infoList[0].sonogongId);
                                  //Clipboard.setData(ClipboardData(text: _infoList[0].sonogongId));
                                  //showToastMessage("복사되었습니다.");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),

            Visibility(
              visible: _infoList.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BSG5,
                    left: BSG5,
                    right: BSG5,
                    bottom: BSG5
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  sid,
                  style: ItemR1B16,
                ),
              ),
            ),

            Visibility(
              visible: _infoList.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 10, 5, 20),
                //width: 80,
                child: ButtonState(
                  padding: const EdgeInsets.all(15),
                  text: "발급키 복사",
                  enableColor: const Color(0xFFF4C423),
                  borderColor: const Color(0xFFF4C423),
                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                  onClick: () {
                    Clipboard.setData(ClipboardData(text: _infoList[0].sonogongId));
                    showToastMessage("복사 되었습니다.");
                  },
                ),
              ),
            ),

            //const Divider(),
            // 손오공돌봄공동체 형성관리카드
            Container(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: const Text("손오공돌봄공동체 형성관리카드", style: ItemBkB18,),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cardList.length+1,
                itemBuilder: (context, index) {
                  if(index<_cardList.length) {
                    return _showCardItem(_cardList[index]);
                  } else {
                    return _addButton(false);
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _showInfoItem(ItemSShare item) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(5,10,5,10),
        child: Column(
          children: [
            _rowItem("소식 수신 여부", cvtYesNo(item.newsRcptnYn),false, false),
            _rowItem("손・오・공\n커뮤니티 가입", cvtYesNo(item.sonogongCmmntyJoin),false, false),
            _rowItem("별난놀이터이용", cvtYesNo(item.strngPlygrUse),false, false),
            _rowItem("소속된\n커뮤니티 유무", cvtYesNo(item.psitnCmmnty),false, false),
            _rowItem("희망\n커뮤니티 친구", item.geFriendType(),false, false),
            _rowItem("신 청 일", item.regDt, false, false),
            _rowItem("승인여부", cvtAprove(item.aprvYn), true, true),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const LabelSize = 110.0;
    const rowHeight = 41.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
            height: rowHeight,
            width: LabelSize,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BSG5,),
            ),
            child: Text(label, style: ItemBkN14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
              child: Container(
                padding: const EdgeInsets.only(left:10),
                alignment: Alignment.centerLeft,
                height: rowHeight,
                color: Colors.white,
                child: Text(value, style: ItemBkN14,),
              )
            ),
          ),

          Visibility(
            visible: useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:10),
                  alignment: Alignment.centerLeft,
                  height: rowHeight,
                  color: Colors.white,
                  child: SizedBox(
                    width: 80,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(8),
                      enable: false,
                      text: value,
                      disableColor: Colors.grey[200],
                      borderColor: Colors.grey[200],
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

  Widget _showCardItem(ItemSCard item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(5,10,5,10),
        child: Column(
          children: [
            _rowItem("공동체명", item.dolbomCmmntyNm,false, false),
            _rowItem("돌봄공공체 유형", item.dolbomCmmntyTy,false, false),
            _rowItem("지원여부", item.getSupport(),false, false),
            _rowItem("신 청 일", item.regDt, false, false),
            _rowItem("승인여부", cvtAprove(item.aprvYn), true, true),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _addButton(bool bShow) {
    if(!_bready) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Visibility(
            visible: _cardList.isEmpty,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text("등록된 정보가 없습니다."),
              )
          ),
          // Visibility(
          //     visible: bShow,
          //     child: ButtonState(
          //   padding: const EdgeInsets.all(15),
          //   enableColor: Colors.blueAccent,
          //   borderColor: Colors.blueAccent,
          //   enableTextColor: Colors.white,
          //   text: '신청하기',
          //   onClick: () {
          //     //_doEdit(true, "자녀 추가", ItemSShare());
          //   },
          // )
          // )
          //
        ],
      ),
    );
  }

  Future<void> _onShare(String value) async {
    String subject = "";
    await shareInfo(subject: subject, text: value, imagePaths: []);
  }

  void _doDelete(ItemSShare info) {
    showYesNoDialogBox(context: context, height: 240,
        title: "확인",
        message: "삭제된 정보는 복구할 수 없습니다.\n정보를 삭제하시겠습니까?\n",
        onResult: (bYes) async {
          if(bYes) {
            bool flag = await _reqDel(info);
            if(flag) {
              await _reqSelectInfo();
              await _reqSelectCard();
              showToastMessage("삭제되었습니다.");
            }
          }
        }
    );
  }

  void _doEdit(bool bAdd, String title, ItemSShare info) {
    showSShareInfo(context: context,
        title: title,
        info: info,
        onResult: (bool bDirty, ItemSShare info) async {
            if(bDirty) {
              bool flag = await _reqEdit(bAdd, info);
              if(flag) {
                await _reqSelectInfo();
                showToastMessage("수정되었습니다.");
              }
            }
        }
    );
  }

  // 삭제
  Future <bool> _reqDel(ItemSShare info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs_delete.do",
      params: { "parntSn": info.aplcntSn },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          flag = true;
        } else {
          showToastMessage(data['message']);
        }
      },
    );
    return flag;
  }

  // 수정/추가
  Future <bool> _reqEdit(bool bAdd, ItemSShare info) async {
    bool flag = false;
    String method;
    if(bAdd) {
      method = "appService/member/childs_insert.do";
    } else {
      method = "appService/member/my_sonogong_update.do";
    }
    await Remote.apiPost(
      context: context,
      session: _session,
      method: method,
      params: info.toMap(),
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          flag = true;
        } else {
          showToastMessage(data['message']);
        }
      },
    );
    return flag;
  }

  // 조회
  Future <void> _reqSelectInfo() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/cmmnty.do",
      params: { "category" : "my-sonogong" },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['info'];
          if(content != null) {
            _infoList = [ItemSShare.fromJson(content)];
            //_infoList = [];
          } else {
            _infoList = [];
          }
        }
      },
    );
    setState(() {

    });
  }

  Future <void> _reqSelectCard() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/cmmnty.do",
      params: { "category" : "my-sonogong-group"},
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _cardList = ItemSCard.fromSnapshot(content);
            //_cardList = [];

          } else {
            _cardList = [];
          }
        }
      },
    );
    setState(() {

    });
  }
}
