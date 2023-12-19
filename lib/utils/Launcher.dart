// ignore_for_file: file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

Future <void> callPhone(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri callUrl = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(callUrl);
}

Future <void> callSms(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri launchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future <void> showUrl(String url) async {
  await launchUrl(Uri.parse(url), webViewConfiguration:WebViewConfiguration(
      //headers: {'User-Agent': ""}
    )
  );
}

Future <void> showUrlWithAgent(String url) async {
  await launchUrl(Uri.parse(url), webViewConfiguration:WebViewConfiguration(
      headers: {'User-Agent': USER_AGENT}
  ));
}

Future <void> callNavi(String destName, String lat, String lon) async {
  String url = "https://map.kakao.com/link/to/$destName,$lat,$lon";
  await launchUrl(Uri.parse(url));
}

Future <void> shareInfo({required String subject, required String text, required List<String> imagePaths}) async {
  if (imagePaths.isNotEmpty) {
    await Share.shareFiles(imagePaths, text: text, subject: subject);
  }
  else {
    await Share.share(text, subject: subject,);
  }
}

Future <String> downloadFile(String srcUrl, String fileName) async {
  if (kDebugMode) {
    print("downloadFile::$srcUrl");
  }
  String savePath = "";
  try {
    Dio dio = Dio();
    savePath = await getFilePath(fileName);
    //print("downloadFile():savePath=$savePath");
    await dio.download(srcUrl, savePath);
    return savePath;
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return savePath;
}