// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/models/InfoMember.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

//const Color _colorGrayBack = Color(0xFFF4F4F4);

class UserInfo extends StatefulWidget {
  final String title;
  final Function(bool bDirty)? onClose;
  final bool? isPopup;
  const UserInfo({
    Key? key,
    required this.title,
    required this.onClose,
    this.isPopup = false,
  }) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  late TextEditingController siguController;
  late TextEditingController zipController;
  bool _bDirty = false;
  bool _bready = false;

  late InfoMember info;
  late SessionData _session;

  final List<GRadioItem> ynList = [GRadioItem(label: "예", tag: "Y"), GRadioItem(label: "아니오", tag: "N")];
  final List<GRadioItem> sexList = [GRadioItem(label: "남아", tag: "1"), GRadioItem(label: "여아", tag: "2")];

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    info = _session.infoMember!;
    _bready = true;
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
      //backgroundColor: _colorGrayBack,
      appBar: AppBar(
        elevation: 0.5,
        //backgroundColor: _colorGrayBack,
        title: const Text("내정보"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Visibility(
          visible: !widget.isPopup!,
          child: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                size: app_top_size_back,
              ),
              onPressed: () async {
                Navigator.pop(context);
              }),
        ),
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
      ),
      body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    const szLableWidth = 70.0;
    if(!_bready) {
      return Container();
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                    Expanded(child: SizedBox(
                      //width: 120,
                      child: InputForm(
                        onlyDigit: false,
                        readOnly: true,
                        hintText: 'ID',
                        valueText: info.mberId,
                        onChange: (value) {
                          info.mberId = value;
                          _validate();
                        },
                      ),
                    )),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),

              // 소셜 로그인
              Visibility(
                visible: !_session.bIsExamine || _session.iDevBuildNum < _session.iExamineBuildNum,
                child: Container(
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
              ),


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
                            hintText: '이름',
                            valueText: info.mberNm,
                            onChange: (value) {
                              info.mberNm = value;
                              _validate();
                            },
                          ),
                        )
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),

              // 생년월일
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
                        onlyDigit: false,
                        hintText: '휴대폰 번호',
                        valueText: info.mberMblTelno,
                        onChange: (value) {
                          info.mberMblTelno = value;
                          _validate();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 자택전화
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
                      child: const Text("자택번호", style: ItemBkN14,),
                    ),
                    SizedBox(
                      width: 160,
                      child: InputForm(
                        onlyDigit: false,
                        hintText: '자택번호',
                        valueText: info.mberCoTelno,
                        onChange: (value) {
                          info.mberCoTelno = value;
                          _validate();
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
                        hintText: '이메일',
                        valueText: info.mberEml,
                        onChange: (value) {
                          info.mberEml = value;
                          _validate();
                        },
                      ),
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),

              const SizedBox(height: 30,),
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
              Visibility(
                visible: true,
                child:ButtonSingle(
                    visible: true,
                    isBottomPading: false,
                    text: "수정하기",
                    enable: _bDirty,
                    enableTextColor: Colors.white,
                    enableColor: const Color(0xFF58BB9C),
                    onClick: () async {
                      bool flag = await _reqUpdate();
                      if(widget.onClose != null) {
                        widget.onClose!(flag);
                      }
                      Navigator.pop(context);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _validate() {
    // _bEnable = info.parntsChldrnNm.isNotEmpty
    //     && info.parntsChldrnBrdt.isNotEmpty
    //     && info.parntsSexdstn.isNotEmpty;
    _bDirty = true;
    setState(() {

    });
  }

  Future <bool> _reqUpdate() async {
    bool flag = false;
    await Remote.apiPost(
      context: context,
      session: _session,
      method: "appService/member/member_update.do",
      params: info.toUpdateParam(),
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

  Future<void> _reqJoin(String per_auth_type) async {
    if(per_auth_type=="naverapi") {
      showToastMessage("서비스 준비중입니다.");
      return;
    }

    String token = await kakaoSigning(context);
    if(token.isNotEmpty) {
      await Remote.apiPost(
          context: context,
          session: _session,
          method: "appService/member/social_link.do",
          params: {
            "per_auth_type":per_auth_type,
            "per_auth": token,
          },
          onError: (String error) {},
          onResult: (dynamic data) async {
            if (kDebugMode) {
              var logger = Logger();
              logger.d(data);
            }

            showOkDialogBox(context: context,
                title: "확인",
                message: data['message']
            );
          },
      );
    } else {
      showToastMessage("로그인 오류입니다.");
    }

  }

}

Future <void> updateUserInfo({
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
          child: UserInfo(
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