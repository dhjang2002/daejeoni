// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemActCourse {
  String actvstSn;
  String instNm;            // 기관명
  String partcptnCoursEtc;  // 참여경로-기타
  String partcptnCoursCd;   // 참여경로
  String acdmcrCd;          // 학력사항
  String aprvYn;            // 승인여부
  String regDt;             // 신청일자

  bool bSelect;

  ItemActCourse({
    this.actvstSn="",
    this.instNm="",
    this.partcptnCoursEtc ="",
    this.partcptnCoursCd ="",
    this.aprvYn="",
    this.acdmcrCd="",
    this.regDt="",
    this.bSelect = false,
  });

  /*
    final List<GRadioItem> enterTypeList = [
    GRadioItem(label: "보도자료(뉴스,기사,홍보자료 등)", tag: "COURS0004"),
    GRadioItem(label: "SNS(블로그,페이스북,인스타 등)", tag: "COURS0001"),
    GRadioItem(label: "지인소개", tag: "COURS0002"),
    GRadioItem(label: "기타", tag: "COURS0003"),
  ];

  final List<GRadioItem> schoolTypeList = [
    GRadioItem(label: "초등학교 졸업", tag: "ACDMCR0001"),
    GRadioItem(label: "중학교 졸업", tag: "ACDMCR0002"),
    GRadioItem(label: "고등학교 졸업", tag: "ACDMCR0003"),
    GRadioItem(label: "대학교.대학원 졸업", tag: "ACDMCR0004"),
  ];
   */
  String getCycle() {
    switch(partcptnCoursCd) {
      case "COURS0001" : return "SNS";
      case "COURS0002" : return "지인소개";
      case "COURS0003" : return "기타 - ${partcptnCoursEtc}";
      case "COURS0004" : return "보도자료";
      default: return "알수없음";
    }
  }

  String getHist() {
    switch(acdmcrCd) {
      case "ACDMCR0001" : return "초등학교";
      case "ACDMCR0002" : return "중학교";
      case "ACDMCR0003" : return "고등학교";
      case "ACDMCR0004" : return "대학교・대학원";
      default: return "알수없음";
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
    };

    if(actvstSn.isNotEmpty) {
      map.addAll({"actvstSn":actvstSn});
    }
    return map;
  }

  static List<ItemActCourse> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemActCourse.fromJson(data);
    }).toList();
  }

  factory ItemActCourse.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemActCourse item = ItemActCourse(
      actvstSn: (jdata['actvstSn'] != null)
          ? jdata['actvstSn'].toString().trim() : "",

      instNm: (jdata['parntsTroblType'] != null)
          ? jdata['parntsTroblType'].toString().trim() : "",

      partcptnCoursEtc: (jdata['partcptnCoursEtc'] != null)
          ? jdata['partcptnCoursEtc'].toString().trim() : "",

      partcptnCoursCd: (jdata['partcptnCoursCd'] != null)
          ? jdata['partcptnCoursCd'].toString().trim() : "",

      acdmcrCd: (jdata['acdmcrCd'] != null)
          ? jdata['acdmcrCd'].toString().trim() : "",

      aprvYn: (jdata['aprvYn'] != null)
          ? jdata['aprvYn'].toString().trim() : "",

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }

    return item;
  }

}
