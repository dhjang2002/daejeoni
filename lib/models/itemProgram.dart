// ignore_for_file: non_constant_identifier_names, file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemProgram {
  String eduSn;               // id
  String image_url;           // 사진
  String eduSj;               // 타이틀
  String eduCn;           // 내용
  String eduDc;           // 내용
  String eduBgngDt;           // 교육기간-시작
  String eduEndDt;            // 교육기간-종료
  String eduTy;               // 프로그램 종류
  String rcptBgngDt;          // 신청기간-시작
  String rcptEndDt;           // 신청기간-종료
  //String aplyLmttFamilyCnt;   // 최대 신청가능 가족수
  String totEduTime;          // 총 교육시간
  String eduProgrsSt;         // ???

  String ddlnYn;              // "N"신청가능
  String scrtyKey;
  String partcptnTrgt;      // 참여대상
  String progrsInqry;       // 진행문의
  String progrsPlace;       // 진행장소
  String progrsPlaceDtl;
  String urlAdres;          // URL 주소
  String partcptCt;         // 참가비용
  int aplyLmttFamilyCnt;    // 최대 신청가능 가족수
  int waitLmttFamilyCnt;    // 현재 신청가능 가족수

  double myDstnc;
  String gpsX;
  String gpsY;
  String guCode;
  String openInstt;

  ItemProgram({
    this.openInstt = "",
    this.myDstnc = -0.1,
    this.gpsX="",
    this.gpsY="",
    this.guCode="",

    this.eduSn = "",
    this.eduCn = "",
    this.eduDc = "",
    this.image_url = "",
    this.eduBgngDt = "",
    this.eduSj = "",
    //this.content = "",
    this.eduEndDt="",

    this.eduTy="",
    this.rcptBgngDt="",
    this.rcptEndDt="",
    this.aplyLmttFamilyCnt=0,
    this.waitLmttFamilyCnt=0,
    this.totEduTime="",
    this.ddlnYn="",
    this.eduProgrsSt="",
    this.scrtyKey="",
    this.partcptnTrgt="",
    this.progrsInqry="",
    this.progrsPlace="",
    this.progrsPlaceDtl="",
    this.urlAdres="",
    this.partcptCt="",
  });

  /*
CID0002   대덕구
CID0003   동구
CID0004   서구
CID0005   유성구
CID0006   중구
 */
  String getArea() {
    switch(guCode) {
      case "CID0002": return "대덕구";
      case "CID0003": return "동구";
      case "CID0004": return "서구";
      case "CID0005": return "유성구";
      case "CID0006": return "중구";
      default: return "알수없음";
    }
  }

  bool checkDate() {
    DateTime startDate = DateTime.parse(rcptBgngDt);
    DateTime endDate = DateTime.parse(rcptEndDt);
    DateTime currentDate = DateTime.now();

    if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate)) {
      //print('현재 날짜는 범위 내에 있습니다.');
      return true;
    } else {
      //print('현재 날짜는 범위 밖에 있습니다.');
      return false;
    }
  }

  /*
      ddlnYn == 'Y'
    <<신청마감>>

    ddlnYn == 'Y' 이고 urlAdres 가 빈값이 아니면
    <<(외부)신청페이지이동>>

    ddlnYn == 'Y' 이고 urlAdres == 'no-url' or urlAdres is null or urlAdres == ''
    <<상세페이지 이동>>

    ddlnYn == '' 빈값이거나 N 이면서
    오늘 < rcptBgngDt
    =>  "신청기간이 아닙니다"
    오늘  > rcptEndDt가
    => "신청기간이 종료되었습니다"

    else
    <<신청페이지이동(상세페이지)>>
   */

  //
  // ddlnYn == 'Y' 이고 urlAdres 가 빈값이 아니면
  // <<(외부)신청페이지이동>>
  //
  String applyType() {
    if(isExternalLink()) {
      return "외부기관 접수";
    }
    if(validate().isNotEmpty || ddlnYn == 'Y') {
      return "신청마감";
    }
    return "";
  }

  bool isExternalLink() {
    if(ddlnYn == 'Y' && urlAdres.isNotEmpty) {
      return true;
    }
    return false;
  }

  String rangeText(String bgText, String edText, String dvText) {
    String value = "";
    if(bgText.length>=10) {
      value = bgText.substring(0,10).replaceAll("-", ".");
    } else {
      value = bgText.replaceAll("-", ".");
    }
    if(value.isNotEmpty) {
      value += dvText;
    }
    value += " ~ ";
    if(bgText.length>=10) {
      value += edText.substring(0,10).replaceAll("-", ".");
    } else {
      value += edText.replaceAll("-", ".");
    }
    return value;
  }
  String validateMessage = "";
  void setValidate() {
    validateMessage = "";
    DateTime startDate = DateTime.parse(rcptBgngDt);
    DateTime endDate = DateTime.parse(rcptEndDt);
    DateTime currentDate = DateTime.now();
    if(currentDate.isAfter(endDate)){
      validateMessage = "신청기간이 종료되었습니다";
    } else {

      if (ddlnYn == 'N' || ddlnYn.isEmpty) {
        if (currentDate.isBefore(startDate)) {
          validateMessage = "신청기간이 아닙니다";
        }
      }
    }
  }

  String validate() {
    return validateMessage;
  }

  bool isAvailable() {
    if(isExternalLink() || validateMessage.isEmpty){
      return true;
    }
    // if(ddlnYn.isEmpty || ddlnYn=="N" && checkDate()) {
    //   // 날짜체크
    //   return true;
    // }
    return false;
  }

  String title() {
    String value = "";
    var items = eduSj.split("(");
    if(items.isNotEmpty) {
      value = items[0];
    }
    return value;
  }

  String subTitle() {
    String value = "";
    var items = eduSj.split("(");
    if(items.length>1) {
      value = items[1].replaceAll(")", "");
    }
    return value;
  }

  String getCategory() {
    switch(eduTy) {
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

  static List<ItemProgram> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemProgram.fromJson(data);
    }).toList();
  }

  factory ItemProgram.fromJson(Map<String, dynamic> jdata)
  {
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemProgram item =  ItemProgram(
      openInstt:(jdata['openInstt'] != null) ? jdata['openInstt'].toString().trim() : "",
      eduSn: (jdata['eduSn'] != null) ? jdata['eduSn'].toString().trim() : "",
      eduCn: (jdata['eduCn'] != null) ? jdata['eduCn'].toString().trim() : "",
      eduDc: (jdata['eduDc'] != null) ? jdata['eduDc'].toString().trim() : "",
      image_url: (jdata['rprsThumbImage'] != null) ? jdata['rprsThumbImage'].toString().trim() : "",
      eduSj: (jdata['eduSj'] != null) ? jdata['eduSj'].toString().trim() : "",
      //content: (jdata['eduDc'] != null) ? jdata['eduDc'].toString().trim() : "",
      eduBgngDt: (jdata['eduBgngDt'] != null) ? jdata['eduBgngDt'].toString().trim() : "",
      eduEndDt: (jdata['eduEndDt'] != null) ? jdata['eduEndDt'].toString().trim() : "",
      eduTy: (jdata['eduTy'] != null) ? jdata['eduTy'].toString().trim() : "",
      rcptBgngDt: (jdata['rcptBgngDt'] != null) ? jdata['rcptBgngDt'].toString().trim() : "",
      rcptEndDt: (jdata['rcptEndDt'] != null) ? jdata['rcptEndDt'].toString().trim() : "",
      aplyLmttFamilyCnt: (jdata['aplyLmttFamilyCnt'] != null)
          ? int.parse(jdata['aplyLmttFamilyCnt'].toString().trim()) : 0,
      waitLmttFamilyCnt: (jdata['waitLmttFamilyCnt'] != null)
          ? int.parse(jdata['aplyLmttFamilyCnt'].toString().trim()) : 0,
      totEduTime: (jdata['totEduTime'] != null) ? jdata['totEduTime'].toString().trim() : "",
      ddlnYn: (jdata['ddlnYn'] != null) ? jdata['ddlnYn'].toString().trim() : "",
      eduProgrsSt: (jdata['eduProgrsSt'] != null) ? jdata['eduProgrsSt'].toString().trim() : "",
      scrtyKey: (jdata['scrtyKey'] != null) ? jdata['scrtyKey'].toString().trim() : "",
      partcptnTrgt: (jdata['partcptnTrgt'] != null) ? jdata['partcptnTrgt'].toString().trim() : "",
      progrsInqry: (jdata['progrsInqry'] != null) ? jdata['progrsInqry'].toString().trim() : "",

      progrsPlace: (jdata['progrsPlace'] != null) ? jdata['progrsPlace'].toString().trim() : "",
      progrsPlaceDtl: (jdata['progrsPlaceDtl'] != null) ? jdata['progrsPlaceDtl'].toString().trim() : "",
      urlAdres: (jdata['urlAdres'] != null) ? jdata['urlAdres'].toString().trim() : "",
      partcptCt: (jdata['partcptCt'] != null) ? jdata['partcptCt'].toString().trim() : "",

      myDstnc: (jdata['myDstnc'] != null)
          ? double.parse(jdata['myDstnc'].toString().trim()) : -0.1,

      gpsX: (jdata['gpsX'] != null) ? jdata['gpsX'].toString().trim() : "",
      gpsY: (jdata['gpsY'] != null) ? jdata['gpsY'].toString().trim() : "",
      guCode: (jdata['guCode'] != null) ? jdata['guCode'].toString().trim() : "",
    );


    if(item.image_url.isNotEmpty && !item.image_url.startsWith("http")) {
       item.image_url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.image_url}&fileSn=0";
    }

    if(item.eduBgngDt.length>15) {
      item.eduBgngDt = item.eduBgngDt.substring(0,16);
    }
    if(item.eduEndDt.length>15) {
      item.eduEndDt = item.eduEndDt.substring(0,16);
    }

    if(item.rcptBgngDt.length>15) {
      item.rcptBgngDt = item.rcptBgngDt.substring(0,16);
    }
    if(item.rcptEndDt.length>15) {
      item.rcptEndDt = item.rcptEndDt.substring(0,16);
    }

    item.urlAdres = item.urlAdres.replaceAll("no-url", "");
    item.setValidate();

    // print("----------> item.urlAdres:${item.urlAdres}");
    return item;
  }
}