// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemStamp {
  String schdulSn;
  String schdulSj;
  String bgngDt;
  bool bSelect;

  ItemStamp({
    this.schdulSj="",
    this.schdulSn="",
    this.bgngDt ="",
    this.bSelect = false,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "schdulSn":schdulSn,
      "schdulSj":schdulSj,
      "bgngDt":bgngDt,
    };
    return map;
  }

  static List<ItemStamp> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemStamp.fromJson(data);
    }).toList();
  }

  factory ItemStamp.fromJson(Map<String, dynamic> jdata){
    if (kDebugMode) {
      var logger = Logger();
      logger.d(jdata);
    }

    return ItemStamp(
      schdulSn: (jdata['schdulSn'] != null)
          ? jdata['schdulSn'].toString().trim() : "",

      schdulSj: (jdata['schdulSj'] != null)
          ? jdata['schdulSj'].toString().trim() : "",

      bgngDt: (jdata['bgngDt'] != null)
          ? jdata['bgngDt'].toString().trim() : "",
    );
  }

}
