// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSParentInfo.dart';
import 'package:daejeoni/models/ItemSParent.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrSParent extends StatefulWidget {
  const MgrSParent({Key? key}) : super(key: key);

  @override
  State<MgrSParent> createState() => _MgrSParentState();
}

class _MgrSParentState extends State<MgrSParent> {
  List<ItemSParent> _itemList = [];
  late SessionData _session;
  bool _bready = false;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      await _reqSelect();
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
        elevation: 0.5,
        title: const Text("공동육아나눔터 신청내역"),
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
                  await _reqSelect();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: const Row(
                children: [
                  Text("공동육아나눔터 신청내역", style: ItemBkB18,),
                  Spacer(),
                ],
              )
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                itemCount: _itemList.length+1,
                itemBuilder: (context, index) {
                  if(index<_itemList.length) {
                    return _showItem(_itemList[index]);
                  } else {
                    return _addButton();
                  }
                }
             ),
          )
        ],
      ),
    );
  }
  Widget _showItem(ItemSParent item) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10,10,10,0),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 1, 5),
                child: Row(
                  children: [
                    const Spacer(),
                    Visibility(
                      visible: _itemList.isNotEmpty,
                      child: SizedBox(
                        width: 70,
                        child: ButtonState(
                          padding: const EdgeInsets.all(8),
                          text: "수정",
                          borderColor: Colors.grey,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          ),
                          onClick: () {
                            _doEdit(false, "정보수정", item);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),
            _rowItem("소식 수신여부", cvtYesNo(item.newsRcptnYn),false, false),
            _rowItem("활동주기", item.getCycle(),false, false),
            _rowItem("희망\n커뮤니티 친구", item.geFriendType(),false, false),
            _rowItem("신 청 일", item.regDt,false, false),
            _rowItem("승인여부", cvtAprove(item.aprvYn), true, true),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }
  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const LabelSize = 110.0;
    const rowHeight = 42.0;
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
                  padding: const EdgeInsets.only(left:20),
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
                  padding: const EdgeInsets.only(left:20),
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

  Widget _addButton() {
    if(!_bready) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Visibility(
            visible: _itemList.isEmpty,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                child: const Text("등록된 정보가 없습니다."),
              )
          ),
          // ButtonState(
          //   padding: const EdgeInsets.all(15),
          //   enableColor: Colors.blueAccent,
          //   borderColor: Colors.blueAccent,
          //   enableTextColor: Colors.white,
          //   text: '신청하기',
          //   onClick: () {
          //     //_doEdit(true, "자녀 추가", ItemSParent());
          //   },
          // )
        ],
      ),
    );
  }

  void _doDelete(ItemSParent info) {
    showYesNoDialogBox(context: context, height: 240,
        title: "확인",
        message: "삭제된 정보는 복구할 수 없습니다.\n정보를 삭제하시겠습니까?\n",
        onResult: (bYes) async {
          if(bYes) {
            bool flag = await _reqDel(info);
            if(flag) {
              await _reqSelect();
              showToastMessage("삭제되었습니다.");
            }
          }
        }
    );
  }

  void _doEdit(bool bAdd, String title, ItemSParent info) {
    showSParentInfo(context: context, title: title, info: info,
        onResult: (bool bDirty, ItemSParent info) async {
            if(bDirty) {
              bool flag = await _reqEdit(bAdd, info);
              if(flag) {
                await _reqSelect();
                showToastMessage("수정되었습니다.");
              }
            }
        }
    );
  }

  // 삭제
  Future <bool> _reqDel(ItemSParent info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs_delete.do",
      params: { "aplcntSn": info.aplcntSn },
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
  Future <bool> _reqEdit(bool bAdd, ItemSParent info) async {
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
  Future <void> _reqSelect() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/cmmnty.do",
      params: { "category" : "my-nanum" },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemList = ItemSParent.fromSnapshot(content);
            //_itemList = [];
            setState(() {

            });
          } else {
            _itemList = [];
          }
        }
      },
    );
  }
}
