// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemRegSpace.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrSpace extends StatefulWidget {
  const MgrSpace({Key? key}) : super(key: key);

  @override
  State<MgrSpace> createState() => _MgrSpaceState();
}

class _MgrSpaceState extends State<MgrSpace> {
  List<ItemRegSpace> _itemList = [];
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
        title: const Text("공간 신청현황"),
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
                  await _reqSelect();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if(!_bready) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                Text("공간 신청내역", style: ItemBkB18,),
                Spacer(),
              ],
            ),
            ListView.builder(
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
            )
          ],
        ),
      ),
    );
  }

  Widget _showItem(ItemRegSpace item) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom:10),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 1, 5),
                child: Row(
                  children: [
                    const Spacer(),
                    Visibility(
                      visible: item.aplyStatus=="NORMAL",
                      child: SizedBox(
                        width: 80,
                        child: ButtonState(
                          padding: const EdgeInsets.all(8),
                          text: "신청취소",
                          borderColor: Colors.pink,
                          textStyle: const TextStyle(
                              fontSize: 13,
                              color: Colors.black
                          ),
                          onClick: () {
                            _doDelete(item);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),
            _rowItem("공간명", item.spceNm,false, false),
            _rowItem("신청자 이름", item.aplyNm,false, false),
            _rowItem("신청자 연락처", item.aplyTelno,false, false),
            _rowItem("희망 사용일", item.hopeDt,false, false),
            _rowItem("희망 시간대", "${item.hopeBgngTm.substring(0,5)} ~ ${item.hopeEndTm.substring(0,5)}",false, false),

            _rowItem("행사명", item.aplyEvent, false, false),
            _rowItem("처리상태", item.status(), true, true),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const LabelSize = 90.0;
    const rowHeight = 40.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BSG5, left: BSG5, right: BSG5,
          bottom: (bLast) ? BSG5 : BorderSide.none,),
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
                      padding: const EdgeInsets.all(1),
                      enable: false,
                      text: value,
                      //borderColor: Colors.amber,
                      textStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black
                      ),
                      onClick: () {},
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
          // ButtonState(
          //   padding: const EdgeInsets.all(15),
          //   enableColor: Colors.blueAccent,
          //   borderColor: Colors.blueAccent,
          //   enableTextColor: Colors.white,
          //   text: '신청하기',
          //   onClick: () {
          //     //_doEdit(true, "자녀 추가", ItemCareCrops());
          //   },
          // )
        ],
      ),
    );
  }

  void _doDelete(ItemRegSpace info) {
    showYesNoDialogBox(context: context, height: 240,
        title: "확인",
        message: "취소된 정보는 복구할 수 없습니다.\n신청내역을 취소하시겠습니까?\n",
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

  // 삭제
  Future <bool> _reqDel(ItemRegSpace info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/spce_cancel.do",
      params: { "aplySn": info.aplySn },
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
      method: "appService/member/spce.do",
      params: { "page" : 1, "countPerPage": 2 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemList = ItemRegSpace.fromSnapshot(content);
          } else {
            _itemList = [];
          }
        }
      },
    );
    setState(() {

    });
  }
}
