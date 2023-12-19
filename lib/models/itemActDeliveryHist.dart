// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemActDeliveryHist {
  String dlvrSn;
  String dlvrTy;
  String dlvrSj;
  String dlvrZip;
  String dlvrAdres;
  String dlvrDtlAdres;
  String dlvrPlace;
  String mtchgYn;
  String mtchgDt;
  bool bSelect;

  ItemActDeliveryHist({
    this.dlvrTy="",
    this.dlvrSn="",
    this.dlvrZip="",
    this.dlvrSj ="",
    this.dlvrAdres="",
    this.dlvrDtlAdres ="",
    this.dlvrPlace ="",
    this.mtchgDt="",
    this.mtchgYn="",
    this.bSelect = false,
  });

  String date() {
    return (mtchgDt.length>10) ? mtchgDt.substring(0,10) : mtchgDt;
  }

  String status() {
    return (mtchgYn=="Y") ? "매칭완료" : "대기중";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "dlvrTy":dlvrTy,
      "dlvrSj":dlvrSj,
      "dlvrPlace":dlvrPlace,
      "dlvrZip":dlvrZip,
      "dlvrAdres":dlvrAdres,
      "mtchgYn":mtchgYn,
      "mtchgDt":mtchgDt,
    };

    if(dlvrSn.isNotEmpty) {
      map.addAll({"dlvrSn":dlvrSn});
    }
    return map;
  }

  static List<ItemActDeliveryHist> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemActDeliveryHist.fromJson(data);
    }).toList();
  }

  factory ItemActDeliveryHist.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemActDeliveryHist(
      dlvrSn: (jdata['dlvrSn'] != null)
          ? jdata['dlvrSn'].toString().trim() : "",

      dlvrTy: (jdata['dlvrTy'] != null)
          ? jdata['dlvrTy'].toString().trim() : "",

      dlvrSj: (jdata['dlvrSj'] != null)
          ? jdata['dlvrSj'].toString().trim() : "",

      dlvrZip: (jdata['dlvrZip'] != null)
          ? jdata['dlvrZip'].toString().trim() : "",

      dlvrAdres: (jdata['dlvrAdres'] != null)
          ? jdata['dlvrAdres'].toString().trim() : "",

      dlvrDtlAdres: (jdata['dlvrDtlAdres'] != null)
          ? jdata['dlvrDtlAdres'].toString().trim() : "",

      dlvrPlace: (jdata['dlvrPlace'] != null)
          ? jdata['dlvrPlace'].toString().trim() : "",

      mtchgYn: (jdata['mtchgYn'] != null)
          ? jdata['mtchgYn'].toString().trim() : "",

      mtchgDt: (jdata['mtchgDt'] != null)
          ? jdata['mtchgDt'].toString().trim() : "",

    );
  }

}
