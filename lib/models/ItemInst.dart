// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemInst {
  String parntsSn;
  String parntsChldrnNm;
  String parntsChldrnBrdt;
  String parntsTroblYn;
  String parntsTroblType;
  String parntsChldrnSchul;
  String parntsSexdstn;
  String parntsChldrnDcc;
  String parntsChldrnKndrgr;
  String parntsChldrnElesch;
  bool bSelect;

  ItemInst({
    this.parntsChldrnNm="",
    this.parntsSn="",
    this.parntsTroblYn="",
    this.parntsChldrnBrdt ="",
    this.parntsTroblType="",
    this.parntsChldrnSchul ="",
    this.parntsSexdstn ="",
    this.parntsChldrnKndrgr="",
    this.parntsChldrnDcc="",
    this.parntsChldrnElesch="",
    this.bSelect = false,
  });

  String getDesc() {
    String desc = "";

    // 어린이집
    if(parntsChldrnDcc.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$parntsChldrnDcc";
    }

    // 유치원
    if(parntsChldrnKndrgr.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$parntsChldrnKndrgr";
    }

    // 초등학교
    if(parntsChldrnElesch.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$parntsChldrnElesch";
    }

    return desc;
  }

  String getProfile() {
    String sex = (parntsSexdstn=="1") ? "남" : "여";
    String age = "";
    if(parntsChldrnBrdt.length>4) {
      int year = int.parse(parntsChldrnBrdt.substring(0,4));
      int now  = DateTime.now().year;
      int iage = now-year+1;

      //print("year:$year, now:$now, iage:$iage");

      if(iage>0 && iage<110) {
        age = "$iage";
      }
    }

    String profile = "$sex, $age세 ( $parntsChldrnBrdt )";
    return profile;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "parntsChldrnNm":parntsChldrnNm,
      "parntsChldrnBrdt":parntsChldrnBrdt,
      "parntsSexdstn":parntsSexdstn,
      "parntsTrobl":parntsTroblYn,
      "parntsTroblType":parntsTroblType,
      "parntsChldrnDcc":parntsChldrnDcc,
      "parntsChldrnKndrgr":parntsChldrnKndrgr,
      "parntsChldrnElesch":parntsChldrnElesch
    };

    if(parntsSn.isNotEmpty) {
      map.addAll({"parntsSn":parntsSn});
    }
    return map;
  }

  static List<ItemInst> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemInst.fromJson(data);
    }).toList();
  }

  factory ItemInst.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemInst(
      parntsSn: (jdata['parntsSn'] != null)
          ? jdata['parntsSn'].toString().trim() : "",

      parntsChldrnNm: (jdata['parntsChldrnNm'] != null)
          ? jdata['parntsChldrnNm'].toString().trim() : "",

      parntsChldrnBrdt: (jdata['parntsChldrnBrdt'] != null)
          ? jdata['parntsChldrnBrdt'].toString().trim() : "",

      parntsTroblYn: (jdata['parntsTroblYn'] != null)
          ? jdata['parntsTroblYn'].toString().trim() : "",

      parntsTroblType: (jdata['parntsTroblType'] != null)
          ? jdata['parntsTroblType'].toString().trim() : "",

      parntsChldrnSchul: (jdata['parntsChldrnSchul'] != null)
          ? jdata['parntsChldrnSchul'].toString().trim() : "",

      parntsSexdstn: (jdata['parntsSexdstn'] != null)
          ? jdata['parntsSexdstn'].toString().trim() : "",

      parntsChldrnDcc: (jdata['parntsChldrnDcc'] != null)
          ? jdata['parntsChldrnDcc'].toString().trim() : "",

      parntsChldrnKndrgr: (jdata['parntsChldrnKndrgr'] != null)
          ? jdata['parntsChldrnKndrgr'].toString().trim() : "",

      parntsChldrnElesch: (jdata['parntsChldrnElesch'] != null)
          ? jdata['parntsChldrnElesch'].toString().trim() : "",
    );
  }

}
