// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemMemberCrqfc.dart';
import 'package:daejeoni/models/ItemMemberHist.dart';
import 'package:daejeoni/models/itemAttach.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoActCourse {
  String actvstSn;
  String partcptnCoursCd;     // 참여경로
  String partcptnCoursEtc;    // 참여경로-기타
  String acdmcrCd;            // 최종학력


  String actvstSpcabl;        // 특기사항
  String actvstIntrcn;        // 자기소개
  String actvstActMatter;     // 활동사항
  String actvstSync;          // 지원동기
  String actvstDream;         // 돌봄활동가로서의 포부

  // String mberHistNm;          // 학교명
  // String mberHistBgngYm;      // 재학기간-시작
  // String mberHistEndYm;       // 재학기간-종료

  String atchFileId;
  List<ItemMemberHist> histList;
  List<ItemMemberCrqfc> crqfcList;
  List<ItemAttach>      imageList;
  bool bSelect;

  InfoActCourse({
    this.partcptnCoursCd="",
    this.actvstSn="",
    this.acdmcrCd="",
    this.partcptnCoursEtc ="",
    this.actvstDream ="",
    this.actvstSpcabl ="",
    this.actvstActMatter="",
    this.actvstIntrcn="",
    this.actvstSync="",
    // this.mberHistNm="",
    // this.mberHistBgngYm="",
    // this.mberHistEndYm="",
    this.atchFileId="",
    this.histList = const [],
    this.crqfcList = const [],
    this.imageList = const [],
    this.bSelect = false,
  });

  String getSchoolGrade() {
    switch(acdmcrCd) {
      case "ACDMCR0001" :  return "초등학교";
      case "ACDMCR0002" :  return "중학교";
      case "ACDMCR0003" :  return "고등학교";
      case "ACDMCR0004" :  return "대학교・대학원";
      default: return "알수없음";
    }
  }

  int getSchoolInfoCount() {
    switch(acdmcrCd) {
      case "ACDMCR0001" :  return 1;
      case "ACDMCR0002" :  return 1;
      case "ACDMCR0003" :  return 1;
      case "ACDMCR0004" :  return 2;
      default: return 1;
    }
  }

  String getSchoolInfoName(int index) {
    switch(acdmcrCd) {
      case "ACDMCR0001" :  return "초등학교";
      case "ACDMCR0002" :  return "중학교";
      case "ACDMCR0003" :  return "고등학교";
      case "ACDMCR0004" :  return (index==0) ? "고등학교" : "대학교・대학원";
      default: return "알수없음";
    }
  }

  bool isMajor() {
    switch(acdmcrCd) {
      case "ACDMCR0001": return false;
      case "ACDMCR0002": return false;
      case "ACDMCR0003": return true;
      case "ACDMCR0004": return true;
      default: return false;
    }
  }

  /*
  {
  "actvstSn" : "153",
  "param_atchFileId": "파일" ,
  "jsonData" : {
    "acdmcr":[
      {
        "mberHistSn":"361",
        "mberHistNm":"고등학교명",
        "mberHistMajor":"고등학교전공",
        "mberHistBgngYm":"2023-08",
        "mberHistEndYm":"2023-12"
        },
        {
          "mberHistSn":"362",
          "mberHistNm":"대학교명",
          "mberHistMajor":"대학교전공",
          "mberHistBgngYm":"2023-03",
          "mberHistEndYm":"2023-12"
          }
      ],
      "crqfc":[
        {
          "mberHistSn":"363",
          "mberHistNm":"자격명",
          "mberHistMajor":"발행처",
          "mberHistBgngYm":"2023-05"
         },
         {
            "mberHistSn":"364",
            "mberHistNm":"자격증2",
            "mberHistMajor":"발행처2",
            "mberHistBgngYm":"2023-03"
          },
          {
            "mberHistSn":"365",
            "mberHistNm":"자격3",
            "mberHistMajor":"발행3",
            "mberHistBgngYm":"2023-11"
          }
        ]
      }
    }
   */

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "actvstSn":actvstSn,
      "partcptnCoursCd":partcptnCoursCd,
      "partcptnCoursEtc":partcptnCoursEtc,
      "acdmcrCd":acdmcrCd,
      "actvstSpcabl":actvstSpcabl,
      "actvstIntrcn":actvstIntrcn,
      "actvstActMatter":actvstActMatter,
      "actvstSync":actvstSync,
      "actvstDream":actvstDream,
      "jsonData": {
        "acdmcr":histList.map((object) => object.toMap()).toList(),
        "crqfc":crqfcList.map((object) => object.toMap()).toList(),
      },
    };
    return map;
  }

  static List<InfoActCourse> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoActCourse.fromJson(data);
    }).toList();
  }

  factory InfoActCourse.fromJson(Map<String, dynamic> data){
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(data);
    // }
    var jdata = data['info'];
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    InfoActCourse info = InfoActCourse(
      actvstSn: (jdata['actvstSn'] != null)
          ? jdata['actvstSn'].toString().trim() : "",

      partcptnCoursCd: (jdata['partcptnCoursCd'] != null)
          ? jdata['partcptnCoursCd'].toString().trim() : "",

      partcptnCoursEtc: (jdata['partcptnCoursEtc'] != null)
          ? jdata['partcptnCoursEtc'].toString().trim() : "",

      acdmcrCd: (jdata['acdmcrCd'] != null)
          ? jdata['acdmcrCd'].toString().trim() : "",

      // mberHistNm: (jdata['mberHistNm'] != null)
      //     ? jdata['mberHistNm'].toString().trim() : "",
      // mberHistBgngYm: (jdata['mberHistBgngYm'] != null)
      //     ? jdata['mberHistBgngYm'].toString().trim() : "",
      // mberHistEndYm: (jdata['mberHistEndYm'] != null)
      //     ? jdata['mberHistEndYm'].toString().trim() : "",
      actvstDream: (jdata['actvstDream'] != null)
          ? jdata['actvstDream'].toString().trim() : "",

      actvstSpcabl: (jdata['actvstSpcabl'] != null)
          ? jdata['actvstSpcabl'].toString().trim() : "",

      actvstIntrcn: (jdata['actvstIntrcn'] != null)
          ? jdata['actvstIntrcn'].toString().trim() : "",

      actvstActMatter: (jdata['actvstActMatter'] != null)
          ? jdata['actvstActMatter'].toString().trim() : "",

      actvstSync: (jdata['actvstSync'] != null)
          ? jdata['actvstSync'].toString().trim() : "",

      atchFileId: (jdata['atchFileId'] != null)
            ? jdata['atchFileId'].toString().trim() : "",
    );

    if(info.atchFileId.isNotEmpty) {
      info.imageList = [ItemAttach(tag: "p", url:InfoActCourse.makeUrl(info.atchFileId))];
    }

    var mberHistList = data['mberHistList'];
    if(mberHistList != null) {
      info.histList  = ItemMemberHist.fromSnapshot(mberHistList);
    }

    var crqfcList = data['crqfcList'];
    if(mberHistList != null) {
      info.crqfcList = ItemMemberCrqfc.fromSnapshot(crqfcList);
    }
    return info;
  }

  static String makeUrl(String atchFileId) {
    return "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${atchFileId}&fileSn=1";
  }
}
