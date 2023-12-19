// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, use_build_context_synchronously
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:daejeoni/remote/showRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:transition/transition.dart';
import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';

import '../constant/constant.dart';

class Remote{
  static Future <void> fileUpLoad({
    required BuildContext context,
    required SessionData  session,
    required String method,
    required Map<String,String> params,
    required String filePath,
    required Function(dynamic data) onResult,
    required Function(String error) onError
  }) async {

    Uri uri = Uri.parse("$URL_API/$method");
    print("uri:${uri.toString()}");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer ${session.AccessToken}"
    });
    request.fields.addAll(params);

    // 파일 업로드
    if (filePath.isNotEmpty) {
      if (await io.File(filePath).exists()) {
        request.files.add(await http.MultipartFile.fromPath('param_atchFileId', filePath));
      }
    }

    if (kDebugMode) {
      debugPrint(">>> fileUpLoad: $uri params=${params.toString()}");
    }

    try {
      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 120));
      if (response.statusCode == 200) {
        String data = await response.stream.bytesToString();
        dynamic jdata = jsonDecode(data);
        if (kDebugMode) {
          var logger = Logger();
          logger.d(jdata);
        }
        return onResult(jdata);
      } else {
        if (kDebugMode) {
          print("response.statusCode=${response.statusCode}");
          print("response.statusCode=${response.stream.toString()}");
        }
        return onError("업로드에 실패하였습니다.\n최대 99MB까지 업로드 가능합니다.");
      }
    } catch (e) {
      return onError("Network Error:");
    }
  }

  static Future <void> getAddress({
    required String longitude,
    required String latitude,
    required Function(dynamic data) onResult,
    required Function(String error) onError
  }) async {

    final String apiUrl = 'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude&input_coord=WGS84';

    // if(kDebugMode) {
    //   print(apiUrl);
    // }

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          // 'Content-type': 'application/json',
          // 'Accept': 'application/json',
          'Authorization': 'KakaoAK $kakao_RestAppKey',
        },
      ).timeout(Duration(seconds: 3),
          onTimeout: () {
            showToastMessage("서버에서 응답이 없습니다.");
            return http.Response(
                'Error', 408); // Request Timeout response status code
          });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var content = data['documents'][0];
        if(content != null) {
          // if(kDebugMode) {
          //     String address = content['road_address']['address_name'];
          //     String region = content['road_address']['region_2depth_name'];
          //     String building_name = content['road_address']['building_name'];
          //     print(address);
          //     print(region);
          //     print(building_name);
          // }
          return onResult(content);
        }
      } else {
        debugPrint("<<< HTTP Error CODE:${response.statusCode}");
      }
      onError("Error !!");
    } catch(e) {
      //print(e.toString());
      return onError("Network Error.");
    }
  }

  static Future <void> showTrace(BuildContext ctx, String request, String response) async {
    await Navigator.push(ctx,
        Transition(child: ShowRequest(message: "POST", request: request, response: response,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
  }

  static Future <void> apiPost({
    required BuildContext context,
    required SessionData  session,
    required String method, //"auth/login"
    required Map<String,dynamic>? params,
    int? timeOut = 10,
    bool? bTrace = false,
    required Function(dynamic data) onResult,
    required Function(String error) onError
  }) async {

    String debug_req = "";
    String debug_rep = "";

    Uri uri = Uri.parse("$URL_API/$method");
    if(kDebugMode) {
      debug_req = ">>> apiPost: $uri params=${params.toString()}";
      print(debug_req);
    }
    try {
      final response = await http.post(
          uri,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer ${session.AccessToken}"},
          body: (params != null) ? json.encode(params) : ""
      ).timeout(Duration(seconds: timeOut!),
          onTimeout: () {
            debug_rep = "[timeout:$timeOut] 서버에서 응답이 없습니다.";
            showToastMessage("서버에서 응답이 없습니다.");
            return http.Response('Error', 408); // Request Timeout response status code
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        String data = response.body;
        int start = data.indexOf('{', 0);
        if (start > 0) {
          data = data.substring(start);
        }

        var json = jsonDecode(data);
        String debug_rep = json.toString();
        if(json['session'] != null && json['session']=="false") {
          session.setLogout(false);
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }

        // if(bTrace!) {
        //   showTrace(context, debug_req, debug_rep);
        // }
        return onResult(json);
      }
      else {
        if (kDebugMode) {
          debug_rep = "<<< HTTP Error CODE:${response.statusCode}";
          print(debug_rep);
        }
        // if(bTrace!) {
        //   showTrace(context, debug_req, debug_rep);
        // }
        showToastMessage("서버 접속 오류입니다.");
        return onError(debug_rep);
      }

    } catch (e) {
      if(kDebugMode) {
        debug_rep = "Network Error.";
        print(debug_rep);
      }
      if(bTrace!) {
        showTrace(context, debug_req, debug_rep);
      }
      showToastMessage("네트워크 오류입니다.");
      return onError(debug_rep);
    }
  }

  static Future <void> apiGet({
    required String token,
    required String method, //"auth/info"
    required Map<String,dynamic> params,
    required Function(dynamic data) onResult,
    required Function(String error) onError
  }) async {

    Uri uri = Uri.parse("$URL_API/$method");
    if(kDebugMode) {
      debugPrint(">>> apiGet: $uri params=${params.toString()}");
    }

    try {
        final response = await http.get(uri,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer$token"},
      );

      if (response.statusCode == 200) {
        String data = response.body;
        if(kDebugMode) {
          debugPrint(data);
        }

        int start = data.indexOf('{', 0);
        if (start > 0) {
          data = data.substring(start);
        }
        if(kDebugMode) {
          debugPrint("<<< Rep: $data");
        }
        return onResult(jsonDecode(data));
      }

      debugPrint("<<< HTTP Error CODE:${response.statusCode}");
      return onError("HTTP Error CODE:${response.statusCode}");
    } catch (e) {
      debugPrint("<<< Network Error:$e");
      return onError("Network Error:$e");
    }
  }
}