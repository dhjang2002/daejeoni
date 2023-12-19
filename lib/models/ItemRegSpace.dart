// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemRegSpace {
  String aplySn;
  String spceSn;
  String hopeDt;
  String hopeBgngTm;
  String hopeEndTm;
  String aplyTelno;
  String aplyNm;
  String aplyEvent;
  String aplyCharger;
  String aplyEml;
  String spceNm;
  String aplyStatus;
  bool bSelect;

  ItemRegSpace({
    this.spceSn="",
    this.aplySn="",
    this.hopeBgngTm="",
    this.hopeDt ="",
    this.hopeEndTm="",
    this.aplyTelno ="",
    this.aplyNm ="",
    this.aplyCharger="",
    this.aplyEvent="",
    this.aplyEml="",
    this.spceNm="",
    this.aplyStatus="",
    this.bSelect = false,
  });

  String status() {
    String status = "";
    switch(aplyStatus) {
      case "COMPLEATE": status = "완료"; break;
      case "NORMAL":    status = "접수"; break;
      case "CANCEL":    status = "취소"; break;
    }
    return status;
  }

  String getDesc() {
    String desc = "";

    // 어린이집
    if(aplyEvent.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$aplyEvent";
    }

    // 유치원
    if(aplyCharger.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$aplyCharger";
    }

    // 초등학교
    if(aplyEml.isNotEmpty) {
      if(desc.isNotEmpty) {
        desc = desc + " / ";
      }
      desc = desc + "$aplyEml";
    }

    return desc;
  }

  String getProfile() {
    String sex = (aplyNm=="1") ? "남" : "여";
    String age = "";
    if(hopeDt.length>4) {
      int year = int.parse(hopeDt.substring(0,4));
      int now  = DateTime.now().year;
      int iage = now-year+1;

      //print("year:$year, now:$now, iage:$iage");

      if(iage>0 && iage<110) {
        age = "$iage";
      }
    }

    String profile = "$sex, $age세 ( $hopeDt )";
    return profile;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "parntsChldrnNm":spceSn,
      "parntsChldrnBrdt":hopeDt,
      "parntsSexdstn":aplyNm,
      "parntsTrobl":hopeBgngTm,
      "parntsTroblType":hopeEndTm,
      "parntsChldrnDcc":aplyEvent,
      "parntsChldrnKndrgr":aplyCharger,
      "parntsChldrnElesch":aplyEml
    };

    if(aplySn.isNotEmpty) {
      map.addAll({"parntsSn":aplySn});
    }
    return map;
  }

  static List<ItemRegSpace> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemRegSpace.fromJson(data);
    }).toList();
  }

  factory ItemRegSpace.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemRegSpace(
      aplySn: (jdata['aplySn'] != null)
          ? jdata['aplySn'].toString().trim() : "",

      spceSn: (jdata['spceSn'] != null)
          ? jdata['spceSn'].toString().trim() : "",

      hopeDt: (jdata['hopeDt'] != null)
          ? jdata['hopeDt'].toString().trim() : "",

      hopeBgngTm: (jdata['hopeBgngTm'] != null)
          ? jdata['hopeBgngTm'].toString().trim() : "",

      hopeEndTm: (jdata['hopeEndTm'] != null)
          ? jdata['hopeEndTm'].toString().trim() : "",

      aplyTelno: (jdata['aplyTelno'] != null)
          ? jdata['aplyTelno'].toString().trim() : "",

      aplyNm: (jdata['aplyNm'] != null)
          ? jdata['aplyNm'].toString().trim() : "",

      aplyEvent: (jdata['aplyEvent'] != null)
          ? jdata['aplyEvent'].toString().trim() : "",

      aplyCharger: (jdata['aplyCharger'] != null)
          ? jdata['aplyCharger'].toString().trim() : "",

      aplyEml: (jdata['aplyEml'] != null)
          ? jdata['aplyEml'].toString().trim() : "",

      spceNm: (jdata['spceNm'] != null)
          ? jdata['spceNm'].toString().trim() : "",
      aplyStatus: (jdata['aplyStatus'] != null)
          ? jdata['aplyStatus'].toString().trim() : "",
    );
  }

}
