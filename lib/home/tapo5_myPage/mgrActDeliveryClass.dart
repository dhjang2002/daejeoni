// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardTabbar.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popActDeliveryTarget.dart';
import 'package:daejeoni/home/tapo5_myPage/popInfoActDeliveryReport.dart';
import 'package:daejeoni/home/tapo5_myPage/popWriteActDeliveryReport.dart';
import 'package:daejeoni/models/infoActDeliveryReport.dart';
import 'package:daejeoni/models/itemActDeliveryHist.dart';
import 'package:daejeoni/models/itemActDeliveryReport.dart';
import 'package:daejeoni/models/itemActDeliveryTarget.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrActDeliveryClass extends StatefulWidget {
  const MgrActDeliveryClass({Key? key}) : super(key: key);

  @override
  State<MgrActDeliveryClass> createState() => _MgrActDeliveryClassState();
}

class _MgrActDeliveryClassState extends State<MgrActDeliveryClass> {
  List<ItemActDeliveryHist>   _itemHistList = [];
  List<ItemActDeliveryReport> _itemReportList = [];

  final List<TabbarItem> _boardTabitems = [
    TabbarItem(name: "배달강좌 이력",    tag: "0"),
    TabbarItem(name: "배달강좌 일지작성", tag: "1"),
  ];

  int _tabIndex = 0;
  String _boardSelect = "0";
  late SessionData _session;
  bool _bready = false;

  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      await _reqSelectHist();
      await _reqSelectReport();
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
        title: const Text("배달강좌 현황"),
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
                  await _reqSelectHist();
                  await _reqSelectReport();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding:const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: CardTabbar(
              items: _boardTabitems,
              index: _tabIndex,
              itemWidth: MediaQuery.of(context).size.width/2.2,
              normalBarColor: Colors.grey[200],
              onChange: (index, item) async {
                setState(() {
                  _tabIndex = index;
                  _boardSelect = item.tag;
                });
              },
            ),
          ),

          Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: (_boardSelect=="0") ? _infoHist() : _infoReport(),
              )
          ),
        ],
      ),
    );
  }

  Widget _infoHist() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ◼︎ 배달강좌 이력
            // Container(
            //   padding: EdgeInsets.fromLTRB(10, 10, 5, 0),
            //   child: Text("◼︎ 배달강좌 이력",
            //     style: ItemBkB16,),
            // ),
            // Divider(thickness: 2,),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _itemHistList.length+1,
                itemBuilder: (context, index) {
                  if(index<_itemHistList.length) {
                    return _itemHist(_itemHistList[index]);
                  } else {
                    return _itemEmpty(_itemHistList.isEmpty);
                  }
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoReport() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ◼︎ 배달강좌 일지작성
            // Container(
            //   padding: EdgeInsets.fromLTRB(10, 10, 5, 0),
            //   child: Text("◼︎ 배달강좌 일지작성",
            //     style: ItemBkB16,),
            // ),
            // Divider(thickness: 2,),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _itemReportList.length+1,
                itemBuilder: (context, index) {
                  if(index<_itemReportList.length) {
                    return _itemReport(_itemReportList[index]);
                  } else {
                    return _itemEmpty(_itemReportList.isEmpty);
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _itemHist(ItemActDeliveryHist item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 60,
                  color: (item.mtchgYn=="Y") ? Colors.green : Colors.grey,
                  child: Center(
                    child: Text(item.status(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: -1.2,
                      ),),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(item.dlvrSj,
                          maxLines: 1,
                          style: ItemBkB15,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(item.dlvrPlace,
                                maxLines: 1,
                                style: ItemBkN14,),
                            ),
                            Text(" /  매칭일자 : ${item.date()}", style: ItemBkN14,),
                          ],
                        ),

                        Text("주소 : ${item.dlvrAdres}", style: ItemBkN14,),
                      ],
                    )
                ),
              ],
            ),

            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _itemReport(ItemActDeliveryReport item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(5,5,5,0),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Text(item.insttNm, style: ItemBkB16,),
            const SizedBox(height: 3,),
            Text("교육대상: ${item.target()}", style: ItemBkN14,),
            Text("근무기간: ${item.date()}", style: ItemBkN14,),
            const SizedBox(height: 10,),
            Row(
              children: [
                // Text(item.insttNm,
                //   maxLines: 1,
                //   style: ItemBkN15,
                //   overflow: TextOverflow.ellipsis,
                // ),
                const Spacer(),
                Visibility(
                  visible: (true),
                  child: SizedBox(
                    width: 70,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(5),
                      text: '대상정보',
                      borderColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black
                      ),
                      onClick: () {
                        _doShowInfo("확인", item);
                      },
                    ),
                  ),),
                const SizedBox(width: 5,),
                Visibility(
                  visible: (item.diaryWrtYn=="Y"),
                  child: SizedBox(
                    width: 70,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(5),
                      text: '상세보기',
                      borderColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black
                      ),
                      onClick: () {
                        _doShowReport("일지확인", item);
                      },
                    ),
                  ),),
                const SizedBox(width: 5,),
                SizedBox(
                  width: 70,
                  height: 32,
                  child: ButtonState(
                    padding: const EdgeInsets.all(5),
                    enable: true,
                    text: (item.diaryWrtYn=="Y")?"일지수정":"일지작성",
                    //enableTextColor: Colors.white,
                    borderColor: (item.diaryWrtYn=="Y")? Colors.amber : Colors.blueAccent,
                    enableColor: (item.diaryWrtYn=="Y")? Colors.amber : Colors.blueAccent,
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: (item.diaryWrtYn=="Y") ? Colors.black :Colors.white,
                    ),
                    onClick: () async {
                      _doEditReport((item.diaryWrtYn=="Y")?"일지수정":"일지작성", item);
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _itemEmpty(bool isEmpty) {
    if(!_bready || !isEmpty) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //color: Colors.amber,
        alignment: Alignment.center,
        child: const Text("등록된 정보가 없습니다."),
      ),
    );
  }

  // 대상정보 확인
  Future <void> _doShowInfo(String title, ItemActDeliveryReport item) async {
    List<ItemActDeliveryTarget> items = await _reqSelectTarget(item.dlvrSn);
    if(items.isEmpty) {
      showToastMessage("대상정보가 없습니다.");
      return;
    }

    showDeliveryTarget(context: context,
        title: '대상정보',
        items: items,
        onResult: (bool bDirty) {
        }
    );
  }

  Future <void> _doShowReport(String title, ItemActDeliveryReport item) async {
    InfoActDeliveryReport? info = await _reqInfotDiary(item);
    if(info==null) {
      return;
    }

    showInfoDeliveryReport(context: context,
        title: title,
        info: info,
        onResult: (bool bDirty) async {
            if(bDirty) {
            }
        }
    );
  }

  Future <void> _doEditReport(String title, ItemActDeliveryReport item) async {
    InfoActDeliveryReport? info = await _reqInfotDiary(item);
    if(info==null) {
      return;
    }

    showWriteDeliveryReport(
        context: context,
        title: title,
        info: info,
        onResult: (bool bDirty) async {
          if(bDirty) {
            bool flag = await _reqEditReport(info);
            if(flag) {
              await _reqSelectReport();
              showToastMessage("수정되었습니다.");
            }
          }
        }
    );

    // showChildInfo(context: context, title: title, info: info,
    //     onResult: (bool bDirty, ItemActDeliveryClass info) async {
    //         if(bDirty) {
    //           bool flag = await _reqEdit(bAdd, info);
    //           if(flag) {
    //             await _reqSelectHist();
    //             await _reqSelectDiary();
    //             showToastMessage("수정되었습니다.");
    //           }
    //         }
    //     }
    // );
  }

  // 수정/추가
  Future <bool> _reqEditReport(InfoActDeliveryReport info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/actvstHist_update.do",
      params: info.toMap(),
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

  // 일지조회
  Future <void> _reqSelectReport() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/actvstHist.do",
      params: { "page" : 1, "countPerPage": 100 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['list'];
          if(content != null) {
            _itemReportList = ItemActDeliveryReport.fromSnapshot(content);
            setState(() {
            });
          }
        }
      },
    );
  }

  // 일지상세
  Future <InfoActDeliveryReport?> _reqInfotDiary(ItemActDeliveryReport item) async {
    InfoActDeliveryReport? info;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/actvstHist_info.do",
      params: { "actvstHistSn" : item.actvstHistSn},
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          var content = data['data']['info'];
          if(content != null) {
            info = InfoActDeliveryReport.fromJson(content);
            setState(() {
            });
          }
        }
      },
    );
    return info;
  }

  // 이력조회
  Future <void> _reqSelectHist() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/eduDlvr.do",
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
            _itemHistList = ItemActDeliveryHist.fromSnapshot(content);
            setState(() {

            });
          }
        }
      },
    );
  }


  // 대상조회
  Future <List<ItemActDeliveryTarget>> _reqSelectTarget(String dlvrSn) async {
    List<ItemActDeliveryTarget> list = [];
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/dlvr_chil.do",
      params: { "dlvrSn" : dlvrSn},
      onError: (String error) {},
      onResult: (dynamic data) async {
        if(data['status'].toString()=="200") {
          var content = data['data']['dlvrChilInfoJson'];
          if(content != null) {
            list = ItemActDeliveryTarget.fromSnapshot(content);
          }
        }
      },
    );
    return list;
  }

}
