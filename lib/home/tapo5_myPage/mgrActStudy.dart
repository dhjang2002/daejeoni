// ignore_for_file: file_names

import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardFace.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemActStudy.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MgrActStudy extends StatefulWidget {
  const MgrActStudy({Key? key}) : super(key: key);

  @override
  State<MgrActStudy> createState() => _MgrActStudyState();
}

class _MgrActStudyState extends State<MgrActStudy> {
  List<ItemActStudy> _itemList = [];
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
        title: const Text("온라인교육 신청내역"),
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
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
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

  Widget _showItem(ItemActStudy item) {
    String profile = item.getProfile();
    String desc = item.getDesc();
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CardFace(photoUrl: ""),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(item.parntsChldrnNm,
                              maxLines: 1,
                              style: ItemBkB20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 50,
                              child: ButtonState(
                                padding: const EdgeInsets.all(5),
                                text: '수정',
                                borderColor: Colors.amber,
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber
                                ),
                                onClick: () {
                                  _doEdit(false, "정보수정", item);
                                },
                              ),
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: 50,
                              child: ButtonState(
                                padding: const EdgeInsets.all(5),
                                text: '삭제',
                                borderColor: Colors.amber,
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber
                                ),
                                onClick: () async {
                                  _doDelete(item);
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(profile, style: ItemBkN14,),
                        const SizedBox(height: 5),
                        Visibility(
                          visible: desc.isNotEmpty,
                          child: Text(desc, style: ItemBkN14,),)
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
              //_doEdit(true, "자녀 추가", ItemActStudy());
            },
          )
        ],
      ),
    );
  }

  void _doDelete(ItemActStudy info) {
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

  void _doEdit(bool bAdd, String title, ItemActStudy info) {
    // showChildInfo(context: context, title: title, info: info,
    //     onResult: (bool bDirty, ItemActStudy info) async {
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
  Future <bool> _reqDel(ItemActStudy info) async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/childs_delete.do",
      params: { "parntSn": info.parntsSn },
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
  Future <bool> _reqEdit(bool bAdd, ItemActStudy info) async {
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
      method: "appService/member/eduHist.do",
      params: { "page" : 1, "countPerPage": 100 },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          // var content = data['data']['list'];
          // if(content != null) {
          //   _itemList = ItemActStudy.fromSnapshot(content);
          //   setState(() {
          //
          //   });
          // }
        }
      },
    );
  }
}
