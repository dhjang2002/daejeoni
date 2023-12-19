// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/InfoMember.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:flutter_rating_stars/generated/assets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
class Regist extends StatefulWidget {
  final String title;
  // final Function(bool bDirty)? onClose;
  // final bool? isPopup;
  const Regist({
    Key? key,
    required this.title,
    // required this.onClose,
    // this.isPopup = false,
  }) : super(key: key);

  @override
  State<Regist> createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  bool _bready = false;


  bool _bCheckID = false;
  bool _bvalidID = false;
  InfoMember info = InfoMember();
  late SessionData _session;

  // final List<GRadioItem> ynList = [GRadioItem(label: "예", tag: "Y"), GRadioItem(label: "아니오", tag: "N")];
  // final List<GRadioItem> sexList = [GRadioItem(label: "남아", tag: "1"), GRadioItem(label: "여아", tag: "2")];

  String agreeText = "";
  String serviceText = "";
  bool bAgree = false;
  bool bService = false;
  bool _bAgreeChecked  = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    Future.microtask(() async {
      agreeText   = await rootBundle.loadString('assets/files/01_agree.txt'); // 텍스트 파일 경로
      serviceText = await rootBundle.loadString('assets/files/02_service.txt'); // 텍스트 파일 경로
      setState(() {});
      _bready = true;
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: _colorGrayBack,
      appBar: AppBar(
        elevation: 0.5,
        //backgroundColor: _colorGrayBack,
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                size: app_top_size_back,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
        ),
        /*
        actions: [
          Visibility(
            visible: widget.isPopup!,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
          Visibility(
            visible: false,//!widget.isPopup!,
            child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: app_top_size_refresh,
                ),
                onPressed: () async {
                  //Navigator.pop(context);
                }),
          ),
        ],
        */
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
          child: _buildBody(),
        )
      ),
    );
  }

  Widget _buildBody() {
    const szLableWidth = 86.0;
    //final sizeHalf = (MediaQuery.of(context).size.height-50)/2;
    if(!_bready) {
      return Container();
    }
    return Container(
      color: (_bAgreeChecked) ? Colors.white : Colors.grey[100],
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Stack(
        children: [
          Positioned(
              left: 0,top: 0, right: 0, bottom: 0,
              child: Visibility(
                visible: _bAgreeChecked,
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Image.asset("assets/quick/sub_icon_03.png", height: 16, fit: BoxFit.fitHeight,),
                            const SizedBox(width: 5,),
                            const Text("계정정보", style: ItemBkB16,),
                          ],
                        ),

                        const SizedBox(height: 10,),

                        // 로그인 ID
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("로그인 ID", style: ItemBkN14,),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    child: InputForm(
                                      onlyDigit: false,
                                      readOnly: false,
                                      hintText: '로그인 ID',
                                      valueText: info.mberId,
                                      onChange: (value) {
                                        info.mberId = value;
                                        _validateId();
                                      },
                                    ),
                                  )
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: 60,
                                height: 32,
                                child: ButtonState(
                                  enable: _bvalidID,
                                  text: '중복확인',
                                  borderColor: (_bvalidID) ? const Color(0xFF58BB9C) : Colors.grey,
                                  enableColor: const Color(0xFF58BB9C),
                                  //disableTextColor: Colors.black,
                                  textStyle: TextStyle(
                                      fontSize: 10,
                                      color: (_bvalidID) ? Colors.white : Colors.black
                                  ),
                                  onClick: () async {
                                    if(_bvalidID) {
                                      await _reqCheckDuplicate();
                                    } else {
                                      showToastMessage("사용자 계정은 4~20자입니다.");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 비밀번호
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("비밀번호", style: ItemBkN14,),
                              ),
                              Expanded(child: SizedBox(
                                //width: 120,
                                child: InputForm(
                                  onlyDigit: false,
                                  readOnly: !_bCheckID,
                                  hintText: '비밀번호',
                                  valueText: info.mberPassword,
                                  onChange: (value) {
                                    info.mberPassword = value;
                                  },
                                ),
                              )),
                              const SizedBox(width: 5,),
                            ],
                          ),
                        ),

                        // 비밀번호 확인
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5, bottom: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("비밀번호 확인", style: ItemBkN14,),
                              ),
                              Expanded(child: SizedBox(
                                //width: 120,
                                child: InputForm(
                                  onlyDigit: false,
                                  readOnly: !_bCheckID,
                                  hintText: '비밀번호 확인',
                                  valueText: info.mberType,
                                  onChange: (value) {
                                    info.mberType = value;
                                  },
                                ),
                              )),
                              const SizedBox(width: 5,),
                            ],
                          ),
                        ),


                        /*
              // 소셜 로그인
              Container(
                //margin: const EdgeInsets.only(top:5),
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5, bottom: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("로그인 연결", style: ItemBkN14,),
                    ),
                    // kakao
                    Expanded(
                      child: GestureDetector(
                        child: SizedBox(
                          //margin: const EdgeInsets.only(top:10),
                          //padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          child: Image.asset("assets/intro/btn_kakao.png", fit: BoxFit.fitHeight,),
                        ),
                        onTap: () {
                          _reqJoin("kakaoapi");
                        },
                      ),
                    ),

                    const SizedBox(width: 10,),
                    // naver
                    Expanded(
                        child: GestureDetector(
                          child: SizedBox(
                            //margin: const EdgeInsets.only(top:15),
                            //padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            child: Image.asset("assets/intro/btn_naver.png", fit: BoxFit.fitHeight,),
                          ),
                          onTap: () {
                            _reqJoin("naverapi");
                          },
                        )
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              */

                        const SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/quick/sub_icon_04.png", width: 16, fit: BoxFit.cover,),
                            const SizedBox(width: 5,),
                            const Text("사용자 정보", style: ItemBkB16,),
                          ],
                        ),

                        const SizedBox(height: 10,),
                        // 이름
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("이름", style: ItemBkN14,),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    width: 120,
                                    child: InputForm(
                                      onlyDigit: false,
                                      readOnly: !_bCheckID,
                                      hintText: '이름',
                                      valueText: info.mberNm,
                                      onChange: (value) {
                                        info.mberNm = value;
                                      },
                                    ),
                                  )
                              ),
                              const SizedBox(width: 5,),
                            ],
                          ),
                        ),

                        // 생년월일
                        /*
              Container(
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("생년월일", style: ItemBkN14,),
                    ),

                    SizedBox(
                      width: 120,
                      child: InputForm(
                        onlyDigit: false,
                        readOnly:true,
                        hintText: '생년월일',
                        valueText: info.mberBrdt,
                        onChange: (value) {},
                        onMenu: (controller) async {
                          String dateString = "${info.mberBrdt.substring(0,4)}"
                              "-${info.mberBrdt.substring(4,6)}"
                              "-${info.mberBrdt.substring(6,8)}";
                          DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
                          showSelectMonth(
                              context: context,
                              title: '생년월일',
                              useDay: true,
                              date: date,
                              onResult: (DateTime date) {
                                info.mberBrdt
                                = "${date.year}${toZeroString(date.month)}${toZeroString(date.day)}";
                                controller.text = info.mberBrdt;
                              });
                          _validate();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              */
                        // 휴대폰
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("휴대폰", style: ItemBkN14,),
                              ),
                              SizedBox(
                                width: 160,
                                child: InputForm(
                                  onlyDigit: true,
                                  readOnly: !_bCheckID,
                                  hintText: '휴대폰 번호',
                                  valueText: info.mberMblTelno,
                                  onChange: (value) {
                                    info.mberMblTelno = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),


                        // 이메일
                        Container(
                          padding: const EdgeInsets.fromLTRB(10,5,0,5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BSG5, left: BSG5, right: BSG5, bottom: BSG5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: szLableWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BSG5),
                                ),
                                child: const Text("이메일", style: ItemBkN14,),
                              ),

                              Expanded(
                                child: InputForm(
                                  onlyDigit: false,
                                  readOnly: !_bCheckID,
                                  hintText: '이메일',
                                  valueText: info.mberEml,
                                  onChange: (value) {
                                    info.mberEml = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5,),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30,),
                        /*
              Row(
                children: [
                  Image.asset("assets/quick/sub_icon_05.png", height: 16, fit: BoxFit.fitHeight,),
                  const SizedBox(width: 5,),
                  const Text("거주지 정보", style: ItemBkB16,),
                ],
              ),
              const SizedBox(height: 10,),
              // 자치구
              Container(
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("자치구", style: ItemBkN14,),
                    ),

                    SizedBox(
                      width: 100,
                      child: InputForm(
                        onlyDigit: false,
                        readOnly:true,
                        hintText: '자치구',
                        valueText: info.mberAtdrc,
                        onControl: (controller) {
                          siguController = controller;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 우편번호
              Container(
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("우편번호", style: ItemBkN14,),
                    ),

                    SizedBox(
                      width: 120,
                      child: InputForm(
                        onlyDigit: false,
                        readOnly:true,
                        hintText: '우편번호',
                        valueText: info.mberZip,
                        onControl: (controller) {
                          zipController = controller;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 기본주소
              Container(
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("기본주소", style: ItemBkN14,),
                    ),
                    Expanded(
                      child: InputForm(
                        onlyDigit: false,
                        readOnly:true,
                        minLines: 2,
                        maxLines: 5,
                        hintText: '기본주소',
                        valueText: info.mberAdres,
                        onChange: (value) {},
                        onMenu: (controller) async {
                          Kpostal result = await Navigator.push(context,
                              MaterialPageRoute(builder: (_) => KpostalView(
                                //kakaoKey: kakao_javaScriptAppKey,
                              ))
                          );
                          info.mberAdres = result.address;
                          controller.text = info.mberAdres;
                          //List spList = info.mberAdres.split(" ");
                          info.mberAtdrc = result.sigungu;//spList[1];
                          siguController.text = info.mberAtdrc;
                          info.mberZip = result.postCode;
                          zipController.text = info.mberZip;
                          _validate();
                        },
                      ),
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),

              // 상세주소
              Container(
                padding: const EdgeInsets.fromLTRB(10,5,0,5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BSG5, left: BSG5, right: BSG5, bottom: BSG5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: szLableWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(right: BSG5),
                      ),
                      child: const Text("상세주소", style: ItemBkN14,),
                    ),
                    Expanded(
                      child: InputForm(
                        onlyDigit: false,
                        readOnly:false,
                        hintText: '상세주소',
                        valueText: info.mberDetailAdres,
                        onChange: (value) {
                          info.mberDetailAdres = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              */
                        Visibility(
                          visible: true,
                          child:ButtonSingle(
                              visible: true,
                              isBottomPading: false,
                              text: "회원가입",
                              enable: _bCheckID,
                              enableTextColor: Colors.white,
                              enableColor: const Color(0xFF58BB9C),
                              onClick: () async {
                                if (_checkValidate()) {
                                  if (await _reqRegist()) {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
              left: 0,top: 0, right: 0, bottom: 0,
              child: Visibility(
                visible: !_bAgreeChecked,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.fromLTRB(10,0,10,0),
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    child: Text(agreeText),
                                  )
                              ),
                          ),
                          Container(
                            //color: Colors.amber,
                            height: 30,
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Spacer(),
                                Checkbox(
                                    value: bAgree, onChanged: (value){
                                  setState(() {
                                    bAgree = value!;
                                  });
                                }),

                                Text("이용약관에 동의합니다.")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Divider(height: 10,),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Text(serviceText),
                                )
                            ),
                          ),
                          Container(
                            //color: Colors.amber,
                            margin: EdgeInsets.only(bottom: 20),
                            height: 30,
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Spacer(),
                                Checkbox(
                                    value: bService, onChanged: (value){
                                  setState(() {
                                    bService = value!;
                                  });
                                }),

                                Text("개인정보 처리방침에 동의합니다.")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:5),
                      child: ButtonSingle(
                        enable: bAgree && bService,
                        enableColor: const Color(0xFF58BB9C),
                        isBottomPading: false,
                        text: '다음',
                        onClick: () {
                          setState(() {
                            _bAgreeChecked = true;
                          });
                        },),
                    ),

                  ],
                ),
              )
          ),
        ],
      )
    );
  }

  // 4 ~ 20
  void _validateId() {
    String ids = info.mberId.trim();
    _bvalidID = false;
    if(ids.length>=4 && ids.length<=22) {
      _bvalidID = true;
    }
    setState(() {});
  }

  bool _checkValidate() {
    if(info.mberPassword.length<8 || info.mberPassword.length>16) {
      showToastMessage("비밀번호는 8~16로 입력해주세요.");
      return false;
    }
    if(info.mberType != info.mberPassword) {
      showToastMessage("비밀번호가 일치하지 않습니다.");
      return false;
    }
    if(info.mberNm.isEmpty) {
      showToastMessage("이름을 입력해주세요.");
      return false;
    }
    if(info.mberMblTelno.isEmpty) {
      showToastMessage("휴대폰 번호는 필수항목입니다.");
      return false;
    }
    if(info.mberEml.isEmpty) {
      showToastMessage("이메일은 필수항목입니다.");
      return false;
    }
    return true;
  }

  Future <bool> _reqRegist() async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/regist.do",
      params: {
        "mberId" : info.mberId,
        "mberPassord" : info.mberPassword,
        "mberNm" : info.mberNm,
        //"mberSexdstn" : "1",
        "mberMblTelno": info.mberMblTelno,
        "mberEml": info.mberEml
      },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          flag = true;
        }
        showToastMessage(data['message']);
      },
    );
    return flag;
  }

  Future <void> _reqCheckDuplicate() async {
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/id_check.do",
      params: {"mberId": info.mberId.trim() },
      onError: (String error) {},
      onResult: (dynamic data) async {
        if (kDebugMode) {
          var logger = Logger();
          logger.d(data);
        }
        if(data['status'].toString()=="200") {
          setState(() {
            _bCheckID = true;
          });
        }
        showToastMessage(data['message']);
      },
    );
  }
}

/*
Future <void> updateRegist({
  required BuildContext context,
  required String title,
  required Function(bool bDirty) onResult}) {
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
          child: Regist(
            title: title,
            isPopup: true,
            onClose: (bDirty) {
              onResult(bDirty);
            },
          ),
        ),
      );
    },
  );
}
*/
