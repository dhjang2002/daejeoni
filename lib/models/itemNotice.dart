// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemNotice {
  String boardSn; // id
  String regDt;       // 등록일자
  String boardSj;     // 타이틀
  String boardCn;     // 내용
  String atchFileId;
  String boardRdcnt;  // 조회 카운트
  bool   showMore;

  ItemNotice({
    this.boardSn = "",
    this.regDt = "",
    this.boardSj = "",
    this.boardCn = "",
    this.atchFileId="",
    this.boardRdcnt="",
    this.showMore = false,
  });

  static List<ItemNotice> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemNotice.fromJson(data);
    }).toList();
  }

  factory ItemNotice.fromJson(Map<String, dynamic> jdata)
  {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemNotice item = ItemNotice(
      boardSn: (jdata['boardSn'] != null) ? jdata['boardSn'].toString().trim() : "",
      boardSj: (jdata['boardSj'] != null) ? jdata['boardSj'].toString().trim() : "",
      boardCn: (jdata['boardCn'] != null) ? jdata['boardCn'].toString().trim() : "",
      atchFileId:(jdata['atchFileId'] != null) ? jdata['atchFileId'].toString().trim() : "",
      regDt: (jdata['regDt'] != null) ? jdata['regDt'].toString().trim() : "",
      boardRdcnt: (jdata['boardRdcnt'] != null) ? jdata['boardRdcnt'].toString().trim() : "",
    );
    return item;
  }
}