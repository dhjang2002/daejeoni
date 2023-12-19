// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemInstReserve.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MgrInstReserve extends StatefulWidget {
  const MgrInstReserve({Key? key}) : super(key: key);

  @override
  State<MgrInstReserve> createState() => _MgrInstReserveState();
}

class _MgrInstReserveState extends State<MgrInstReserve> {
  List<ItemInstReserve> _itemList = [];
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
        title: const Text("기관 신청현황"),
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
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
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

  Widget _showItem(ItemInstReserve item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0,0,0,10),
        child: Column(
          children: [
            _rowItem("No", item.insttResveSn,false, false),
            _rowItem("기관명", item.insttNm,false, false),
            _rowItem("예약일자", item.insttResveDt,false, false),
            _rowItem("아동 이름", item.insttResveChildNm, false, false),
            _rowItem("아동 성별", item.sex(), false, false),
            _rowItem("아동 생년월일", item.insttResveChldrnBrdt, false, false),
            _rowItem("신청일자", item.insttResveOperTm, false, false),
            _rowItem("유형", item.type(), false, false),
            _rowItem("상태", item.status(), true, true),
            //_rowItem("출결", "", false, false),
            _rowItem("관리", "예약취소", true, true),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const LabelSize = 100.0;
    const rowHeight = 40.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
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
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: const Border(right: BSG5,),
            ),
            child: Text(label, style: ItemBkB14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:20),
                  alignment: Alignment.centerLeft,
                  height: rowHeight,
                  color: Colors.white,
                  child: Text(value, style: ItemBkN16,),
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
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                child: const Text("등록된 정보가 없습니다."),
              )
          ),
          ButtonState(
            padding: const EdgeInsets.all(15),
            enableColor: Colors.blueAccent,
            borderColor: Colors.blueAccent,
            enableTextColor: Colors.white,
            text: '신청하기',
            onClick: () {
              //_doEdit(true, "자녀 추가", ItemInstReserve());
            },
          )
        ],
      ),
    );
  }

  void _doDelete(ItemInstReserve info) {
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

  void _doEdit(bool bAdd, String title, ItemInstReserve info) {
    // showChildInfo(context: context, title: title, info: info,
    //     onResult: (bool bDirty, ItemInstReserve info) async {
    //         if(bDirty) {
    //           bool flag = await _reqEdit(bAdd, info);
    //           if(flag) {
    //             await _reqSelect();
    //             showToastMessage("수정되었습니다.");
    //           }
    //         }
    //     }
    // );
  }

  // 삭제
  Future <bool> _reqDel(ItemInstReserve info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs_delete.do",
      params: { "parntSn": info.insttResveSn },
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
  Future <bool> _reqEdit(bool bAdd, ItemInstReserve info) async {
    bool flag = false;
    String method;
    if(bAdd) {
      method = "appService/member/childs_insert.do";
    } else {
      method = "appService/member/childs_update.do";
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
      method: "appService/member/instt.do",
      params: { "page" : 1, "countPerPage": 100 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemList = ItemInstReserve.fromSnapshot(content);
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
