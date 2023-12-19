// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemRegProgram.dart';
import 'package:daejeoni/models/infoActCourse.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrRegProgram extends StatefulWidget {
  const MgrRegProgram({Key? key}) : super(key: key);

  @override
  State<MgrRegProgram> createState() => _MgrRegProgramState();
}

class _MgrRegProgramState extends State<MgrRegProgram> {
  List<ItemRegProgram> _itemList = [];
  late SessionData _session;
  bool _bready = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
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
        title: const Text("문화/행사 신청현황"),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        children: [
          const Row(
            children: [
              Text("문화/행사 신청내역", style: ItemBkB18,),
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

  Widget _showItem(ItemRegProgram item) {
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
                      visible: _itemList.isNotEmpty,
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

            _rowItem("유형", "문화/행사",false, false),
            _rowItem("신청일시", item.regDt,false, false),
            _rowItem("신청자", item.aplcntNm,false, false),
            _rowItem("참여일시", item.aplcntNm,false, false),
            _rowItem("센터소식\n수신여부", cvtYesNo(item.cnterNewsRcptnYn), false, false),
            _rowItem("접수상태", item.state(),false, true),

            const SizedBox(height: 10,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const LabelSize = 80.0;
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
                  padding: const EdgeInsets.only(left:10),
                  alignment: Alignment.centerLeft,
                  height: rowHeight,
                  color: Colors.white,
                  child: Text(value, style: ItemBkN15,),
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
          // ButtonState(
          //   padding: const EdgeInsets.all(15),
          //   enableColor: Colors.blueAccent,
          //   borderColor: Colors.blueAccent,
          //   enableTextColor: Colors.white,
          //   text: '신청하기',
          //   onClick: () {
          //     //_doEdit(true, "자녀 추가", ItemRegProgram());
          //   },
          // )
        ],
      ),
    );
  }

  void _doDelete(ItemRegProgram info) {
    showYesNoDialogBox(context: context, height: 240,
        title: "확인",
        message: "취소된 정보는 복구할 수 없습니다.\n신청을 취소하시겠습니까?\n",
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

  /*
  Future<void> _doEdit(bool bAdd, String title, ItemRegProgram item) async {
    InfoActCourse? info = await _reqInfo(item.actvstSn);
    if(info == null) {
      showToastMessage("데이터 조회 오류입니다.");
      return;
    }

    showActCourseInfo(
        context: context,
        title: title,
        info: info,
        onResult: (bool bDirty, InfoActCourse info) async {
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
  */
  // 삭제
  Future <bool> _reqDel(ItemRegProgram info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs_delete.do",
      params: { "parntSn": info.reqstdocSn },
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
  Future <bool> _reqEdit(bool bAdd, InfoActCourse info) async {
    bool flag = false;
    Map<String,dynamic> param = info.toMap();
    if (kDebugMode) {
      var logger = Logger();
      logger.d(param);
    }

    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/actvst_update.do",
      params: param,
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
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
      method: "appService/member/parntsEduAply.do",
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
            _itemList = ItemRegProgram.fromSnapshot(content);
            setState(() {

            });
          }
        }
      },
    );
  }
}
