// ignore_for_file: non_constant_identifier_names, file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemCare {
  String boardSn;             // id
  String image_url;           // 사진
  String boardSj;             // 타이틀
  String boardCn;             // 내용
  String boardOrdr;           // 순서
  String boardNoticeYn;       // 알림 수신
  String regDt;                // 등록일자
  String boardRdcnt;           // 조회수
  String atchFileId;          // 첨부파일
  String ctgryCd;

  ItemCare({
    this.boardSn = "",
    this.boardOrdr = "",
    this.boardNoticeYn = "",
    this.image_url = "",
    this.boardRdcnt = "",
    this.boardSj = "",
    this.regDt="",
    this.boardCn="",
    this.atchFileId="",
    this.ctgryCd="",

  });

  String title() {
    String value = "";
    var items = boardSj.split("(");
    if(items.isNotEmpty) {
      value = items[0];
    }
    return value;
  }

  // 놀이톡톡: plyMvp, 양육톡톡:brpMvp, 양육뉴스: cardNews, 기타:etc
  String getCategory() {
    switch(ctgryCd) {
      case "plyMvp": return "놀이톡톡";
      case "brpMvp": return "양육톡톡";
      case "cardNews": return "양육뉴스";
      case "etc": return "기타";
      default: return "알수없음";
    }
  }

  static List<ItemCare> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemCare.fromJson(data);
    }).toList();
  }

  factory ItemCare.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemCare item =  ItemCare(
      boardSn: (jdata['boardSn'] != null) ? jdata['boardSn'].toString().trim() : "",
      boardOrdr: (jdata['boardOrdr'] != null) ? jdata['boardOrdr'].toString().trim() : "",
      boardNoticeYn: (jdata['boardNoticeYn'] != null) ? jdata['boardNoticeYn'].toString().trim() : "",
      //image_url: (jdata['rprsThumbImage'] != null) ? jdata['rprsThumbImage'].toString().trim() : "",
      boardSj: (jdata['boardSj'] != null) ? jdata['boardSj'].toString().trim() : "",
      boardRdcnt: (jdata['boardRdcnt'] != null) ? jdata['boardRdcnt'].toString().trim() : "",
      regDt: (jdata['regDt'] != null) ? jdata['regDt'].toString().trim() : "",
      boardCn: (jdata['boardCn'] != null) ? jdata['boardCn'].toString().trim() : "",
      atchFileId: (jdata['atchFileId'] != null) ? jdata['atchFileId'].toString().trim() : "",
      ctgryCd: (jdata['ctgryCd'] != null) ? jdata['ctgryCd'].toString().trim() : "",
    );


    if(item.atchFileId.isNotEmpty) {
       item.image_url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.atchFileId}&fileSn=0";
    }

    if(item.regDt.length>15) {
      item.regDt = item.regDt.substring(0,16);
    }

    return item;
  }
}