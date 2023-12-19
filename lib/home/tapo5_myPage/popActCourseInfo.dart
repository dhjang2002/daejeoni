// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardAttach.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/models/ItemMemberCrqfc.dart';
import 'package:daejeoni/models/ItemMemberHist.dart';
import 'package:daejeoni/models/infoActCourse.dart';
import 'package:daejeoni/models/itemAttach.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final InfoActCourse info;
  final Function(bool bDirty, InfoActCourse info) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.info,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  final bool _bEnable = true;

  InfoActCourse info = InfoActCourse();
  bool bEtcCheck = false;

  final List<GRadioItem> ynList = [
    GRadioItem(label: "예", tag: "Y"),
    GRadioItem(label: "아니오", tag: "N")
  ];

  final List<GRadioItem> enterTypeList = [
    GRadioItem(label: "보도자료(뉴스,기사,홍보자료 등)", tag: "COURS0004"),
    GRadioItem(label: "SNS(블로그,페이스북,인스타 등)", tag: "COURS0001"),
    GRadioItem(label: "지인소개", tag: "COURS0002"),
    GRadioItem(label: "기타", tag: "COURS0003"),
  ];

  final List<GRadioItem> schoolTypeList = [
    GRadioItem(label: "초등학교 졸업", tag: "ACDMCR0001"),
    GRadioItem(label: "중학교 졸업", tag: "ACDMCR0002"),
    GRadioItem(label: "고등학교 졸업", tag: "ACDMCR0003"),
    GRadioItem(label: "대학교・대학원 졸업", tag: "ACDMCR0004"),
  ];

  late SessionData _session;
  @override
  void initState() {
    _session   = Provider.of<SessionData>(context, listen: false);
    setState(() {
      info = widget.info;
    });
    //_validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const LabelSize = 100.0;
    const LabelHeight = 44.0;

    return Scaffold(
      backgroundColor: _colorGrayBack,
      appBar: AppBar(
        //elevation: 0.5,
        //backgroundColor: _colorGrayBack,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 여기에 다른 위젯들을 추가합니다.
                          const Text("양성과정 신청내역", style: ItemBkB16,),
                          //Divider(height: 20,),

                          // 1. 첨부사진
                          Container(
                            child: CardAttach(
                              token: _session.AccessToken,
                              attachList: info.imageList,
                              doUpload: (String tag, String attached) {
                                _reqUpLoad(attached);
                              },
                              onUpdate: (String tag, String path) {

                              },
                            ),
                          ),
                          // 2. 참여경로
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
                                  width: LabelSize,
                                  child: const Text("참여경로", style: ItemBkN14,),
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
                                            aList: enterTypeList,
                                            initValue: info.partcptnCoursCd,
                                            tag: '',
                                            isVertical: true,
                                            isUseCode: true,
                                            onSubmit: (String tag, String answerTag,
                                                String answerText) {
                                              setState(() {
                                                info.partcptnCoursCd = answerTag;
                                              });
                                              //_validate();
                                            },
                                          ),
                                          Visibility(
                                              visible: info.partcptnCoursCd=="COURS0003",
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                                                child: InputForm(
                                                maxLines: 1,
                                                minLines: 1,
                                                onlyDigit: false,
                                                hintText: '참여경로',
                                                valueText: info.partcptnCoursEtc,
                                                onChange: (value) {
                                                  info.partcptnCoursEtc = value;
                                                  //_validate();
                                                },
                                              ),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),

                          // 3. 학력사항
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
                                  width: LabelSize,
                                  child: const Text("학력사항", style: ItemBkN14,),
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
                                      child: CardGRadio(
                                        aList: schoolTypeList,
                                        initValue: info.acdmcrCd,
                                        tag: '',
                                        isVertical: true,
                                        isUseCode: true,
                                        onSubmit: (String tag, String answerTag,
                                            String answerText) {
                                          setState(() {
                                            info.acdmcrCd = answerTag;
                                            if(info.acdmcrCd=="ACDMCR0004" && info.histList.length<2) {
                                              info.histList.add(ItemMemberHist());
                                            }
                                          });
                                          //_validate();
                                        },
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),

                          // 4. 학교명
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
                                  width: LabelSize,
                                  child: const Text("학력정보", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 15),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: info
                                                  .getSchoolInfoCount(),
                                              itemBuilder: (context, index) {
                                                return _histItem(index, 
                                                    info.histList[index]);
                                              }
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 5. 자격사항
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
                                  width: LabelSize,
                                  child: const Text("자격사항", style: ItemBkN14,),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 5, 15),
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(left: BSG5,),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: info.crqfcList.length,
                                              itemBuilder: (context, index) {
                                                return _crqItem(index,
                                                    info.crqfcList[index]);
                                              }
                                          ),
                                          _addCrqfcButton(),
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 6. 특기사항
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
                                  width: LabelSize,
                                  child: const Text("특기사항", style: ItemBkN14,),
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
                                        hintText: '특기사항을 입력해주세요.',
                                        valueText: info.actvstSpcabl,
                                        onChange: (value) {
                                          info.actvstSpcabl = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 7. 자기소개
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
                                  width: LabelSize,
                                  child: const Text("자기소개\n( 성장과정\n및 성격의\n장단점 등 )",
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
                                        minLines: 5,
                                        onlyDigit: false,
                                        hintText: '자기소개를 기재해주세요',
                                        valueText: info.actvstIntrcn,
                                        onChange: (value) {
                                          info.actvstIntrcn = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 8. 활동사항
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
                                  width: LabelSize,
                                  child: const Text(
                                    "활동사항\n(경력기술)", style: ItemBkN14,),
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
                                        valueText: info.actvstActMatter,
                                        onChange: (value) {
                                          info.actvstActMatter = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 9. 지원동기
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
                                  width: LabelSize,
                                  child: const Text("지원동기", style: ItemBkN14,),
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
                                        hintText: '지원동기를 입력해주세요.',
                                        valueText: info.actvstSync,
                                        onChange: (value) {
                                          info.actvstSync = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          // 8. 돌봄활동가로서의 포부
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
                                  width: LabelSize,
                                  child: const Text(
                                    "돌봄\n활동가로서의\n포부", style: ItemBkN14,),
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
                                        hintText: '돌봄활동가로서의 포부 입력.',
                                        valueText: info.actvstDream,
                                        onChange: (value) {
                                          info.actvstDream = value;
                                          //_validate();
                                        },
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),

                          Divider(height: 50,),
                          Visibility(
                            visible: true,
                            child: ButtonSingle(
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

  Widget _histItem(int index, ItemMemberHist item) {
    bool hasMajor = info.isMajor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text("◼︎ ${info.getSchoolInfoName(index)} 정보입력", style: ItemBkB15,),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: const Text("학교명", style: ItemBkN14,),
        ),

        SizedBox(
          width: 160,
          child: InputForm(
            maxLines: 1,
            minLines: 1,
            onlyDigit: false,
            hintText: '학교명을 입력하세요.',
            valueText: item.mberHistNm,
            onChange: (value) {
              item.mberHistNm = value;
              //_validate();
            },
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: const Text("재학기간", style: ItemBkN14,),
        ),
        Row(
          children: [
            Expanded(
              child: InputForm(
                readOnly: true,
                textAlign: TextAlign.center,
                onlyDigit: false,
                hintText: '입학/편입 일자',
                valueText: item.mberHistBgngYm,
                onChange: (value) {
                  item.mberHistBgngYm = value;
                  //_validate();
                },
                onMenu: (controller) {
                  DateTime date = DateFormat('yyyy-MM').parse(
                      item.mberHistBgngYm);
                  showSelectMonth(
                      context: context,
                      title: '입학년월',
                      useDay: false,
                      date: date,
                      onResult: (DateTime date) {
                        item.mberHistBgngYm =
                        "${date.year}-${toZeroString(date.month)}";
                        controller.text = item.mberHistBgngYm;
                      });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const Text("~"),
            ),
            Expanded(
              child: InputForm(
                readOnly: true,
                onlyDigit: false,
                textAlign: TextAlign.center,
                hintText: '졸업,재학중,휴학중,수료,자퇴,졸업예정',
                valueText: item.mberHistEndYm,
                onChange: (value) {
                  item.mberHistEndYm = value;
                  //_validate();
                },
                onMenu: (controller) {
                  DateTime date = DateFormat('yyyy-MM').parse(
                      item.mberHistEndYm);
                  showSelectMonth(context: context,
                      title: '졸업년월',
                      useDay: false,
                      date: date,
                      onResult: (DateTime date) {
                        item.mberHistEndYm =
                        "${date.year}-${toZeroString(date.month)}";
                        controller.text = item.mberHistEndYm;
                      });
                },
              ),
            ),
          ],
        ),

        Visibility(
          visible: hasMajor,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: const Text("전공", style: ItemBkN14,),
          ),
        ),

        Visibility(
          visible: hasMajor,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: InputForm(
              maxLines: 1,
              minLines: 1,
              onlyDigit: false,
              hintText: '전공을 입력하세요.',
              valueText: item.mberHistMajor,
              onChange: (value) {
                item.mberHistMajor = value;
                //_validate();
              },
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _addCrqfcButton() {
    if (info.crqfcList.length >= 3) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Visibility(
              visible: info.crqfcList.isEmpty,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: const Text("등록된 정보가 없습니다."),
              )
          ),
          ButtonState(
            padding: const EdgeInsets.all(10),
            enableColor: Colors.blueAccent,
            borderColor: Colors.blueAccent,
            enableTextColor: Colors.white,
            text: '경력사항 추가',
            onClick: () {
              setState(() {
                info.crqfcList.add(ItemMemberCrqfc());
              });
            },
          )
        ],
      ),
    );
  }

  Widget _crqItem(int index, ItemMemberCrqfc item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              children: [
                const Text("자격명", style: ItemBkN14,),
                const Spacer(),
                Visibility(
                    visible: index > 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: 60,
                      child: ButtonState(
                        padding: const EdgeInsets.all(5),
                        text: '삭제',
                        borderColor: Colors.pink,
                        textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black
                        ),
                        onClick: () async {
                          setState(() {
                            info.crqfcList.remove(item);
                          });
                        },
                      ),
                    )
                ),
              ],
            )
        ),

        SizedBox(
          width: 160,
          child: InputForm(
            maxLines: 1,
            minLines: 1,
            onlyDigit: false,
            hintText: '자격명',
            valueText: item.crqfcNm,
            onChange: (value) {
              item.crqfcNm = value;
              //_validate();
            },
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: const Text("발행기관", style: ItemBkN14,),
        ),
        InputForm(
          maxLines: 1,
          minLines: 1,
          onlyDigit: false,
          hintText: '발행기관',
          valueText: item.crqfcPblcn,
          onChange: (value) {
            item.crqfcPblcn = value;
            //_validate();
          },
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: const Text("취득일자", style: ItemBkN14,),
        ),
        InputForm(
          onlyDigit: false,
          readOnly: true,
          hintText: '취득일자',
          valueText: item.crqfcRegYm,
          onChange: (value) {
            item.crqfcRegYm = value;
            //_validate();
          },
          onMenu: (controller) {
            DateTime date = DateFormat('yyyy-MM').parse(item.crqfcRegYm);
            showSelectMonth(
                context: context,
                title: '취득년월',
                useDay: false,
                date: date,
                onResult: (DateTime date) {
                  item.crqfcRegYm =
                  "${date.year}-${toZeroString(date.month)}";
                  controller.text = item.crqfcRegYm;
                });
          },
        ),
        const SizedBox(height: 5,),
        const Divider(color: Colors.grey,),
      ],
    );
  }

  bool _verifyConfirm() {
    if(info.histList.length>1 && info.acdmcrCd != "ACDMCR0004") {
      info.histList.removeAt(1);
    }

    // 1. 참여경로
    if(info.partcptnCoursCd.isEmpty){
      showToastMessage("[참여경로]를 선택해주세요.");
      return false;
    }
    // 1-1. 참여경로-기타
    if(info.partcptnCoursCd=="COURS0003" && info.partcptnCoursEtc.isEmpty){
      showToastMessage("[참여경로-기타]를 내용을 입력해주세요.");
      return false;
    }

    // 2. 학력사항
    if(info.acdmcrCd.isEmpty){
      showToastMessage("[학력사항]을 선택해주세요.");
      return false;
    }

    // 3. 학력정보
    for (var element in info.histList) {
      if(element.mberHistNm.isEmpty) {
        showToastMessage("[학력정보-학교명]을 입력해주세요.");
        return false;
      }
      if(element.mberHistBgngYm.isEmpty || element.mberHistEndYm.isEmpty) {
        showToastMessage("[학력정보-재학기간]을 입력해주세요.");
        return false;
      }

      if(info.acdmcrCd == "ACDMCR0003" || info.acdmcrCd == "ACDMCR0004") {
        if(element.mberHistMajor.isEmpty) {
          showToastMessage("[학력정보-전공]을 입력해주세요.");
          return false;
        }
      }
    }

    // 4. 자격사항
    for (var element in info.crqfcList) {
      if(element.crqfcNm.isEmpty) {
        showToastMessage("[자격사항-자격명]을 입력해주세요.");
        return false;
      }
      if(element.crqfcPblcn.isEmpty) {
        showToastMessage("[자격사항-발행기관]을 입력해주세요.");
        return false;
      }
      if(element.crqfcRegYm.isEmpty) {
        showToastMessage("[자격사항-츼득일자]을 입력해주세요.");
        return false;
      }
    }

    // 5. 특기사항
    if(info.actvstSpcabl.isEmpty){
      showToastMessage("[특기사항]을 입력해주세요.");
      return false;
    }

    // 6. 자기소개
    if(info.actvstIntrcn.isEmpty){
      showToastMessage("[자기소개]을 입력해주세요.");
      return false;
    }

    // 7. 활동사항
    if(info.actvstActMatter.isEmpty){
      showToastMessage("[활동사항]을 입력해주세요.");
      return false;
    }

    // 8. 지원동기
    if(info.actvstSync.isEmpty){
      showToastMessage("[지원동기]를 입력해주세요.");
      return false;
    }

    // 9. 포부
    if(info.actvstDream.isEmpty){
      showToastMessage("돌봄활동가로서의 포부를 기재해주세요.");
      return false;
    }
    return true;
  }

  //form-data : actvstSn : "123", param_atchFileId : "첨부파일"
  Future<void> _reqUpLoad(String path) async {
    Remote.fileUpLoad(
      context: context,
      method: 'appService/member/actvst_file.do',
      session: _session,
      params: {"actvstSn":info.actvstSn},
      filePath: path,
      onError: (String error) {},
      onResult: (data) {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }

        if(data['status'].toString()=="200") {
          info.imageList = [];
          info.atchFileId = data['data']['info']['atchFileId'].toString();
          if (info.atchFileId.isNotEmpty) {
            info.imageList = [ItemAttach(tag: "p", url: InfoActCourse.makeUrl(info.atchFileId))];
            setState(() {

            });
          }
        }
      },
    );
  }
}

Future<void> showActCourseInfo({
  required BuildContext context,
  required String title,
  required InfoActCourse info,
  required Function(bool bDirty, InfoActCourse info) onResult}) {
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
            onClose: (bDirty, info) {
              onResult(bDirty, info);
            },
          ),
        ),
      );
    },
  );
}