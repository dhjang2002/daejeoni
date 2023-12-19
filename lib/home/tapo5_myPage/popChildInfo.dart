// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/models/ItemChild.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:intl/intl.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final ItemChild info;
  final Function(bool bDirty, ItemChild info) onClose;
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
  bool _bEnable = true;
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 여기에 다른 위젯들을 추가합니다.
                  const Text("인적사항", style: ItemBkB16,),
                  // 이름
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 60,
                          color: Colors.white,
                          child: const Text("이름"),
                        ),
                        SizedBox(
                          width: 120,
                          child: InputForm(
                            onlyDigit: false,
                            hintText: '이름',
                            valueText: widget.info.parntsChldrnNm,
                            onChange: (value) {
                              widget.info.parntsChldrnNm = value;
                              _validate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                    width: 160,
                    height: 38,
                    child: CardGRadio(
                      aList: sexList,
                      initValue: widget.info.parntsSexdstn,
                      tag: '',
                      isVertical: false,
                      isUseCode: false,
                      onSubmit: (String tag, String answerTag, String answerText) {
                        setState(() {
                          widget.info.parntsSexdstn = answerTag;
                        });
                        _validate();
                      },
                    ),
                  ),

                  // 생년월일
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 60,
                          color: Colors.white,
                          child: const Text("생년월일"),
                        ),
                        SizedBox(
                          width: 160,
                          child: InputForm(
                            onlyDigit: false,
                            readOnly:true,
                            hintText: '생년월일',
                            valueText: widget.info.parntsChldrnBrdt,
                            onChange: (value) {
                              //widget.info.parntsChldrnBrdt = value;
                            },

                            onMenu: (controller) async {
                              DateTime date = DateTime.now();
                              if(widget.info.parntsChldrnBrdt.length>=8) {
                                String dateString = "${widget.info
                                    .parntsChldrnBrdt.substring(0, 4)}"
                                    "-${widget.info.parntsChldrnBrdt
                                    .substring(4, 6)}"
                                    "-${widget.info.parntsChldrnBrdt
                                    .substring(6, 8)}";
                                date = DateFormat('yyyy-MM-dd').parse(
                                    dateString);
                              }
                              showSelectMonth(
                                  context: context,
                                  title: '일자선택',
                                  useDay: true,
                                  date: date,
                                  onResult: (DateTime date) {
                                    widget.info.parntsChldrnBrdt
                                    = "${date.year}${toZeroString(date.month)}${toZeroString(date.day)}";
                                    controller.text = widget.info.parntsChldrnBrdt;
                                  });
                              _validate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 20,),
                  Row(
                    children: [
                      const Text("장애여부", style: ItemBkB16,),
                      const SizedBox(width: 10,),
                      Container(
                        height: 40,
                        width: 240,
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: CardGRadio(
                          aList: ynList,
                          initValue: widget.info.parntsTroblYn,
                          tag: '',
                          isVertical: false,
                          isUseCode: false,
                          onSubmit: (String tag, String answerTag, String answerText) {
                            setState(() {
                              widget.info.parntsTroblYn = answerTag;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  // 장애유형
                  Visibility(
                    visible: widget.info.parntsTroblYn=="Y",
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 60,
                            color: Colors.white,
                            child: const Text("장애유형"),
                          ),
                          Expanded(
                            child: InputForm(
                              onlyDigit: false,
                              touchClear: false,
                              hintText: '장애유형',
                              valueText: widget.info.parntsTroblType,
                              onChange: (value) {
                                widget.info.parntsTroblType = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 20,),
                  //SizedBox(height: 20,),
                  // 어린이집 명
                  Container(
                    padding: const EdgeInsets.fromLTRB(0,15,10,10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 80,
                          color: Colors.white,
                          child: const Text("어린이집 명",style: ItemBkB16),
                        ),
                        Expanded(
                          child: InputForm(
                            onlyDigit: false,
                            touchClear: false,
                            hintText: '어린이집 명',
                            valueText: widget.info.parntsChldrnDcc,
                            onChange: (value) {
                              widget.info.parntsChldrnDcc = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 유치원 명
                  Container(
                    padding: const EdgeInsets.fromLTRB(0,15,10,10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 80,
                          color: Colors.white,
                          child: const Text("유치원 명",style: ItemBkB16),
                        ),
                        Expanded(
                          child: InputForm(
                            onlyDigit: false,
                            touchClear: false,
                            hintText: '유치원 명',
                            valueText: widget.info.parntsChldrnKndrgr,
                            onChange: (value) {
                              widget.info.parntsChldrnKndrgr = value;
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                  // 초등학교 명
                  Container(
                    padding: const EdgeInsets.fromLTRB(0,15,10,10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 80,
                          color: Colors.white,
                          child: const Text("초등학교 명",style: ItemBkB16),
                        ),
                        Expanded(
                          child: InputForm(
                            onlyDigit: false,
                            touchClear: false,
                            hintText: '초등학교 명',
                            valueText: widget.info.parntsChldrnElesch,
                            onChange: (value) {
                              widget.info.parntsChldrnElesch = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Visibility(
                    visible: true,
                    child:ButtonSingle(
                        visible: true,
                        isBottomPading: false,
                        text: widget.title,
                        enable: true,//_bEnable,
                        onClick: () {
                          widget.onClose(true, widget.info);
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  //const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  void _validate() {
    _bEnable = widget.info.parntsChldrnNm.isNotEmpty
        && widget.info.parntsChldrnBrdt.isNotEmpty
        && widget.info.parntsSexdstn.isNotEmpty;
    setState(() {

    });
  }
}

Future<void> showChildInfo({
  required BuildContext context,
  required String title,
  required ItemChild info,
  required Function(bool bDirty, ItemChild info) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.85;
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
            onClose: (bDirty, info) {
              onResult(bDirty, info);
            },
          ),
        ),
      );
    },
  );
}