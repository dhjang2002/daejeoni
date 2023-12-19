// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/cardAttach.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/infoActDeliveryReport.dart';
import 'package:daejeoni/models/itemAttach.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final InfoActDeliveryReport info;
  final Function(bool bDirty) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.info,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView> {
  final List<GRadioItem> targetList = [
    GRadioItem(label: "영・유아", tag: "1"),
    GRadioItem(label: "초등", tag: "2"),
    GRadioItem(label: "공동체", tag: "3"),
  ];

  late SessionData _session;
  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelSize = 100.0;
    //const labelHeight = 44.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        automaticallyImplyLeading: false,
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
      body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 여기에 다른 위젯들을 추가합니다.
                          //const Text("◼︎ 일지작성", style: ItemBkB16,),
                          //Divider(height: 20,),

                          // // 1. 첨부사진
                          // Container(
                          //   child: CardAttach(
                          //     token: _session.AccessToken,
                          //     attachList: info.imageList,
                          //     onUpdate: (String tag, String attached) {
                          //
                          //     },
                          //     onUpload: (String tag, String path) {
                          //       _reqUpLoad(path);
                          //     },
                          //   ),
                          // ),
                          // 1. 돌봄활동가명
                          Container(
                            margin: EdgeInsets.only(top:20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(top: BSG5, bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("돌봄\n활동가명", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        readOnly: true,
                                        maxLines: 3,
                                        minLines: 1,
                                        onlyDigit: false,
                                        hintText: '',
                                        valueText: widget.info.mberNm,
                                        onChange: (value) {},
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 2. 활동기관명
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동기관명", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        readOnly: true,
                                        maxLines: 3,
                                        minLines: 1,
                                        onlyDigit: false,
                                        hintText: '',
                                        valueText: widget.info.instNm,
                                        onChange: (value) {},
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 3. 운영장소
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("운영장소", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        readOnly: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        onlyDigit: false,
                                        hintText: '운영장소를 입력해주세요.',
                                        valueText: widget.info.operPlace,
                                        onChange: (value) {
                                          widget.info.operPlace = value;
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 4. 활동대상
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5, top:BSG5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동대상", style: ItemBkN14,),
                                ),

                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: Column(
                                        children: [
                                          CardGRadio(
                                            aList: targetList,
                                            initValue: widget.info.actTrgt,
                                            tag: '',
                                            isVertical: true,
                                            isUseCode: true,
                                            onSubmit: (String tag, String answerTag,
                                                String answerText) {
                                              setState(() {
                                                widget.info.actTrgt = answerTag;
                                              });
                                              //_validate();
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),

                          // 5. 참여인원
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("참여인원", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        readOnly: false,
                                        maxLines: 3,
                                        minLines: 1,
                                        onlyDigit: true,
                                        keyboardType: TextInputType.number,
                                        hintText: '참여인원을 입력해주세요.',
                                        valueText: widget.info.partcptnNmpr,
                                        onChange: (value) {
                                          widget.info.partcptnNmpr = value;
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 6. 근무일시
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("근무일시", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        readOnly: true,
                                        maxLines: 3,
                                        minLines: 1,
                                        onlyDigit: false,
                                        hintText: '',
                                        valueText: widget.info.date(),
                                        onChange: (value) {},
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 7. 활동주제
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동주제", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        maxLines: 10,
                                        minLines: 2,
                                        onlyDigit: false,
                                        hintText: '활동주재를 입력해주세요.',
                                        valueText: widget.info.actThema,
                                        onChange: (value) {
                                          widget.info.actThema = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 8. 활동목표
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동목표)",
                                    style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        maxLines: 10,
                                        minLines: 3,
                                        onlyDigit: false,
                                        hintText: '활동목표를 입력해주세요.',
                                        valueText: widget.info.actGoal,
                                        onChange: (value) {
                                          widget.info.actGoal = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 9. 주요활동내용
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text(
                                    "주요\n활동내용", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        maxLines: 10,
                                        minLines: 5,
                                        onlyDigit: false,
                                        hintText: '활동내역을 기재해주세요.',
                                        valueText: widget.info.mainActCn,
                                        onChange: (value) {
                                          widget.info.mainActCn = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 10. 활동소감및개선사항
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동소감\n및\n개선사항", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        maxLines: 10,
                                        minLines: 5,
                                        onlyDigit: false,
                                        hintText: '활동소감 및 개선사항을 입력해주세요.',
                                        valueText: widget.info.actThts,
                                        onChange: (value) {
                                          widget.info.actThts = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 11. 활동사진
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(bottom: BSG5, left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  width: labelSize,
                                  child: const Text("활동사진", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: CardAttach(
                                        token: _session.AccessToken,
                                        attachList: widget.info.imageList,
                                        doUpload: (String tag, String attached) async {
                                          await _reqUpLoad(attached);
                                        },
                                        onUpdate: (String tag, String path) {

                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 50,),
                          Visibility(
                            visible: true,
                            child: ButtonSingle(
                                visible: true,
                                isBottomPading: false,
                                text: widget.title,
                                enable: true,
                                onClick: () {
                                  bool flag = _verifyConfirm();
                                  if(flag){
                                    widget.onClose(true);
                                    Navigator.pop(context);
                                  }
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  bool _verifyConfirm() {
    // 1. 운영장소
    if(widget.info.operPlace.isEmpty){
      showToastMessage("[운영장소]를 입략해주세요.");
      return false;
    }
    // 2. 활동대상
    if(widget.info.actTrgt.isEmpty){
      showToastMessage("[활동대상]을 선택해주세요.");
      return false;
    }

    // 3. 참여인원
    if(widget.info.partcptnNmpr.isEmpty){
      showToastMessage("[참여인원]을 입력해주세요.");
      return false;
    }


    // 4. 활동주제
    if(widget.info.actThema.isEmpty){
      showToastMessage("[활동주제]을 입력해주세요.");
      return false;
    }

    // 5. 활동목표
    if(widget.info.actGoal.isEmpty){
      showToastMessage("[활동목표]을 입력해주세요.");
      return false;
    }

    // 6. 주요활동내용
    if(widget.info.mainActCn.isEmpty){
      showToastMessage("[주요활동내용]을 입력해주세요.");
      return false;
    }

    // 7. 활동소감 및 개선사항
    if(widget.info.actThts.isEmpty){
      showToastMessage("[활동소감 및 개선사항]를 입력해주세요.");
      return false;
    }

    return true;
  }

  Future<void> _reqUpLoad(String path) async {

    print("_reqUpLoad:path=$path");
    await Remote.fileUpLoad(
      context: context,
      method: 'appService/member/actvstHist_file.do',
      session: _session,
      params: {"actvstHistSn":widget.info.actvstHistSn},
      filePath: path,
      onError: (String error) {},
      onResult: (data) {
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(data);
        // }
        if(data['status'].toString()=="200") {
          widget.info.imageList = [];
          widget.info.atchFileId = data['data']['info']['atchFileId'].toString();
          if (widget.info.atchFileId.isNotEmpty) {
            widget.info.imageList = [ItemAttach(tag: "p", url: InfoActDeliveryReport.makeUrl(widget.info.atchFileId))];
            setState(() {

            });
          }
        }
      },
    );
  }

}

Future<void> showWriteDeliveryReport({
  required BuildContext context,
  required String title,
  required InfoActDeliveryReport info,
  required Function(bool bDirty) onResult}) {
  //double viewHeight = MediaQuery.of(context).size.height * 0.85;
  double viewHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    useRootNavigator: false,
    isDismissible: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: SizedBox(
          height: viewHeight,
          child: _ContentView(
            title: title,
            info: info,
            onClose: (bDirty) {
              onResult(bDirty);
            },
          ),
        ),
      );
    },
  );
}