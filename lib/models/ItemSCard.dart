// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemSCard {
  String aplcntSn;
  String dolbomCmmntyNm;        // 공동체 명
  String dolbomCmmntyTy;        // 커뮤니티 타입
  String sportYn;               // 지원여부 (활동비 지원, 활동비 미지원)
  String regDt;                 // 신청일
  String aprvYn;                // 승인여부
  bool bSelect;

  ItemSCard({
    this.dolbomCmmntyNm="",
    this.aplcntSn="",
    this.sportYn="",
    this.dolbomCmmntyTy ="",
    this.regDt="",
    this.aprvYn ="",
    this.bSelect = false,
  });

  String getSupport() {
    switch(sportYn) {
      case "Y": return "활동비 지원";
      default: return "활동비 지원안함";
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "parntsChldrnNm":dolbomCmmntyNm,
      "parntsChldrnBrdt":dolbomCmmntyTy,
      "parntsTrobl":sportYn,
      "parntsTroblType":regDt,
    };

    if(aplcntSn.isNotEmpty) {
      map.addAll({"parntsSn":aplcntSn});
    }
    return map;
  }

  static List<ItemSCard> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemSCard.fromJson(data);
    }).toList();
  }

  factory ItemSCard.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemSCard item = ItemSCard(
      aplcntSn: (jdata['aplcntSn'] != null)
          ? jdata['aplcntSn'].toString().trim() : "",

      dolbomCmmntyNm: (jdata['dolbomCmmntyNm'] != null)
          ? jdata['dolbomCmmntyNm'].toString().trim() : "",

      dolbomCmmntyTy: (jdata['dolbomCmmntyTy'] != null)
          ? jdata['dolbomCmmntyTy'].toString().trim() : "",

      sportYn: (jdata['sportYn'] != null)
          ? jdata['sportYn'].toString().trim() : "",

      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",

      aprvYn: (jdata['aprvYn'] != null)
          ? jdata['aprvYn'].toString().trim() : "",
    );

    if(item.regDt.length>10) {
      item.regDt = item.regDt.substring(0,10);
    }

    return item;
  }

}
