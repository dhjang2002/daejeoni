// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class InfoInstGallery {
  String boardSn; // id
  String boardSj;     // 타이틀
  String boardCn;     // 내용
  String boardRdcnt;  // 조회 카운트
  String atchFileId;
  String regId;
  String regDt;       // 등록일자
  String mberId;
  bool   showMore;

  InfoInstGallery({
    this.boardSn = "",
    this.regDt = "",
    this.boardSj = "",
    this.boardCn = "",
    this.atchFileId="",
    this.boardRdcnt="",
    this.regId="",
    this.mberId="",
    this.showMore = false,
  });

  static List<InfoInstGallery> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return InfoInstGallery.fromJson(data);
    }).toList();
  }

  factory InfoInstGallery.fromJson(Map<String, dynamic> jdata)
  {
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    InfoInstGallery item = InfoInstGallery(
      boardSn: (jdata['boardSn'] != null) ? jdata['boardSn'].toString().trim() : "",
      boardSj: (jdata['boardSj'] != null) ? jdata['boardSj'].toString().trim() : "",
      boardCn: (jdata['boardCn'] != null) ? jdata['boardCn'].toString().trim() : "",
      atchFileId:(jdata['atchFileId'] != null) ? jdata['atchFileId'].toString().trim() : "",
      regDt: (jdata['regDt'] != null) ? jdata['regDt'].toString().trim() : "",
      regId: (jdata['regId'] != null) ? jdata['regId'].toString().trim() : "",
      boardRdcnt: (jdata['boardRdcnt'] != null) ? jdata['boardRdcnt'].toString().trim() : "",
      mberId: (jdata['mberId'] != null) ? jdata['mberId'].toString().trim() : "",
    );
    return item;
  }
}