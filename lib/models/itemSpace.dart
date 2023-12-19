// ignore_for_file: non_constant_identifier_names, file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemSpace {
  String spceSn;           // id
  String spceFile;         // 사진
  String spceNm;           // 타이틀
  String spceTelno;        // 내용
  String spceDc;           // 내용
  String spceEtc;          // 기타내용
  String bgngDt;           // 예약일자-시작
  String endDt;            // 예약일자-종료

  String spceTm;            // 가능시간
  String spceAr;            // 면적
  String spcePerson;        // 수용인원

  ItemSpace({
    this.spceSn = "",
    this.spceTelno = "",
    this.spceDc = "",
    this.spceFile = "",
    this.bgngDt = "",
    this.spceNm = "",
    this.endDt="",
    this.spceEtc="",

    this.spceTm="",
    this.spceAr="",
    this.spcePerson="",
  });

  bool isAvailable() {
    return false;
  }

  String getCategory() {
    switch(spceEtc) {
      case "PROGRM001": return "프로그램";
      case "PROGRM003": return "양성과정";
      case "PROGRM004": return "손오공 돌봄체";
      case "PROGRM005": return "부모상담";
      case "PROGRM006": return "공동육아나눔터";
      case "PROGRM007": return "돌봄봉사단";
      case "PROGRM008": return "설문조사";
      default: return "알수없음";
    }
  }

  static List<ItemSpace> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemSpace.fromJson(data);
    }).toList();
  }

  factory ItemSpace.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemSpace item =  ItemSpace(
      spceSn: (jdata['spceSn'] != null) ? jdata['spceSn'].toString().trim() : "",
      spceTelno: (jdata['spceTelno'] != null) ? jdata['spceTelno'].toString().trim() : "",
      spceDc: (jdata['spceDc'] != null) ? jdata['spceDc'].toString().trim() : "",
      spceFile: (jdata['spceFile'] != null) ? jdata['spceFile'].toString().trim() : "",
      spceNm: (jdata['spceNm'] != null) ? jdata['spceNm'].toString().trim() : "",
      bgngDt: (jdata['bgngDt'] != null) ? jdata['bgngDt'].toString().trim() : "",
      endDt: (jdata['endDt'] != null) ? jdata['endDt'].toString().trim() : "",
      spceEtc: (jdata['spceEtc'] != null) ? jdata['spceEtc'].toString().trim() : "",

      spceTm:(jdata['spceTm'] != null) ? jdata['spceTm'].toString().trim() : "",
      spceAr:(jdata['spceAr'] != null) ? jdata['spceAr'].toString().trim() : "",
      spcePerson:(jdata['spcePerson'] != null) ? jdata['spcePerson'].toString().trim() : "",
    );

    if(item.spceFile.isNotEmpty && !item.spceFile.startsWith("http")) {
       item.spceFile = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.spceFile}&fileSn=1";
    }

    if(item.bgngDt.length>15) {
      item.bgngDt = item.bgngDt.substring(0,16);
    }
    if(item.endDt.length>15) {
      item.endDt = item.endDt.substring(0,16);
    }

    return item;
  }
}