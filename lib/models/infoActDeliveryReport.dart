// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/common/dateForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemAttach.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class InfoActDeliveryReport {
  String actvstHistSn;
  String operPlace;
  String actTrgt;
  String partcptnNmpr;
  String actThema;
  String actGoal;
  String mainActCn;
  String actThts;
  String mberNm;    // 돌봄활동가명
  String instNm;
  String workBgngDt;
  String workEndDt;

  String atchFileId;
  List<ItemAttach> imageList;

  bool bSelect;

  InfoActDeliveryReport({
    this.operPlace="",
    this.actvstHistSn="",
    this.partcptnNmpr="",
    this.actTrgt ="",
    this.actThema="",
    this.actGoal ="",
    this.mainActCn ="",
    this.actThts="",

    this.mberNm="",
    this.instNm="",
    this.workBgngDt="",
    this.workEndDt="",
    this.atchFileId="",
    this.imageList = const [],
    this.bSelect = false,
  });

  String target() {
    switch(actTrgt) {
      case "1": return "영・유아";
      case "2": return "초등";
      case "3": return "공동체";
      default: return "미지정";
    }
  }
  String date() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(workBgngDt);
    DateTime start = DateFormat('yyyy-MM-dd HH:mm').parse(workBgngDt);
    DateTime end   = DateFormat('yyyy-MM-dd HH:mm').parse(workEndDt);
    String text  = //""
        "${DateFormat('yyyy.MM.dd').format(date)} "
        "(${DateForm.getKorWeek(DateFormat('EE').format(date))})  ("
        "${DateFormat('HH:mm').format(start)} ~ "
        "${DateFormat('HH:mm').format(end)})";
    return text;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "actvstHistSn":actvstHistSn,
      "operPlace":operPlace,
      "actTrgt":actTrgt,
      "mainActCn":mainActCn,
      "partcptnNmpr":partcptnNmpr,
      "actThema":actThema,
      "actThts":actThts,
      "actGoal":actGoal,
    };
    return map;
  }

  static String makeUrl(String atchFileId) {
    return "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${atchFileId}&fileSn=0";
  }

  static List<InfoActDeliveryReport> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoActDeliveryReport.fromJson(data);
    }).toList();
  }

  factory InfoActDeliveryReport.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    InfoActDeliveryReport info = InfoActDeliveryReport(
      actvstHistSn: (jdata['actvstHistSn'] != null)
          ? jdata['actvstHistSn'].toString().trim() : "",

      operPlace: (jdata['operPlace'] != null)
          ? jdata['operPlace'].toString().trim() : "",

      actTrgt: (jdata['actTrgt'] != null)
          ? jdata['actTrgt'].toString().trim() : "",

      partcptnNmpr: (jdata['partcptnNmpr'] != null)
          ? jdata['partcptnNmpr'].toString().trim() : "",

      actThema: (jdata['actThema'] != null)
          ? jdata['actThema'].toString().trim() : "",

      actGoal: (jdata['actGoal'] != null)
          ? jdata['actGoal'].toString().trim() : "",

      mainActCn: (jdata['mainActCn'] != null)
          ? jdata['mainActCn'].toString().trim() : "",

      actThts: (jdata['actThts'] != null)
          ? jdata['actThts'].toString().trim() : "",

      mberNm: (jdata['mberNm'] != null)
          ? jdata['mberNm'].toString().trim() : "",
      instNm: (jdata['instNm'] != null)
          ? jdata['instNm'].toString().trim() : "",
      workBgngDt: (jdata['workBgngDt'] != null)
          ? jdata['workBgngDt'].toString().trim() : "",
      workEndDt: (jdata['workEndDt'] != null)
          ? jdata['workEndDt'].toString().trim() : "",

      atchFileId: (jdata['atchFileId'] != null)
          ? jdata['atchFileId'].toString().trim() : "",
    );

    if(info.atchFileId.isNotEmpty) {
      info.imageList = [ItemAttach(tag: "p", url:InfoActDeliveryReport.makeUrl(info.atchFileId))];
      //print(info.imageList.toString());
    } else {
      info.imageList = [ItemAttach(tag: "p", url:"")]; // URL_IMG_EMPTY
    }

    return info;
  }

}
