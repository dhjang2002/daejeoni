// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/common/dateForm.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ItemActDeliveryReport {
  String actvstHistSn;
  String workBgngDt;      // 근무시간
  String workEndDt;       // 근무시간
  String workDay;         // 근무일자
  String diaryWrtYn;      // 일지 작성 유무
  String insttNm;         // 기관명
  String actInsttNm;      // 기관명
  String actTrgt;
  String dlvrSn;
  bool bSelect;

  ItemActDeliveryReport({
    this.insttNm="손오공돌봄센터",
    this.workBgngDt="",
    this.actvstHistSn="",
    this.workDay="",
    this.workEndDt ="",

    this.diaryWrtYn ="",
    this.actInsttNm ="",
    this.actTrgt="",
    this.dlvrSn="",
    this.bSelect = false,
  });

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


  String target() {
    switch(actTrgt) {
      case "1": return "영・유아";
      case "2": return "초등";
      case "3": return "공동체";
      default: return "미지정";
    }
  }

  String day() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(workBgngDt);
    String text  = //""
        "${DateFormat('yyyy.MM.dd').format(date)} "
        "(${DateForm.getKorWeek(DateFormat('EE').format(date))})";
    return text;
  }

  String startTime() {
    DateTime start = DateFormat('yyyy-MM-dd HH:mm').parse(workBgngDt);
    String text  = //""
        "${DateFormat('HH:mm').format(start)}";
    return text;
  }

  String endTime() {
    DateTime end   = DateFormat('yyyy-MM-dd HH:mm').parse(workEndDt);
    String text  = //""
        "${DateFormat('HH:mm').format(end)}";
    return text;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
    };
    return map;
  }

  static List<ItemActDeliveryReport> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemActDeliveryReport.fromJson(data);
    }).toList();
  }

  factory ItemActDeliveryReport.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemActDeliveryReport(
      actvstHistSn: (jdata['actvstHistSn'] != null)
          ? jdata['actvstHistSn'].toString().trim() : "",

      workBgngDt: (jdata['workBgngDt'] != null)
          ? jdata['workBgngDt'].toString().trim() : "",

      workEndDt: (jdata['workEndDt'] != null)
          ? jdata['workEndDt'].toString().trim() : "",

      workDay: (jdata['workBgngDt'] != null)
          ? jdata['workBgngDt'].toString().trim() : "",

      // insttNm: (jdata['insttNm'] != null)
      //     ? jdata['insttNm'].toString().trim() : "",

      diaryWrtYn: (jdata['diaryWrtYn'] != null)
          ? jdata['diaryWrtYn'].toString().trim() : "",

      actInsttNm: (jdata['actInsttNm'] != null)
          ? jdata['actInsttNm'].toString().trim() : "",
      actTrgt: (jdata['actTrgt'] != null)
          ? jdata['actTrgt'].toString().trim() : "",
      dlvrSn: (jdata['dlvrSn'] != null)
          ? jdata['dlvrSn'].toString().trim() : "",
    );
  }
}
