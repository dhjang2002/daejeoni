// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, library_private_types_in_public_api, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore

import 'dart:io';
import 'package:daejeoni/common/cardCheckBox.dart';
import 'package:daejeoni/home/website.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/remote/remote.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SessionData _session;
  TextEditingController idsController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool _pwShow = true;
  bool _autoLogin = false;

  @override
  void initState() {
    _session = Provider.of<SessionData>(context, listen: false);
    _autoLogin = (_session.AutoLogin=="Y");
    Future.microtask(() async {
      setState(() {
        idsController.text = _session.UserID!;
      });
    });
    super.initState();

  }

  @override
  Widget build(BuildContext ctx) {
    const double radious = 10.0;
    //final double size = MediaQuery.of(context).size.width/3*5;
    return Scaffold(
      backgroundColor: Colors.white,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""),

        leading: Visibility(
          visible: true,
          child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 26,),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ),
      body: WillPopScope(
          onWillPop: () => _onBackPressed(context),
          child: GestureDetector(
              onTap: () { FocusScope.of(context).unfocus(); },
              child: SafeArea(
                child:Container(
                  color: Colors.transparent,
                  //width: MediaQuery.of(context).size.width - 20,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top:10),
                          child: Image.asset(
                            "assets/intro/login_logo.png",
                            fit: BoxFit.fitHeight,
                            height: 100,
                          ),
                        ),

                        //const Spacer(),
                        const SizedBox(height: 40,),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: idsController,
                            maxLines: 1,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: ItemBkN16,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(20,18,20,18),
                              isDense: true,
                              hintText: '사용자 계정',
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Image.asset("assets/icon/login_id.png",
                                    color: Colors.black, width: 16, height: 16,)),
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

                        // pwd
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            obscureText: _pwShow,
                            controller: pwdController,
                            maxLines: 1,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {
                              //print("search");
                              //doLogin();
                            },
                            style: ItemBkN16,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(20,18,20,18),
                              isDense: true,
                              hintText: '비밀번호',
                              hintStyle: const TextStyle(color: Colors.grey),//Colors.green),
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Image.asset("assets/icon/login_pw.png",
                                    color: Colors.black, width: 16, height: 16,)),
                              suffixIcon: IconButton(
                                icon: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Image.asset("assets/icon/login_pweye.png",
                                      color: Colors.black, width: 16, height: 16,)),
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


                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                            CardCheckbox(
                              visible: true,//_pickList.isNotEmpty,
                              text:"자동 로그인",
                              width: 120,
                              initStatus: _autoLogin,
                              onChange: (bool value) {
                                setState(() {
                                  _autoLogin = value;
                                  _session.AutoLogin = (_autoLogin) ? "Y" : "N";
                                });
                              },
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                findPassword(context, _session, false);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: const Text("비밀번호를 잊으셨나요?",
                                style: ItemB1N14,),
                              ),
                            )
                          ],
                        ),
                  ),


                        // 로그인 버튼
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(top:30),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 60,
                            constraints: BoxConstraints(),
                            child: Image.asset(
                              "assets/intro/btn_loginID.png",
                              width: 360,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          onTap: () async {
                            await _userLogin();
                            if(_session.isSigned()) {
                              Navigator.pop(context);
                            }
                          },
                        ),

                        Visibility(
                          visible: !_session.bIsExamine || _session.iDevBuildNum < _session.iExamineBuildNum,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                              child: const Text("------------- OR -------------"),
                            ),
                        ),

                        // kakao
                        Visibility(
                            visible: !_session.bIsExamine || _session.iDevBuildNum < _session.iExamineBuildNum,
                            child: GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top:10),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                constraints: BoxConstraints(),
                                height: 60,
                                child: Image.asset(
                                  "assets/intro/btn_kakao.png",
                                  width: 360,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              onTap: () {
                                _kakaoLogin();
                              },
                            ),
                        ),

                        //const SizedBox(height: 20.0),
                        // naver
                        Visibility(
                            visible: !_session.bIsExamine || _session.iDevBuildNum < _session.iExamineBuildNum,
                            child: GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top:15),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                height: 60,
                                constraints: BoxConstraints(),
                                child: Image.asset(
                                  "assets/intro/btn_naver.png",
                                  width: 360,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              onTap: () {
                                _naverLogin();
                              },
                            ),
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("회원이 아니신가요?  ",
                              style: ItemBkN14,),
                              GestureDetector(
                                onTap: () {
                                  doRegist(context);
                                  //registSite(context, _session, true);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: const Text("회원가입",
                                    style: ItemBuN16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              )
          )
      ),
    );
  }

  Future<void> _appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',
        redirectUri: kIsWeb
            ? Uri.parse(
                "https://") //Uri.parse('https://${window.location.host}/')
            : Uri.parse(
                'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
              ),
      ),
      nonce: 'example-nonce',
      state: 'example-state',
    );

    // ignore: avoid_print
    print(credential);

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null) 'firstName': credential.givenName!,
        if (credential.familyName != null) 'lastName': credential.familyName!,
        'useBundleId':
            !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    //print(session);
  }

  Future <void> _kakaoLogin() async {
    String access_token = await kakaoSigning(context);
    print("******************************");
    print("kakao_token:$access_token");

    if(access_token.isNotEmpty) {
      _reqSnsSigning("kakaoapi", access_token);
    } else {
        showToastMessage("Kakao 로그인에 실패하였습니다.");
    }
  }

  Future <void> _naverLogin() async {
    showToastMessage("서비스 준비중입니다.");
    return;
    /*
    String access_token = await NaverSigning(context);
    if(access_token.isNotEmpty) {
      _reqSnsSigning("naverapi", access_token);
    }
     */
  }

  Future <void> _reqSnsSigning(String authType, String token) async {
    _session.AccessToken = "";
    if (token.isNotEmpty) {
      await Remote.apiPost(
          //bTrace: true,
          timeOut: 3,
          context: context,
          session: _session,
          method: "appService/member/social_login.do",
          params: {
            "per_auth_type":authType,
            "per_auth": token,
          },
          onError: (String error) {
            //showToastMessage("$error");
          },
          onResult: (dynamic data) async {
            if (kDebugMode) {
              var logger = Logger();
              logger.d(data);
            }

            if(data['status'].toString()=="200") {
              await _session.setLogin(data['token'].toString().trim());
              await SigningWithToken(context, _session);
              _session.notifyListeners();
            } else {
              showToastMessage(data['message']);
            }
          },
      );

      //showToastMessage("[2<] *******" );
      if(_session.isSigned()) {
        Navigator.pop(context);
      }
    }
  }

  _onBackPressed(BuildContext context) {
    return Future(() => true);
  }

  Future <void> _userLogin() async {
    FocusScope.of(context).unfocus();

    String ids = idsController.text.trim();
    String pwd = pwdController.text.trim();
    if(ids.isEmpty) {
      showToastMessage("아이디를 입력해주세요.");
      return;
    }

    if(pwd.isEmpty) {
      showToastMessage("비밀번호를 입력해주세요.");
      return;
    }
    // ids = "demon2002";
    // pwd = "qwer1234";
    // { "id" : "seabow22", "password": "Qhdvkfdl12#" }
    _session.AccessToken = "";
    await Remote.apiPost(
          timeOut: 3,
          context: context,
          session: _session,
          method: "appService/member/login.do",
          params: {"id": ids, "password": pwd},
          onError: (String error) {},
          onResult: (dynamic data) async {
            if (kDebugMode) {
              var logger = Logger();
              logger.d(data);
            }

            if(data['status'].toString()=="200") {
              _session.setLogin(data['token'].toString().trim());
              await SigningWithToken(context, _session);
              _session.notifyListeners();
            } else {
              showToastMessage(data['message']);
            }
          },
    );
  }
}
