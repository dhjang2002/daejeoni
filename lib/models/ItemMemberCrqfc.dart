// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemMemberCrqfc {
  String mberHistSn;
  String crqfcNm;         // 자격명
  String crqfcPblcn;      // 발행처
  String crqfcRegYm;      // 취득일
  bool bSelect;

  ItemMemberCrqfc({
    this.mberHistSn="",
    this.crqfcNm="",
    this.crqfcPblcn ="",
    this.crqfcRegYm ="",
    this.bSelect = false,
  });

  // {
  // "mberHistSn":"363",
  // "mberHistNm":"자격명",
  // "mberHistMajor":"발행처",
  // "mberHistBgngYm":"2023-05"
  // },
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "mberHistSn":mberHistSn,
      "mberHistNm":crqfcNm,
      "mberHistBgngYm":crqfcRegYm,
      "mberHistMajor":crqfcPblcn,
    };

    return map;
  }

  static List<ItemMemberCrqfc> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemMemberCrqfc.fromJson(data);
    }).toList();
  }

  factory ItemMemberCrqfc.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemMemberCrqfc(
      mberHistSn: (jdata['mberHistSn'] != null)
          ? jdata['mberHistSn'].toString().trim() : "",

      crqfcNm: (jdata['mberHistNm'] != null)
          ? jdata['mberHistNm'].toString().trim() : "",

      crqfcPblcn: (jdata['mberHistMajor'] != null)
          ? jdata['mberHistMajor'].toString().trim() : "",

      crqfcRegYm: (jdata['mberHistBgngYm'] != null)
          ? jdata['mberHistBgngYm'].toString().trim() : "",
    );
  }

}
