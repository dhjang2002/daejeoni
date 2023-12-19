// ignore_for_file: non_constant_identifier_names, file_names

import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemPhoto.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoSpace {
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
  String spceEqpmn;         // 부대시설

  List<CardPhotoItem> photo_items;
  
  InfoSpace({
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
    this.spceEqpmn="",
    this.photo_items = const[],
  });

  bool isAvailable() {
    return true;
  }

  // String getCategory() {
  //   switch(spceEtc) {
  //     case "PROGRM001": return "프로그램";
  //     case "PROGRM003": return "양성과정";
  //     case "PROGRM004": return "손오공 돌봄체";
  //     case "PROGRM005": return "부모상담";
  //     case "PROGRM006": return "공동육아나눔터";
  //     case "PROGRM007": return "돌봄봉사단";
  //     case "PROGRM008": return "설문조사";
  //     default: return "알수없음";
  //   }
  // }

  void setPhotoList(List<ItemPhoto> list) {
    photo_items = [];
    for (var element in list) {
      String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${element.atchFileId}&fileSn=${element.fileSn}";
      photo_items.add(CardPhotoItem(url: url, type: "p"));
    }
  }

  static List<InfoSpace> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoSpace.fromJson(data);
    }).toList();
  }

  factory InfoSpace.fromJson(Map<String, dynamic> content)
  {
    var info = content['info'];
    if (kDebugMode) {
      var logger = Logger();
      logger.d(info);
    }

    InfoSpace item =  InfoSpace(
      spceSn: (info['spceSn'] != null) ? info['spceSn'].toString().trim() : "",
      spceTelno: (info['spceTelno'] != null) ? info['spceTelno'].toString().trim() : "",
      spceDc: (info['spceDc'] != null) ? info['spceDc'].toString().trim() : "",
      spceFile: (info['spceFile'] != null) ? info['spceFile'].toString().trim() : "",
      spceNm: (info['spceNm'] != null) ? info['spceNm'].toString().trim() : "",
      bgngDt: (info['bgngDt'] != null) ? info['bgngDt'].toString().trim() : "",
      endDt: (info['endDt'] != null) ? info['endDt'].toString().trim() : "",
      spceEtc: (info['spceEtc'] != null) ? info['spceEtc'].toString().trim() : "",
      spceTm:(info['spceTm'] != null) ? info['spceTm'].toString().trim() : "",
      spceAr:(info['spceAr'] != null) ? info['spceAr'].toString().trim() : "",
      spcePerson:(info['spcePerson'] != null) ? info['spcePerson'].toString().trim() : "",
      spceEqpmn:(info['spceEqpmn'] != null) ? info['spceEqpmn'].toString().trim() : "",
    );

    var files = content['files'];
    if(files != null) {
      item.setPhotoList(ItemPhoto.fromSnapshot(files));
    }

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