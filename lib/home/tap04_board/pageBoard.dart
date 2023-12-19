// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names
import 'dart:convert';
import 'dart:io';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/home/auth/signing.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PageBoard extends StatefulWidget {
  final Function() onDrawer;
  final Function() onNotice;
  final Function() onSignin;
  final Function(int page) onPage;
  const PageBoard({Key? key,
    required this.onDrawer,
    required this.onNotice,
    required this.onSignin,
    required this.onPage,
  }) : super(key: key);

  @override
  State<PageBoard> createState() => _PageBoardState();
}

class _PageBoardState extends State<PageBoard> {

  //late WebViewController _webViewController;
  bool _isError = false;
  bool _bReady = false;
  String board_url = "";
  late SessionData _session;

  @override
  void initState() {
    if(Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    _session   = Provider.of<SessionData>(context, listen: false);
    board_url = getUrlParam(
      website: '$SERVER/appService/gotoUrl.do',
      data: {
        "returnUrl":"/dolbom/sosig/sotong/list.do",
        "jwtToken":_session.AccessToken
      },
    );

    int delay = 300;
    if (Platform.isAndroid) {
      delay = 100;
    }

    Future.delayed(Duration(milliseconds: delay), () {
      setState(() {
        _bReady = true;
      });
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
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("assets/intro/intro_logo.png",
            height: 38, fit: BoxFit.fitHeight),
        leading: Visibility(
          visible: true, //(_tabIndex == 0), //(_m_isSigned && _bSearch),
          child: IconButton(
              icon: Image.asset(
                "assets/icon/top_menu.png",
                height: app_top_size_menu, fit: BoxFit.fitHeight,
                color: Colors
                    .black, //(_tabIndex == 4) ? Colors.black : Colors.white,
              ),
              onPressed: () {
                widget.onDrawer();
              }),
        ),
        actions: [
          Visibility(
            visible: true, //(_bSearch && _tabIndex != 0),
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: getNotificationIcon(
                    isDenaied: _session.bDeniedNotice,
                    isRecevied: _session.bOnNotice
                ),
                onPressed: () {
                  setState(() {
                    widget.onNotice();
                  });
                }),
          ),
          // 로그인
          Visibility(
            visible: _session.IsSigned != "Y", //(_bSearch && _tabIndex != 0),
            child: IconButton(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(),
                icon: Image.asset("assets/quick/user.png",
                  height: app_top_size_user, fit: BoxFit.fitHeight,
                ),
                onPressed: () {
                  setState(() {
                    widget.onSignin();
                  });
                }),
          ),
        ],
      ),
      body: _buildWebview(),
    );
  }

  Widget _buildWebview() {
    if(!_bReady) {
      return const Center(child: const CircularProgressIndicator());
    }

    if(_isError) {
      return _errorPage();
    }

    return SafeArea(
        child: WebView(
          userAgent: USER_AGENT,
          zoomEnabled:true,
          initialUrl: board_url,
          javascriptMode: JavascriptMode.unrestricted,
          // onWebViewCreated: (WebViewController webViewController) {
          //   _webViewController = webViewController;
          // },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },

          javascriptChannels: <JavascriptChannel> {
            _fromAppJavascriptChannel(context),
            //_fileUploadJavascriptChannel(context),
          },

          onWebResourceError: (WebResourceError error) {
            print('WebView Error: [${error.errorCode}], ${error.description}');
            if (error.errorCode == -2 || error.errorCode==-1009) {
              setState(() {
                _isError = true;
              });
            }
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }

            print('navigationDelegate:${request.url}}');
            if (request.url.startsWith('file-upload://')) {
              //_handleFileUpload(request.url);
              return NavigationDecision.prevent;
            }
            // 파일 다운로드 요청을 가로채기 위해 navigationDelegate 사용
            if (request.url.contains('FileDown.do?atchFileId=')) {
              downloadFileWithHttp(request.url); // 파일 다운로드 처리 메서드 호출
              return NavigationDecision.prevent; // WebView에서 페이지 로드를 막음
            }

            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },

          onPageStarted: (String url) {
            print('Page started loading: $url');
          },

          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },

          gestureNavigationEnabled: true,
        )
    );
  }

  /*
  JavascriptChannel _fileUploadJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'FileUploadChannel',
      onMessageReceived: (JavascriptMessage message) {
        // 파일 업로드 요청을 WebView로 전달합니다.
        if (message.message == 'file-upload-request') {
          _openFilePicker();
        }
      },
    );
  }

  void _openFilePicker() async {
    // 파일 선택 대화상자를 트리거하고 선택된 파일 경로를 WebView로 전달합니다.
    // 플랫폼별로 파일 선택 대화상자를 호출하는 방법은 차이가 있을 수 있습니다.
    // 이 예시에서는 `file_picker` 패키지를 사용하였습니다.
    // File file = await FilePicker.getFile();
    // String filePath = file.path;
    // _controller.future.then((controller) {
    //   controller.evaluateJavascript('handleFileUpload("$filePath");');
    // });
  }
  void _handleFileUpload(String url) {
    // 파일 업로드 요청에 대한 추가적인 처리를 수행합니다.
    print('File upload requested: $url');
    // 파일 업로드 로직을 구현하세요.
  }
  */

  JavascriptChannel _fromAppJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'webToApp',
        onMessageReceived: (JavascriptMessage message) {
          print("webToApp(): message = ${message.message}");
          dynamic param = jsonDecode(message.message);
          print("webToApp() data=$param");
          var cmd = param['command'];
          switch(cmd) {
            case "OK":
              _doClose(true);
              break;
            case "Close":
              _doClose(false);
              break;
            default:
              break;
          }
        }
    );
  }

  Widget _errorPage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        height: MediaQuery.of(context).size.width*0.6,
        child: Image.asset("assets/error/error_req01.png", fit: BoxFit.fitHeight,),
      ),
    );
  }

  Future<void> downloadFileWithHttp(String url) async {
    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var response = await httpClient.send(request);

    Directory? tempDir = await getTemporaryDirectory();
    String? tempPath = tempDir.path;

    // 파일 이름 추출
    String fileName = url.split('/').last;
    print(fileName);
    if(fileName.contains("?") || fileName.contains("=")|| fileName.contains("&")) {
      fileName = extractFileNameFromHeaders(response.headers);
    }
    if(fileName.isEmpty) {
      fileName = "known.dat";
    }

    print('File downloaded start: $fileName');

    // 파일 생성 및 저장
    File file = File('$tempPath/$fileName');
    var fileStream = file.openWrite();
    await response.stream.pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();

    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final saved = await FlutterFileDialog.saveFile(params: params);
    if(saved != null) {
      showToastMessage("$fileName 저장되었습니다.");
      print('File downloaded end: ${file.path}');
    }
  }

  String extractFileNameFromHeaders(Map headers) {
    //headers['filename'];
    // Content-Disposition 헤더에서 파일 이름 추출
    String contentDispositionHeader = headers['content-disposition']!;

    // 파일 이름 추출
    // 예시: 파일 이름이 filename= 로 시작하는 경우
    String fileName = '';
    if (contentDispositionHeader.isNotEmpty) {
      RegExp regex = RegExp(r'filename=(?:"([^"]*)"|([^;\n\r]*))');
      RegExpMatch? match = regex.firstMatch(contentDispositionHeader);
      String tempName = (match!.group(1) ?? match.group(2))!;
      fileName = utf8.decode(tempName.runes.toList());
      //fileName = String.fromCharCodes(utf8.encode(tempName));
    }
    return fileName;
  }


  void _doClose(bool result) {
    Navigator.pop(context, result);
  }

  /*
  Future<bool> _canGoBack() async {
    return await _webViewController.canGoBack();
  }

  Future<void> _goBack() async {
    var flag = await _webViewController.canGoBack();
    if (flag) {
      await _webViewController.goBack();
    }
  }
  */
}
