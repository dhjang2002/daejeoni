// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:daejeoni/common/cardGCheck.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemCareCrops.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final ItemCareCrops info;
  final Function(bool bDirty, ItemCareCrops info) onClose;
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
  bool _bEnable = false;
  ItemCareCrops info = ItemCareCrops();

  final List<GCheckItem> careTypeList = [
    GCheckItem(label: "월요일", tag: "월요일"),
    GCheckItem(label: "화요일", tag: "화요일"),
    GCheckItem(label: "수요일", tag: "수요일"),
    GCheckItem(label: "목요일", tag: "목요일"),
    GCheckItem(label: "금요일", tag: "금요일"),
    GCheckItem(label: "토요일", tag: "토요일"),
    GCheckItem(label: "일요일", tag: "일요일"),
    GCheckItem(label: "상관없음", tag: "상관없음"),
  ];

  final List<String> weekList = [
    "일주일", "이 주일", "삼 주일", "사 주일"
  ];

  final List<String> timeList = [
    "00:00", "00:30", "01:00", "01:30", "02:00", "02:30", "03:00", "03:30", "04:00", "04:30", "05:00", "05:30",
    "06:00", "06:30", "07:00", "07:30",
    "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
    "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
    "18:00", "18:30", "19:00", "19:30", "20:00", "20,30", "21:00", "21:30", "22:00",
    "22:30", "23:00", "23:30"
  ];

  @override
  void initState() {
    info = widget.info;
    _validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const LabelSize = 120.0;
    const LabelHeight = 44.0;
    return Scaffold(
      backgroundColor: _colorGrayBack,
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
          onTap: () async { FocusScope.of(context).unfocus();},
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("돌봄봉사단 신청내역", style: ItemBkB16,),
                          const SizedBox(height: 10,),
                          // 1. 소속(학교명 및 회사명을 기입해주세요)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: const Border(
                                bottom: BSG5, top: BSG5,
                                left: BSG5, right: BSG5,),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("소속\n(학교명 및 회사명)", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: false,
                                        hintText: '소속(학교명 및 회사명을 기입해주세요)',
                                        valueText: info.aplcntPsitn,
                                        onChange: (value) {
                                          info.aplcntPsitn = value;
                                          _validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 2. 학과
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("학과", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: false,
                                        hintText: '학과',
                                        valueText: info.aplcntSubjct,
                                        onChange: (value) {
                                          info.aplcntSubjct = value;
                                          _validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 3. 긴급 연락처
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("긴급 연락처", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: true,
                                        keyboardType: TextInputType.phone,
                                        hintText: '긴급 연락처',
                                        valueText: info.aplcntEmrgTelno,
                                        onChange: (value) {
                                          info.aplcntEmrgTelno = value;
                                          _validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 4. 1365 아이디
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("1365 아이디", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: false,
                                        hintText: '1365 아이디',
                                        valueText: info.aplcnt1365Id,
                                        onChange: (value) {
                                          info.aplcnt1365Id = value;
                                          _validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 5. 희망봉사시간
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("희망봉사시간", style: ItemBkN14,),
                                ),
                                Expanded(
                                  flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,15,5,15),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text("주 ", style: ItemBkN15,),
                                              Container(
                                                //width: 80,
                                                margin: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: false,
                                                    items: weekList
                                                        .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: info.srvcTimeWeek,
                                                    buttonStyleData: ButtonStyleData(
                                                      height: 40,
                                                      padding: const EdgeInsets.only(left: 5, right: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.black,),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 0,
                                                    ),

                                                    dropdownStyleData: DropdownStyleData(
                                                      maxHeight: 320,
                                                      width: 100,
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 8,
                                                      offset: const Offset(1, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius.circular(40),
                                                        thickness:
                                                        MaterialStateProperty.all<double>(6),
                                                        thumbVisibility:
                                                        MaterialStateProperty.all<bool>(true),
                                                      ),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 40,
                                                      padding: EdgeInsets.only(left: 5, right: 5),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        info.srvcTimeWeek = value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const Text("횟수"),
                                              Container(
                                                width: 50,
                                                margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                child: InputForm(
                                                  onlyDigit: true,
                                                  hintText: '횟수',
                                                  textAlign: TextAlign.center,
                                                  keyboardType:TextInputType.number,
                                                  valueText: info.srvcTimeCnt,
                                                  onChange: (value) {
                                                    info.srvcTimeCnt = value;
                                                    _validate();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 5,),
                                          const SizedBox(height: 10,),
                                          CardGCheck(
                                            aList: careTypeList,
                                            initValue: info.srvcTimeDay,
                                            tag: '',
                                            isVertical: true,
                                            isUseCode: true,
                                            onSubmit: (String tag, String answerTag, String answerText) {
                                              setState(() {
                                                info.srvcTimeDay = answerTag;
                                              });
                                              _validate();
                                            },
                                          ),
                                          const Divider(height: 5,),
                                          const SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              const Text("시간 ", style: ItemBkN14,),
                                              Container(
                                                //width: 80,
                                                margin: const EdgeInsets.fromLTRB(5, 0, 1, 0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: false,
                                                    items: timeList
                                                        .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: info.srvcStrTime,
                                                    buttonStyleData: ButtonStyleData(
                                                      height: 40,
                                                      padding: const EdgeInsets.only(left: 5, right: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.black,),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 0,
                                                    ),

                                                    dropdownStyleData: DropdownStyleData(
                                                      maxHeight: 320,
                                                      width: 100,
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 8,
                                                      offset: const Offset(0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius.circular(40),
                                                        thickness:
                                                        MaterialStateProperty.all<double>(6),
                                                        thumbVisibility:
                                                        MaterialStateProperty.all<bool>(true),
                                                      ),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 40,
                                                      padding: EdgeInsets.only(left: 5, right: 5),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        info.srvcStrTime = value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const Text(" ~ "),
                                              Container(
                                                //width: 80,
                                                margin: const EdgeInsets.fromLTRB(1, 0, 5, 0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: false,
                                                    items: timeList
                                                        .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: info.srvcEndTime,
                                                    buttonStyleData: ButtonStyleData(
                                                      height: 40,
                                                      padding: const EdgeInsets.only(left: 5, right: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.black,),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 0,
                                                    ),

                                                    dropdownStyleData: DropdownStyleData(
                                                      maxHeight: 320,
                                                      width: 100,
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 8,
                                                      offset: const Offset(0, 0),
                                                      scrollbarTheme: ScrollbarThemeData(
                                                        radius: const Radius.circular(40),
                                                        thickness:
                                                        MaterialStateProperty.all<double>(6),
                                                        thumbVisibility:
                                                        MaterialStateProperty.all<bool>(true),
                                                      ),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 40,
                                                      padding: EdgeInsets.only(left: 5, right: 5),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        info.srvcEndTime = value.toString();
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 6. 희망봉사시간 상세내용
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("희망봉사시간\n상세내용", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      //color: Colors.white,
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: false,
                                        minLines: 5,
                                        maxLines: 20,
                                        hintText: '희망봉사시간 상세내용',
                                        valueText: info.srvcTimeDtlCn,
                                        onChange: (value) {
                                          info.srvcTimeDtlCn = value;
                                          _validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 7. 봉사참여동기
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
                                  padding: const EdgeInsets.only(left:10),
                                  width: LabelSize,
                                  child: const Text("봉사참여동기", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10,5,5,5),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: InputForm(
                                        onlyDigit: false,
                                        minLines: 5,
                                        maxLines: 20,
                                        hintText: '봉사참여동기',
                                        valueText: info.srvcPartcptnSync,
                                        onChange: (value) {
                                          info.srvcPartcptnSync = value;
                                          _validate();
                                        },
                                      ),
                                    )
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
                                enable: _bEnable,
                                onClick: () {
                                  bool flag = _verifyConfirm();
                                  if(flag){
                                    widget.onClose(true, info);
                                    Navigator.pop(context);
                                  }
                                }
                            ),
                          )
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
    // 1. 소속
    if(info.aplcntPsitn.isEmpty){
      showToastMessage("[소속]를 입력해주세요.");
      return false;
    }

    // 2. 학과
    if(info.aplcntSubjct.isEmpty){
      showToastMessage("[학과]를 입력해주세요.");
      return false;
    }

    // 3. 긴급연락처
    if(info.aplcntEmrgTelno.isEmpty){
      showToastMessage("[긴급연락처]를 입력해주세요.");
      return false;
    }

    // 3. 1365 아이디
    if(info.aplcnt1365Id.isEmpty){
      showToastMessage("[1365 아이디]를 입력해주세요.");
      return false;
    }

    // 4-1. 희망봉사시간-주일
    if(info.srvcTimeWeek.isEmpty){
      showToastMessage("[희망봉사시간-주일]을 지정해주세요.");
      return false;
    }

    // 4-2. 희망봉사시간-회수
    if(info.srvcTimeCnt.isEmpty){
      showToastMessage("[희망봉사시간-회수]을 입력해주세요.");
      return false;
    }

    // 4-3. 희망봉사시간-요일
    if(info.srvcTimeDay.isEmpty){
      showToastMessage("[희망봉사시간-요일]을 지정해주세요.");
      return false;
    }

    // 4-4. 희망봉사시간-봉사시간
    if(info.srvcStrTime.isEmpty || info.srvcEndTime.isEmpty){
      showToastMessage("[희망봉사시간-봉사시간]을 지정해주세요.");
      return false;
    }

    // 5. 희망봉사시간 상세내용
    if(info.srvcTimeDtlCn.isEmpty){
      showToastMessage("[희망봉사시간 상세내용]을 입력해주세요.");
      return false;
    }

    // 6. 봉사참여 동기
    if(info.srvcPartcptnSync.isEmpty){
      showToastMessage("[봉사참여 동기]를 입력해주세요.");
      return false;
    }
    return true;
  }

  void _validate() {
    _bEnable = info.aplcntPsitn.isNotEmpty
        && info.aplcntEmrgTelno.isNotEmpty
        && info.aplcnt1365Id.isNotEmpty;
    setState(() {

    });
  }
}

Future<void> showCareCropsInfo({
  required BuildContext context,
  required String title,
  required ItemCareCrops info,
  required Function(bool bDirty, ItemCareCrops info) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      //MediaQuery.of(context).size.height * 0.95;
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