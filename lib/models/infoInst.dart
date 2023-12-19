// ignore_for_file: non_constant_identifier_names

import 'package:daejeoni/common/cardPhotoItem.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemPhoto.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoInst {
  int insttSn;              // 기관 일련번호
  String insttNm;           // 기관 명칭
  String upperInsttSn;      // 상위기관 일련번호 (3,5,6,8 홈페이지 연결형)
  String upperInsttNm;      // 상위기관 명칭
  String insttThumbFile;    // 기관 대표 이미지
  String insttFile;
  String insttBizCl;        // 기관 사업분류
  String insttSd;           // 기관 지역(시도)
  String insttSgg;          // 기관 지역(시,군,구)
  String insttYmd;          // 기관 지역(읍,면,동)

  double longitude;
  double latitude;
  //double distance;

  String insttAdres;        // 기관 주소
  String insttAdresDetail;  // 기관 상세주소
  String insttCoTelno;      // 기관 전화번호
  String insttEml;          // 기관 이메일
  String insttRprsntv;      // 기관 대표자
  String insttHomepage;     // 기관 홈페이지

  String insttTotalPsn;     // 기관 정원
  String insttNowPsn;       // 기관 현원
  String insttChrg;         // 기관 담당기관
  String insttInnb;         // 기관 고유번호

  String insttDc;
  String insttEtc;

  String insttSpce;
  String insttAge;      // 기관 연령
  String insttChrge;    // 기관 이용료
  String insttEmp;      // 기관 직원현황

  String insttTime;     // 기관 운영시간

  String insttRqisit;     // 지원자격 요건
  String insttHvof;       // 휴무일

  String insttAgeType;    // 기관 이용연령 (1:영,유아, 2:유치원생, 3:초등학생)

  String insttOperAll;    // 돌봄유형 상시 여부 ("Y"/"N")
  String insttOperDt;     // 돌봄유형 일시 여부 ("Y"/"N")
  String insttOperEmrg;   // 돌봄유형 긴급 여부 ("Y"/"N")
  String insttOperEtc;    // 기관 돌봄유형상세

  String insttMlsv;       // 기관 급식유무 ("Y"/"N")
  String insttMlsvEtc;    // 기관 급식형식

  String insttShuttle;    // 기관 셔틀유무
  String insttShuttleEtc; // 기관 셔틀형식

  String insttProgrm;     // 기관 운영 프로그램


  String insttType;       // 예약하기 버튼 활성/비활성

  String insttTempPsn;    // 기관 일시 가능 정원
  String ioaPsncpa;       // 기관 상시 가능 정원
  String insttSnsv;       // 간식 제공 유무
  String insttRgst;       // 기관 이용방법 (L유선전화, V방문, O대전아이예약)
  String insttTime1;      // 기관 이용시간: 학기중
  String insttTime2;      // 기관 이용시간: 방학중
  String insttTime3;      // 기관 이용시간: 휴무일

  String link;
  String extrlLinkScrtyKey;
  String extrlLinkDomn;

  String mberId;

  double grade;
  double myDstnc;
  List<CardPhotoItem> photo_sub_items;
  //List<CardPhotoItem> photo_items;

  InfoInst({
    this.insttSn = 0,
    this.insttNm="",
    this.upperInsttSn="",
    this.upperInsttNm="",
    this.insttThumbFile="",
    this.insttFile="",
    this.insttBizCl="",
    this.insttSd="",
    this.insttSgg="",
    this.insttYmd="",
    this.latitude=0.0,
    this.longitude=0.0,

    this.insttAdres ="",
    this.insttAdresDetail="",
    this.insttCoTelno = "",
    this.insttEml="",
    this.insttRprsntv="",
    this.insttHomepage="",

    this.insttTotalPsn = "",
    this.insttNowPsn="",
    this.insttChrg="",
    this.insttInnb="",
    this.insttDc = "",
    this.insttEtc="",
    this.insttSpce="",
    this.insttAge="",
    this.insttChrge="",
    this.insttEmp="",
    this.insttTime="",
    this.insttRqisit="",
    this.insttHvof="",
    this.insttAgeType="",
    this.insttOperAll="",
    this.insttOperDt="",
    this.insttOperEmrg="",
    this.insttOperEtc="",
    this.insttMlsv="",
    this.insttMlsvEtc="",
    this.insttShuttle="",
    this.insttShuttleEtc="",
    this.insttProgrm="",
    this.insttType="",

    this.insttTempPsn="",
    this.ioaPsncpa="",
    this.insttSnsv="",
    this.insttRgst="",
    this.insttTime1="",
    this.insttTime2="",
    this.insttTime3="",
    this.mberId="",

    this.link = "",
    this.extrlLinkScrtyKey="",
    this.extrlLinkDomn="",
    this.grade=0.0,
    this.myDstnc=0.0,
    //this.photo_items = const [],
    this.photo_sub_items = const[],
  });


  // 1. 유선전화, 2:방문상담, 3:대전아이 예약
  /*
    String target() {
    switch(insttRgst) {
      case "1": return "영・유아";
      case "2": return "초등";
      case "3": return "공동체";
      default: return "미지정";
    }
  }
   */
  // initType (1,2,3)
  /*
"insttOperAll": "Y",
"insttOperDt": "Y",
"insttOperEmrg": "N",
   */
  String careType() {
    String result = "";
    if(insttOperAll=="Y") {
      if(result.isNotEmpty) result += " , ";
      result += "상시";
    }
    if(insttOperDt=="Y") {
      if(result.isNotEmpty) result += " , ";
      result += "일시";
    }
    if(insttOperEmrg=="Y") {
      if(result.isNotEmpty) result += " , ";
      result += "긴급";
    }
    return result;
  }

  // insttRgst;       // 기관 이용방법 (L유선전화, V방문, O대전아이예약)
  // 이용방법 (1: 유선전화, 2:방문, 3:대전아이 예약)
  String useType() {
    String value = "";
    var items = insttAgeType.split(",");
    items.forEach((element) {
      if(element=="1") {
        if(value.isNotEmpty) value += "\n";
        value += "유선전화";
      }
      if(element=="2") {
        if(value.isNotEmpty) value += "\n";
        value += "방문";
      }
      if(element=="3") {
        if(value.isNotEmpty) value += "\n";
        value += "대전아이 예약";
      }
    });
    return value;
  }

  String getExtLink() {
    // <c:when test="${info.upperInsttSn eq '3'}">
    // <a href="${info.insttEml}" class="btns glanHome-btn" target="_blank" data-toggle="tooltip" data-original-title="홈페이지 바로가기" title="홈페이지 바로가기">홈페이지 바로가기</a>
    // </c:when>
    // <c:when test="${info.upperInsttSn eq '5'}">
    // <a href="${info.insttHomepage}" class="btns glanHome-btn" target="_blank" data-toggle="tooltip" data-original-title="홈페이지 바로가기" title="홈페이지 바로가기">홈페이지 바로가기</a>
    // </c:when>
    // <c:when test="${info.upperInsttSn eq '6'}">
    // <a href="${info.insttHomepage}" class="btns glanHome-btn" target="_blank" data-toggle="tooltip" data-original-title="홈페이지 바로가기" title="홈페이지 바로가기">홈페이지 바로가기</a>
    // </c:when>
    // <c:when test="${info.upperInsttSn eq '8'}">
    // <a href="${info.insttHomepage}" class="btns glanHome-btn" target="_blank" data-toggle="tooltip" data-original-title="홈페이지 바로가기" title="홈페이지 바로가기">홈페이지 바로가기</a>
    // </c:when>
    switch(upperInsttSn) {
      case "3":
        return insttEml;
      case "5":
        return insttHomepage;
      case "6":
        return insttHomepage;
      case "8":
        return insttHomepage;
    }
    return "";
  }

  bool isLinkOnly() {
    //return extrlLinkDomn.isNotEmpty;
    // || upperInsttSn=="11"
    if(upperInsttSn=="3" || upperInsttSn=="5" || upperInsttSn=="6" || upperInsttSn=="8" ) {
      return true;
    }
    return false;

  }

  /*
  <c:if test="${info.insttCoTelno} ne null">
            <p class="font15 demilight">
              ${info.insttCoTelno} <br>
            </p>
          </c:if>
          <c:if test="${info.insttOperEtc} ne null">
            <p class="font15 demilight">
              ${info.insttOperEtc} <br>
            </p>
          </c:if>
          <c:if test="${info.insttShuttleEtc} ne null">
            <p class="font15 demilight">
              ${info.insttShuttleEtc} <br>
            </p>
          </c:if>
          <c:if test="${info.insttMlsvEtc} ne null">
            <p class="font15 demilight">
            ${info.insttMlsvEtc} <br>
            </p>
          </c:if>
   */
  String infoEtc() {
    String info = "";
    if(insttCoTelno.isNotEmpty) {
      if(info.isNotEmpty) {
        info += "\r\n";
      }
      info += insttCoTelno;
    }

    if(insttOperEtc.isNotEmpty) {
      if(info.isNotEmpty) {
        info += "\r\n";
      }
      info += insttOperEtc;
    }

    if(insttShuttleEtc.isNotEmpty) {
      if(info.isNotEmpty) {
        info += "\r\n";
      }
      info += insttShuttleEtc;
    }

    if(insttMlsvEtc.isNotEmpty) {
      if(info.isNotEmpty) {
        info += "\r\n";
      }
      info += insttMlsvEtc;
    }
    return info;
  }

  String getHiName() {
    return upperInsttNm;
  }

  void setPhotoList(List<ItemPhoto> list) {
    photo_sub_items = [];
    for (var element in list) {
      String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${element.atchFileId}&fileSn=${element.fileSn}";
      photo_sub_items.add(CardPhotoItem(url: url, type: "p"));
    }

    if(photo_sub_items.isEmpty) {
      if(insttFile.isNotEmpty) {
        if(!insttFile.startsWith("http")) {
          String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${insttFile}&fileSn=0";
          photo_sub_items.add(CardPhotoItem(url: url, type: "p"));
        }
        else {
          photo_sub_items.add(CardPhotoItem(url: insttFile, type: "p"));
        }
      }
    }
  }

  static List<InfoInst> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoInst.fromJson(data);
    }).toList();
  }

  factory InfoInst.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    var info = jdata['info'];
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(info);
    // }
    InfoInst item =  InfoInst(
      grade : (jdata['grade'] != null)
          ? double.parse(jdata['grade'].toString().trim()) : 0,
      insttSn:(info['insttSn'] != null)
          ? int.parse(info['insttSn'].toString().trim()) : 0,
      insttNm: (info['insttNm'] != null)
          ? info['insttNm'].toString().trim() : "",

      upperInsttSn: (info['upperInsttSn'] != null)
          ? info['upperInsttSn'].toString().trim() : "",
      upperInsttNm: (info['upperInsttNm'] != null)
          ? info['upperInsttNm'].toString().trim() : "",

      insttThumbFile: (info['insttThumbFile'] != null)
          ? info['insttThumbFile'].toString().trim() : "",

      insttBizCl: (info['insttBizCl'] != null)
          ? info['insttBizCl'].toString().trim() : "",
      insttSd: (info['insttSd'] != null)
          ? info['insttSd'].toString().trim() : "",
      insttSgg: (info['insttSgg'] != null)
          ? info['insttSgg'].toString().trim() : "",
      insttYmd: (info['insttYmd'] != null)
          ? info['insttYmd'].toString().trim() : "",

      longitude: (info['insttLatitude'] != null && info['insttLatitude'].toString().isNotEmpty)
          ? double.parse(info['insttLatitude'].toString().trim()) : 0.0,
      latitude: (info['insttLongitude'] != null && info['insttLongitude'].toString().isNotEmpty)
          ? double.parse(info['insttLongitude'].toString().trim()) : 0.0,

      insttAdres: (info['insttAdres'] != null)
          ? info['insttAdres'].toString().trim() : "",

      insttAdresDetail: (info['insttAdresDetail'] != null)
          ? info['insttAdresDetail'].toString().trim() : "",

      insttCoTelno: (info['insttCoTelno'] != null)
          ? info['insttCoTelno'].toString().trim() : "",

      insttEml: (info['insttEml'] != null)
          ? info['insttEml'].toString().trim() : "",
      insttRprsntv: (info['insttRprsntv'] != null)
          ? info['insttRprsntv'].toString().trim() : "",
      insttHomepage: (info['insttHomepage'] != null)
          ? info['insttHomepage'].toString().trim() : "",
      insttTotalPsn: (info['insttTotalPsn'] != null)
          ? info['insttTotalPsn'].toString().trim() : "",
      insttNowPsn: (info['insttNowPsn'] != null)
          ? info['insttNowPsn'].toString().trim() : "",
      insttChrg: (info['insttChrg'] != null)
          ? info['insttChrg'].toString().trim() : "",
      insttInnb: (info['insttInnb'] != null)
          ? info['insttInnb'].toString().trim() : "",
      insttDc: (info['insttDc'] != null)
          ? info['insttDc'].toString().trim() : "",
      insttEtc: (info['insttEtc'] != null)
          ? info['insttEtc'].toString().trim() : "",
      insttSpce: (info['insttSpce'] != null)
          ? info['insttSpce'].toString().trim() : "",
      insttAge: (info['insttAge'] != null)
          ? info['insttAge'].toString().trim() : "",
      insttChrge: (info['insttChrge'] != null)
          ? info['insttChrge'].toString().trim() : "",
      insttEmp: (info['insttEmp'] != null)
          ? info['insttEmp'].toString().trim() : "",
      insttTime: (info['insttTime'] != null)
          ? info['insttTime'].toString().trim() : "",
      insttRqisit: (info['insttRqisit'] != null)
          ? info['insttRqisit'].toString().trim() : "",
      insttHvof: (info['insttHvof'] != null)
          ? info['insttHvof'].toString().trim() : "",
      insttAgeType: (info['insttAgeType'] != null)
          ? info['insttAgeType'].toString().trim() : "",
      insttOperAll: (info['insttOperAll'] != null)
          ? info['insttOperAll'].toString().trim() : "",
      insttOperDt: (info['insttOperDt'] != null)
          ? info['insttOperDt'].toString().trim() : "",
      insttOperEmrg: (info['insttOperEmrg'] != null)
          ? info['insttOperEmrg'].toString().trim() : "",
      insttOperEtc: (info['insttOperEtc'] != null)
          ? info['insttOperEtc'].toString().trim() : "",
      insttMlsv: (info['insttMlsv'] != null)
          ? info['insttMlsv'].toString().trim() : "",
      insttMlsvEtc: (info['insttMlsvEtc'] != null)
          ? info['insttMlsvEtc'].toString().trim() : "",
      insttShuttle: (info['insttShuttle'] != null)
          ? info['insttShuttle'].toString().trim() : "",
      insttShuttleEtc: (info['insttShuttleEtc'] != null)
          ? info['insttShuttleEtc'].toString().trim() : "",
      insttProgrm: (info['insttProgrm'] != null)
          ? info['insttProgrm'].toString().trim() : "",
      insttType: (info['insttType'] != null)
          ? info['insttType'].toString().trim() : "",

      insttTempPsn: (info['insttTempPsn'] != null)
          ? info['insttTempPsn'].toString().trim() : "",
      ioaPsncpa:(info['ioaPsncpa'] != null)
            ? info['ioaPsncpa'].toString().trim() : "",

      insttSnsv: (info['insttSnsv'] != null)
          ? info['insttSnsv'].toString().trim() : "",
      insttRgst: (info['insttRgst'] != null)
          ? info['insttRgst'].toString().trim() : "",
      insttTime1: (info['insttTime1'] != null)
          ? info['insttTime1'].toString().trim() : "",
      insttTime2: (info['insttTime2'] != null)
          ? info['insttTime2'].toString().trim() : "",
      insttTime3: (info['insttTime3'] != null)
          ? info['insttTime3'].toString().trim() : "",

      extrlLinkDomn: (info['extrlLinkDomn'] != null)
          ? info['extrlLinkDomn'].toString().trim() : "",

      extrlLinkScrtyKey: (info['extrlLinkScrtyKey'] != null)
          ? info['extrlLinkScrtyKey'].toString().trim() : "",

      mberId: (info['mberId'] != null)
          ? info['mberId'].toString().trim() : "",

      insttFile: (info['insttFile'] != null)
          ? info['insttFile'].toString().trim() : "",

      myDstnc: (info['myDstnc'] != null)
          ? double.parse(info['myDstnc'].toString().trim()) : 0.0,
    );

    var list = ItemPhoto.fromSnapshot(jdata['files']);
    item.setPhotoList(list);

    //item.insttDc =  item.insttDc.replaceAll("\r\n", "");
    //item.insttDc =  item.insttDc.replaceAll("  ", " ");
    //item.insttProgrm = item.insttProgrm.replaceAll("\r\n ", "\r\n");
    //item.photo_items = [ CardPhotoItem(url: info.insttThumbFile, type: 'p', ) ];

    item.link = "${item.extrlLinkDomn}/extr-link/view.do?key=${item.extrlLinkScrtyKey}";
    //print(info.link);
    return item;
  }
}
