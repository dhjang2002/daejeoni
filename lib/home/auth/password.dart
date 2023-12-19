// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, library_private_types_in_public_api
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late SessionData _session;
  TextEditingController idsController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController repwdController = TextEditingController();
  bool _pwShow = false;
  bool _isConfirm = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    print(_session.toString());

    Future.microtask(() async {
      setState(() {
        idsController.text = _session.infoMember!.authMberId;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    idsController.dispose();
    pwdController.dispose();
    repwdController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext ctx) {
    const double radious = 10.0;
    return Scaffold(
        backgroundColor: Colors.white,
        //extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("비밀번호 변경"),),
      body: WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: GestureDetector(
            onTap: () { FocusScope.of(context).unfocus();},
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10,
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width-10,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Container(
                              margin: const EdgeInsets.only(top:50),
                              child: Image.asset(
                                "assets/intro/login_logo.png",
                                fit: BoxFit.fitHeight,
                                height: 100,
                              ),
                            ),

                            // curr_pwd
                            const SizedBox(height: 30.0),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: idsController,
                                readOnly: _isConfirm,
                                obscureText: _pwShow,
                                maxLines: 1,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.fromLTRB(20,18,20,18),
                                    isDense: true,
                                    hintText: '현재 비밀번호',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Image.asset("assets/icon/login_pw.png",
                                        color: Colors.black, width: 16, height: 16,)),
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Image.asset("assets/icon/login_pweye.png",
                                          color: Colors.black,
                                          width: 16, height: 16,)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _pwShow = !_pwShow;
                                      });
                                    },
                                  ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(radious)),
                                      borderSide: const BorderSide(width: 1, color: ColorG1),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(radious)),
                                      borderSide: BorderSide(width: 1, color: ColorG1),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                      const BorderRadius.all(const Radius.circular(radious)),
                                    ),
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                const Spacer(),
                                Container(
                                  width:120,
                                  //height: 80,
                                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ButtonSingle(
                                      enable: !_isConfirm,
                                      text: "확인",
                                      textSize: 14,
                                      isBottomPading: false,
                                      padding: const EdgeInsets.all(10),
                                      enableColor:Colors.black,
                                      onClick: (){
                                        _validatePassword();
                                      }),
                                )
                              ],
                            ),

                            // pwd
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: _isConfirm,
                                obscureText: _pwShow,
                                controller: pwdController,
                                maxLines: 1,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.go,
                                onSubmitted: (value) {
                                  //print("search");
                                  //doChangePassword();
                                },
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.fromLTRB(20,18,20,18),
                                    isDense: true,
                                    hintText: '새 비밀번호',
                                    hintStyle: const TextStyle(color: Colors.grey),//Colors.green),
                                    prefixIcon: Padding(
                                        padding: const EdgeInsets.all(13),
                                        child: Image.asset("assets/icon/login_pw.png",
                                          color: Colors.black, width: 16, height: 16,)
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Image.asset("assets/icon/login_pweye.png",
                                            color: Colors.black,
                                            width: 16, height: 16,)
                                      ),
                                      onPressed: () {
                                          setState(() {
                                            _pwShow = !_pwShow;
                                          });
                                      },
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(radious)),
                                      borderSide: const BorderSide(width: 1, color: ColorG1),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(radious)),
                                      borderSide: const BorderSide(width: 1, color: ColorG1),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                      const BorderRadius.all(const Radius.circular(radious)),
                                    ),
                                ),
                              ),
                            ),

                            // re_pwd
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: _isConfirm,
                                obscureText: _pwShow,
                                controller: repwdController,
                                maxLines: 1,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.go,
                                onSubmitted: (value) {
                                  //doChangePassword();
                                },
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.fromLTRB(20,18,20,18),
                                  isDense: true,
                                  hintText: '새 비밀번호 확인',
                                  hintStyle: const TextStyle(color: Colors.grey),//Colors.green),
                                  prefixIcon: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Image.asset("assets/icon/login_pw.png",
                                        color: Colors.black,
                                        width: 16,
                                        height: 16,)
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Image.asset("assets/icon/login_pweye.png",
                                          color: Colors.black,
                                          width: 16, height: 16,)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _pwShow = !_pwShow;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(radious)),
                                    borderSide: BorderSide(width: 1, color: ColorG1),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(radious)),
                                    borderSide: BorderSide(width: 1, color: ColorG1),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                    const BorderRadius.all(const Radius.circular(radious)),
                                  ),
                                ),
                              ),
                            ),

                            // 변경 버튼
                            const SizedBox(height: 40.0),
                            GestureDetector(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.fromLTRB(15,0,15,0),
                                padding: const EdgeInsets.fromLTRB(0,20,0,20),
                                decoration:  BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(radious)
                                ),
                                child: const Center(
                                    child:Text('비밀번호 변경',
                                        style: const TextStyle(
                                            color:Colors.white,
                                            fontSize:18.0,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                ),
                              ),
                              onTap: (){
                                _changeChangePassword();
                              },
                            ),
                          ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }


  Future <void> _validatePassword() async {
    FocusScope.of(context).unfocus();

    if(idsController.text.trim().isEmpty) {
      showToastMessage("현재 비밀번호를 입력하세요.");
      return;
    }

    bool flag = await _checkPassword(idsController.text.trim());
    //if(flag) {
    setState(() {
      _isConfirm = flag;
    });
    //}
  }

  Future <void> _changeChangePassword() async {
    FocusScope.of(context).unfocus();

    String password = pwdController.text.trim();
    String password_confirm = repwdController.text.trim();
    if(password.isEmpty || password.length<4) {
      showToastMessage("변경할 비밀번호를 입력하세요."
          "\n비밀번호는 8자 이상입니다.") ;
       return;
    }

    if(password_confirm.isEmpty) {
      showToastMessage("새 비밀번호 확인란에 비밀번호를 한번더 입력해주세요.");
      return;
    }

    if(password != password_confirm) {
      showToastMessage("변경할 비밀번호가 일치하지 않습니다."
          "\n 비밀번호를 확인해주세요.");
      return;
    }

    await Remote.apiPost(
        context: context,
        session: _session,
        method: "/appService/member/password_change2.do",
        params: {
          "password":password,
          "password_confirm":password_confirm
        },
        onError: (String error){
          print(error);
        },
        onResult: (dynamic data) {

          if (kDebugMode) {
            var logger = Logger();
            logger.d(data);
          }

          if(data['status'].toString()=="200"){
            showOkDialogBox(
                context: context,
                title: "확인",
                message: "비밀번호가 변경되었습니다."
                "\n로그인후 사용하세요.",
                onResult: (bOK){
                  _session.setLogout(false);
                  Navigator.pop(context);
                }
            );
          }
          else {
            showToastMessage(data['message']);
          }
        },
    );
  }

  Future <bool> _checkPassword(String password) async {
    bool flag = false;
    await Remote.apiPost(
        context: context,
        session: _session,
        method: "/appService/member/password_change1.do",
        params: {
          "password":password,
        },
        onError: (String error){
          print(error);
        },
        onResult: (dynamic data) {

          if (kDebugMode) {
            var logger = Logger();
            logger.d(data);
          }

          if(data['status'].toString()=="200"){
            flag = true;
          } else {
            showToastMessage(data['message']);
          }
        },
    );
    return flag;
  }

  _onBackPressed(BuildContext context) {
    return Future(() => true);
  }

}
