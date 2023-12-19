// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemInstNotice {
  String boardSn; // id
  String boardSj;     // 타이틀
  String boardCn;     // 내용
  String boardRdcnt;  // 조회 카운트
  String atchFileId;
  String regId;
  String regDt;       // 등록일자
  bool   showMore;

  ItemInstNotice({
    this.boardSn = "",
    this.regDt = "",
    this.boardSj = "",
    this.boardCn = "",
    this.atchFileId="",
    this.boardRdcnt="",
    this.regId="",
    this.showMore = false,
  });

  static List<ItemInstNotice> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemInstNotice.fromJson(data);
    }).toList();
  }

  factory ItemInstNotice.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemInstNotice item = ItemInstNotice(
      boardSn: (jdata['boardSn'] != null) ? jdata['boardSn'].toString().trim() : "",
      boardSj: (jdata['boardSj'] != null) ? jdata['boardSj'].toString().trim() : "",
      boardCn: (jdata['boardCn'] != null) ? jdata['boardCn'].toString().trim() : "",
      atchFileId:(jdata['atchFileId'] != null) ? jdata['atchFileId'].toString().trim() : "",
      regDt: (jdata['regDt'] != null) ? jdata['regDt'].toString().trim() : "",
      regId: (jdata['regId'] != null) ? jdata['regId'].toString().trim() : "",
      boardRdcnt: (jdata['boardRdcnt'] != null) ? jdata['boardRdcnt'].toString().trim() : "",
    );
    return item;
  }
}