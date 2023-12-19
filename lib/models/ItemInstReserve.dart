// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemInstReserve {
  String insttResveSn;
  String insttNm;
  String insttResveDt;
  String regDt;
  String insttResveTm;
  String insttResvePerson;
  String insttResveOper;
  String insttResveOperTm;
  String insttResvePrice;
  String insttResveStatus;
  String insttResveNm;

  String insttResveChildNm;
  String insttResvePayNm;
  String insttResveMblTelno;
  String insttResveChildMblTelno;
  String insttResveMemo;
  String insttResveChildSexdstn;
  String insttResveChldrnBrdt;
  String insttResveAtend;


  String insttOperGroupKey;

  bool bSelect;

  ItemInstReserve({
    this.insttNm="",
    this.insttResveSn="",
    this.insttResveTm="",
    this.insttResveDt ="",
    this.insttResvePerson="",
    this.insttResveOper ="",
    this.insttResveOperTm ="",
    this.insttResveStatus="",
    this.insttResvePrice="",
    this.insttResveNm="",

    this.insttResveChildNm="",
    this.insttResvePayNm="",
    this.insttResveMblTelno="",
    this.insttResveChildMblTelno="",
    this.insttResveMemo="",
    this.insttResveChildSexdstn="",
    this.insttResveChldrnBrdt="",
    this.insttResveAtend="",
    this.regDt="",
    this.insttOperGroupKey="",

    this.bSelect = false,
  });

  String sex() {
    if(insttResveChildSexdstn=="1") {
      return "남아";
    }
    return "여야";
  }

  String type() {
    if(insttResveOper=="ALL") {
      return "상시";
    }
    return "일시";
  }

  String status() {
    if(insttResveStatus=="STANDBY") {
      return "대기";
    }
    return "";
  }

  String getProfile() {
    String sex = (insttResveOperTm=="1") ? "남" : "여";
    String age = "";
    if(insttResveDt.length>4) {
      int year = int.parse(insttResveDt.substring(0,4));
      int now  = DateTime.now().year;
      int iage = now-year+1;

      //print("year:$year, now:$now, iage:$iage");

      if(iage>0 && iage<110) {
        age = "$iage";
      }
    }

    String profile = "$sex, $age세 ( $insttResveDt )";
    return profile;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "parntsChldrnNm":insttNm,
      "parntsChldrnBrdt":insttResveDt,
      "parntsSexdstn":insttResveOperTm,
      "parntsTrobl":insttResveTm,
      "parntsTroblType":insttResvePerson,
      "parntsChldrnDcc":insttResvePrice,
      "parntsChldrnKndrgr":insttResveStatus,
      "parntsChldrnElesch":insttResveNm
    };

    if(insttResveSn.isNotEmpty) {
      map.addAll({"parntsSn":insttResveSn});
    }
    return map;
  }

  static List<ItemInstReserve> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemInstReserve.fromJson(data);
    }).toList();
  }

  factory ItemInstReserve.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    ItemInstReserve info = ItemInstReserve(
      insttResveSn: (jdata['insttResveSn'] != null)
          ? jdata['insttResveSn'].toString().trim() : "",

      insttNm: (jdata['insttNm'] != null)
          ? jdata['insttNm'].toString().trim() : "",

      insttResveDt: (jdata['insttResveDt'] != null)
          ? jdata['insttResveDt'].toString().trim() : "",

      insttResveTm: (jdata['insttResveTm'] != null)
          ? jdata['insttResveTm'].toString().trim() : "",

      insttResvePerson: (jdata['insttResvePerson'] != null)
          ? jdata['insttResvePerson'].toString().trim() : "",

      insttResveOper: (jdata['insttResveOper'] != null)
          ? jdata['insttResveOper'].toString().trim() : "",

      insttResveOperTm: (jdata['insttResveOperTm'] != null)
          ? jdata['insttResveOperTm'].toString().trim() : "",

      insttResvePrice: (jdata['insttResvePrice'] != null)
          ? jdata['insttResvePrice'].toString().trim() : "",

      insttResveStatus: (jdata['insttResveStatus'] != null)
          ? jdata['insttResveStatus'].toString().trim() : "",

      insttResveNm: (jdata['insttResveNm'] != null)
          ? jdata['insttResveNm'].toString().trim() : "",

      insttResvePayNm: (jdata['insttResvePayNm'] != null)
          ? jdata['insttResvePayNm'].toString().trim() : "",

      insttResveChildNm:(jdata['insttResveChildNm'] != null)
            ? jdata['insttResveChildNm'].toString().trim() : "",
      insttResveMblTelno: (jdata['insttResveMblTelno'] != null)
          ? jdata['insttResveMblTelno'].toString().trim() : "",
      insttResveChildMblTelno: (jdata['insttResveChildMblTelno'] != null)
          ? jdata['insttResveChildMblTelno'].toString().trim() : "",
      insttResveMemo: (jdata['insttResveMemo'] != null)
          ? jdata['insttResveMemo'].toString().trim() : "",
      insttResveChildSexdstn: (jdata['insttResveChildSexdstn'] != null)
          ? jdata['insttResveChildSexdstn'].toString().trim() : "",
      insttResveChldrnBrdt: (jdata['insttResveChldrnBrdt'] != null)
          ? jdata['insttResveChldrnBrdt'].toString().trim() : "",
      insttResveAtend: (jdata['insttResveAtend'] != null)
          ? jdata['insttResveAtend'].toString().trim() : "",
      regDt: (jdata['regDt'] != null)
          ? jdata['regDt'].toString().trim() : "",

      insttOperGroupKey:(jdata['insttOperGroupKey'] != null)
            ? jdata['insttOperGroupKey'].toString().trim() : "",
    );

    if(info.regDt.length>10) {
      info.regDt = info.regDt.substring(0,10);
    }
    return info;
  }

}
