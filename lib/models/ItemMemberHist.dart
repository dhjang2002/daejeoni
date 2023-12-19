// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemMemberHist {
  String mberHistSn;
  String mberHistNm;      // 학교명
  String mberHistMajor;   // 전공 (고등학교 이상)
  String mberHistBgngYm;  // 재학기간
  String mberHistEndYm;   // 재학기간
  String mberHistTy;
  bool   bSelect;

  ItemMemberHist({
    this.mberHistNm="",
    this.mberHistSn="",
    this.mberHistEndYm="",
    this.mberHistBgngYm ="",
    this.mberHistMajor="",
    this.mberHistTy="",
    this.bSelect = false,
  });

  /*
  String getTypeText() {
    switch(mberHistTy) {
      case "acdmcr": return "초등학교";
      case "acdmcr": return "중학교";
      case "acdmcr": return "고등학교";
      case "acdmcr": return "대학교・대학원";
      default: return "알수없음";
    }
  }
  bool isMajor() {
    switch(mberHistTy) {
      case "acdmcr": return true;
      case "acdmcr": return false;
      case "acdmcr": return true;
      case "acdmcr": return true;
      default: return false;
    }
  }
  */
  // {
  // "mberHistSn":"362",
  // "mberHistNm":"대학교명",
  // "mberHistMajor":"대학교전공",
  // "mberHistBgngYm":"2023-03",
  // "mberHistEndYm":"2023-12"
  // }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "mberHistSn":mberHistSn,
      "mberHistNm":mberHistNm,
      "mberHistMajor":mberHistMajor,
      "mberHistBgngYm":mberHistBgngYm,
      "mberHistEndYm":mberHistEndYm,
    };
    return map;
  }

  static List<ItemMemberHist> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemMemberHist.fromJson(data);
    }).toList();
  }

  factory ItemMemberHist.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemMemberHist(
      mberHistSn: (jdata['mberHistSn'] != null)
          ? jdata['mberHistSn'].toString().trim() : "",

      mberHistNm: (jdata['mberHistNm'] != null)
          ? jdata['mberHistNm'].toString().trim() : "",

      mberHistTy: (jdata['mberHistTy'] != null)
          ? jdata['mberHistTy'].toString().trim() : "",

      mberHistMajor: (jdata['mberHistMajor'] != null)
          ? jdata['mberHistMajor'].toString().trim() : "",

      mberHistBgngYm: (jdata['mberHistBgngYm'] != null)
          ? jdata['mberHistBgngYm'].toString().trim() : "",

      mberHistEndYm: (jdata['mberHistEndYm'] != null)
          ? jdata['mberHistEndYm'].toString().trim() : "",

    );
  }

}
