// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ItemInstSurvey {
  String qustnrSn;      // id
  String scrtyKey;      // 보안키
  String qustnrSj;      // 타이틀
  String qustnrDc;      // 내용
  String bgngDt;        // 시작일자
  String endDt;         // 종료일자
  String mssmYn;        // 비회원 설문가능 여부 ?
  String qustnrRespondCnt;        // 참여 카운트
  String qustnrMineRespondCnt;    // 설문 응답 여부
  bool   showMore;

  ItemInstSurvey({
    this.scrtyKey = "",
    this.mssmYn = "",
    this.qustnrSj = "",
    this.qustnrDc = "",
    this.bgngDt="",
    this.qustnrSn="",
    this.endDt="",
    this.qustnrRespondCnt="",
    this.showMore = false,
    this.qustnrMineRespondCnt="",
  });

  bool isDateInRange() {
    DateTime startDate = DateTime.parse(bgngDt);
    DateTime endDate   = DateTime.parse(endDt);
    DateTime targetDate = DateTime.now();
    return targetDate.isAfter(startDate) && targetDate.isBefore(endDate);
  }


  String getKorWeek(String value) {
    switch(value) {
      case 'Mon': return "월";
      case 'Tue': return "화";
      case 'Wed': return "수";
      case 'Thu': return "목";
      case 'Fri': return "금";
      case 'Sat': return "토";
      case 'Sun': return "일";
    }
    return "?";
  }

  String getYDayStamp(String dateString) {
    if(dateString.length<10) {
      return "";
    }
    DateTime dateStamp = DateFormat('yyyy-MM-dd').parse(dateString);
    return "${DateFormat('yyyy-MM-dd').format(dateStamp)}(${getKorWeek(DateFormat('EE').format(dateStamp))}) ${DateFormat('hh:mm').format(dateStamp)}";
  }

  static List<ItemInstSurvey> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemInstSurvey.fromJson(data);
    }).toList();
  }

  factory ItemInstSurvey.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemInstSurvey item = ItemInstSurvey(
      scrtyKey: (jdata['scrtyKey'] != null) ? jdata['scrtyKey'].toString().trim() : "",
      qustnrSj: (jdata['qustnrSj'] != null) ? jdata['qustnrSj'].toString().trim() : "",
      qustnrDc: (jdata['qustnrDc'] != null) ? jdata['qustnrDc'].toString().trim() : "",
      bgngDt:(jdata['bgngDt'] != null) ? jdata['bgngDt'].toString().trim() : "",
      mssmYn: (jdata['mssmYn'] != null) ? jdata['mssmYn'].toString().trim() : "",
      endDt: (jdata['endDt'] != null) ? jdata['endDt'].toString().trim() : "",
      qustnrSn: (jdata['qustnrSn'] != null) ? jdata['qustnrSn'].toString().trim() : "",
      qustnrRespondCnt: (jdata['qustnrRespondCnt'] != null) ? jdata['qustnrRespondCnt'].toString().trim() : "",
      qustnrMineRespondCnt: (jdata['qustnrMineRespondCnt'] != null) ? jdata['qustnrMineRespondCnt'].toString().trim() : "",
    );
    return item;
  }
}