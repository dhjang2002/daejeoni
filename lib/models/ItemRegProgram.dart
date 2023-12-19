// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemRegProgram {
  String reqstdocSn;
  String aplcntNm;            // 신청자 이름
  String regDt;               // 신청일자
  String partcptnDtJson;      // 신청내용
  String cnterNewsRcptnYn;    // 센터소식 수신여부
  String partcptSttusAt;      // 접수상태


  bool bSelect;

  ItemRegProgram({
    this.reqstdocSn="",
    this.aplcntNm="",
    this.partcptnDtJson ="",
    this.cnterNewsRcptnYn ="",
    this.partcptSttusAt="",
    this.regDt="",
    this.bSelect = false,
  });

  String state() {
    switch(partcptSttusAt) {
      case "W":
        return "대기";
      default:
        return "승인";
    }

  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
    };

    if(reqstdocSn.isNotEmpty) {
      map.addAll({"reqstdocSn":reqstdocSn});
    }
    return map;
  }

  static List<ItemRegProgram> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemRegProgram.fromJson(data);
    }).toList();
  }

  factory ItemRegProgram.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemRegProgram item = ItemRegProgram(
      reqstdocSn: (jdata['reqstdocSn'] != null)
          ? jdata['reqstdocSn'].toString().trim() : "",

      aplcntNm: (jdata['aplcntNm'] != null)
          ? jdata['aplcntNm'].toString().trim() : "",

      partcptnDtJson: (jdata['partcptnDtJson'] != null)
          ? jdata['partcptnDtJson'].toString().trim() : "",

      cnterNewsRcptnYn: (jdata['cnterNewsRcptnYn'] != null)
          ? jdata['cnterNewsRcptnYn'].toString().trim() : "",

      partcptSttusAt: (jdata['partcptSttusAt'] != null)
          ? jdata['partcptSttusAt'].toString().trim() : "",

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }

    return item;
  }

}
