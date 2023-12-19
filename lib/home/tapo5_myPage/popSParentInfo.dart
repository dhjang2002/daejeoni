// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:daejeoni/common/cardGCheck.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemSParent.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final ItemSParent info;
  final Function(bool bDirty, ItemSParent info) onClose;
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

  ItemSParent info = ItemSParent();
  bool bEtcCheck = false;

  final List<GRadioItem> ynList = [
    GRadioItem(label: "예", tag: "Y"),
    GRadioItem(label: "아니오", tag: "N")
  ];

  final List<GCheckItem> careTypeList = [
    GCheckItem(label: "돌봄(일시・긴급돌봄)", tag: "TY0001"),
    GCheckItem(label: "공동활동(체험,놀이,취미,독서)", tag: "TY0002"),
    GCheckItem(label: "나눔(반찬,육아・교육・생활용품)", tag: "TY0003"),
    GCheckItem(label: "소통(육아・생활정보,가족교육・상담)", tag: "TY0004"),
    GCheckItem(label: "기타", tag: "TY0005"),
  ];

  final List<GRadioItem> periodList = [
    GRadioItem(label: "매일", tag: "CYCLE0001"),
    GRadioItem(label: "주2~3회", tag: "CYCLE0002"),
    GRadioItem(label: "주1회", tag: "CYCLE0003"),
    GRadioItem(label: "월1~3회", tag: "CYCLE0004")
  ];

  final List<GRadioItem> friendList = [
    GRadioItem(label: "가까운 지역", tag: "Frnd0001"),
    GRadioItem(label: "아이들 나이 및 학습 수준", tag: "Frnd0002"),
    GRadioItem(label: "엄마들 성격 및 호감도", tag: "Frnd0003"),
  ];

  @override
  void initState() {
    info = widget.info;
    bEtcCheck = info.cmmntyTyCd.contains("TY0005");
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
        elevation: 0.5,
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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 여기에 다른 위젯들을 추가합니다.
                        const Text("공동육아나눔터 신청내역", style: ItemBkB16,),
                        //Divider(height: 20,),
                        // 1. 소식 수신여부
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
                                padding: const EdgeInsets.only(left:10),
                                width: LabelSize,
                                child: const Text("소식 수신 여부", style: ItemBkN14,),
                              ),

                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left:10),
                                    height: LabelHeight,
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(left: BSG5,),
                                    ),
                                    child: CardGRadio(
                                      aList: ynList,
                                      initValue: info.newsRcptnYn,
                                      tag: '',
                                      isVertical: false,
                                      isUseCode: true,
                                      onSubmit: (String tag, String answerTag, String answerText) {
                                        setState(() {
                                          info.newsRcptnYn = answerTag;
                                        });
                                        _validate();
                                      },
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),

                        // 2. 희망 품앗이 형태
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
                                child: const Text("희망 품앗이 형태\n(복수 응답 가능)", style: ItemBkN14,),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,15,5,15),
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(left: BSG5,),
                                    ),
                                    child: Column(
                                      children: [
                                        CardGCheck(
                                          aList: careTypeList,
                                          initValue: info.cmmntyTyCd,
                                          tag: '',
                                          isVertical: true,
                                          isUseCode: true,
                                          onSubmit: (String tag, String answerTag, String answerText) {
                                            setState(() {
                                              info.cmmntyTyCd = answerTag;
                                              bEtcCheck = info.cmmntyTyCd.contains("TY0005");
                                            });
                                            _validate();
                                          },
                                        ),
                                        Visibility(
                                            visible: true,
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                              child: InputForm(
                                                readOnly: !bEtcCheck,
                                                onlyDigit: false,
                                                hintText: '직접 작성',
                                                valueText: info.cmmntyTyEtc,
                                                onChange: (value) {
                                                  info.cmmntyTyEtc = value;
                                                  _validate();
                                                },
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        // 3. 활동주기
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
                                child: const Text("활동주기", style: ItemBkN14,),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,10,5,10),
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(left: BSG5,),
                                    ),
                                    child: CardGRadio(
                                      aList: periodList,
                                      initValue: info.actCycleCd,
                                      tag: '',
                                      isVertical: true,
                                      isUseCode: true,
                                      onSubmit: (String tag, String answerTag, String answerText) {
                                        setState(() {
                                          info.actCycleCd = answerTag;
                                        });
                                        _validate();
                                      },
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        // 4. 희망 커뮤니티 친구
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
                                child: const Text("희망\n커뮤니티 친구", style: ItemBkN14,),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10,10,5,10),
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(left: BSG5,),
                                    ),
                                    child: CardGRadio(
                                      aList: friendList,
                                      initValue: info.cmmntyFrndCd,
                                      tag: '',
                                      isVertical: true,
                                      isUseCode: true,
                                      onSubmit: (String tag, String answerTag, String answerText) {
                                        setState(() {
                                          info.cmmntyFrndCd = answerTag;
                                        });
                                        _validate();
                                      },
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        // 5. 봉사참여동기
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
                                    //height: LabelHeight,
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(left: BSG5,),
                                    ),
                                    child: InputForm(
                                      maxLines: 10,
                                      minLines: 5,
                                      onlyDigit: false,
                                      hintText: '이름',
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

  void _validate() {
    _bEnable = info.newsRcptnYn.isNotEmpty
        && info.actCycleCd.isNotEmpty;
        //&& info.parntsSexdstn.isNotEmpty;
    setState(() {

    });
  }

  bool _verifyConfirm() {
    // 1. 소식 수신여부
    if(info.newsRcptnYn.isEmpty){
      showToastMessage("[소식 수신여부]를 선택해주세요.");
      return false;
    }

    // 2. 희망 품앗이 형태
    if(info.cmmntyTyCd.isEmpty){
      showToastMessage("[희망 품앗이 형태]를 선택해주세요.");
      return false;
    }

    // 2-1. 희망 품앗이 형태
    if(info.cmmntyTyCd.contains("TY0005") && info.cmmntyTyEtc.isEmpty){
      showToastMessage("[희망 품앗이 형태-기타]를 입력해주세요.");
      return false;
    }

    // 3. 활동주기
    if(info.actCycleCd.isEmpty){
      showToastMessage("[활동주기]를 선택해주세요.");
      return false;
    }

    // 3. 희망커뮤니티 친구
    if(info.cmmntyFrndCd.isEmpty){
      showToastMessage("[희망커뮤니티 친구]를 선택해주세요.");
      return false;
    }

    // 4. 봉사참여 동기
    if(info.srvcPartcptnSync.isEmpty){
      showToastMessage("[봉사참여동기]를 입력해주세요.");
      return false;
    }

    return true;
  }
}

Future<void> showSParentInfo({
  required BuildContext context,
  required String title,
  required ItemSParent info,
  required Function(bool bDirty, ItemSParent info) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  //double viewHeight = MediaQuery.of(context).size.height * 0.85;
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