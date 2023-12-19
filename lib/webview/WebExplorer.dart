// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, must_be_immutable, file_names, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class WebExplorer extends StatefulWidget {
  final String url;
  String? title;
  bool? supportZoom;

  WebExplorer({Key? key,
    required this.url,
    this.title="",
    this.supportZoom = true,
  }) : super(key: key);

  @override
  _WebExplorerState createState() => _WebExplorerState();
}

class _WebExplorerState extends State<WebExplorer> {
  _WebExplorerState();

  bool _isError = false;
  bool _bReady = false;
  late WebViewController _webViewController;

  @override
  void initState() {
    if(Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

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
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(widget.title!),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: WillPopScope(
            onWillPop: () => _onBackPressed(context),
            child: _buildWebview()
      ),
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
          zoomEnabled:widget.supportZoom!,
          initialUrl: widget.url,
          gestureNavigationEnabled: true,
          allowsInlineMediaPlayback:true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            //_controller.complete(webViewController);
          },

          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },

          javascriptChannels: <JavascriptChannel> {
            fromApp(context),
          },

          onWebResourceError: (WebResourceError error) {
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

        )
    );
  }

  JavascriptChannel fromApp(BuildContext context) {
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

  Future<bool> _canGoBack() async {
    return await _webViewController.canGoBack();
  }

  Future<void> _goBack() async {
    var flag = await _webViewController.canGoBack();
    if (flag) {
      await _webViewController.goBack();
    }
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    var flag = await _canGoBack();
    if (flag) {
      _goBack();
    }
    else {
      _doClose(false);
    }
    return Future(() => false);
  }
}
