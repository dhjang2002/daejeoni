// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/models/ItemChild.dart';
import 'package:daejeoni/models/infoActDeliveryReport.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:intl/intl.dart';

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
  //bool _bDirty = false;
  bool _bEnable = false;

  final List<GRadioItem> ynList = [GRadioItem(label: "예", tag: "Y"), GRadioItem(label: "아니오", tag: "N")];
  final List<GRadioItem> sexList = [GRadioItem(label: "남아", tag: "1"), GRadioItem(label: "여아", tag: "2")];

  @override
  void initState() {
    _validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.5,
        centerTitle: false,
        automaticallyImplyLeading: false,
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
          padding: EdgeInsets.only(top:20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 여기에 다른 위젯들을 추가합니다.
                  _rowItem("돌봄\n활동가명", widget.info.mberNm,false, false),
                  _rowItem("활동\n기관명", widget.info.instNm, false, false),
                  _rowItem("운영장소", widget.info.operPlace,false, false),
                  _rowItem("활동대상", widget.info.target(), false, false),
                  _rowItem("참여인원", widget.info.partcptnNmpr, false, false),
                  _rowItem("활동일시", widget.info.date(), false, false),
                  _rowItem("활동주제", widget.info.actThema, false, false),
                  _rowItem("활동목표", widget.info.actGoal, false, false, lines: 3),
                  _rowItem("주요\n활동내용", widget.info.mainActCn, false, false, lines: 5),
                  _rowItem("활동소감\n및\개선사항", widget.info.actThts, false, true, lines: 5),
                  //_rowItem("출결", "", false, false),
                  //_rowItem("관리", "예약취소", true, true),
                  const SizedBox(height: 50,),
                  Visibility(
                    visible: true,
                    child:ButtonSingle(
                        visible: true,
                        isBottomPading: false,
                        text: "확인",
                        enable: true,
                        onClick: () {
                          widget.onClose(true);
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  void _validate() {
    setState(() {

    });
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast, {int lines = 1}) {
    const LabelSize = 80.0;
    //const rowHeight = 40.0;
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
            width: LabelSize,
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text(label, style: ItemBkN14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left:10, top: 5, bottom: 5, right: 5),
                  alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(left: BSG5,),
                    ),
                  child: InputForm(
                      onlyDigit: false,
                      readOnly: true,
                      hintText: '',
                      valueText: value,
                      maxLines: 10,
                      minLines: lines,
                      onChange: (value) {},
                  )
                )
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showInfoDeliveryReport({
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