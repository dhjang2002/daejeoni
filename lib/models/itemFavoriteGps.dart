import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ItemFavoriteGps {
  String mapSn;
  String mapTitle;
  String mapAddr;
  String mapDesc;
  double mapX;
  double mapY;
  bool bSelect;
  bool bCurrent;
  ItemFavoriteGps({
    this.mapSn="",
    this.mapTitle="",
    this.mapAddr ="",
    this.mapDesc = "",
    this.mapX = 0.0,
    this.mapY = 0.0,
    this.bSelect  = false,
    this.bCurrent = false,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "mapSn":mapSn,
      "mapTitle":mapTitle,
      "mapAddr":mapAddr,
      "mapDesc":mapDesc,
      "mapX":mapX,
      "mapY":mapY,
    };
    return map;
  }

  @override
  String toString() {
    return "ItemGps {mapTitle=${mapTitle}, mapAddr=${mapAddr}";
  }

  static List<ItemFavoriteGps> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ItemFavoriteGps.fromJson(data);
    }).toList();
  }

  factory ItemFavoriteGps.fromJson(Map<String, dynamic> jdata) {
    // if (kDebugMode) {
    //   var logger = Logger();
    //   logger.d(jdata);
    // }

    ItemFavoriteGps item = ItemFavoriteGps(
      mapSn: (jdata['mapSn'] != null)
          ? jdata['mapSn'].trim() : "",
      mapTitle: (jdata['mapTitle'] != null)
          ? jdata['mapTitle'].trim() : "???",
      mapAddr: (jdata['mapAddr'] != null)
          ? jdata['mapAddr'].toString().trim() : "",
      mapDesc: (jdata['mapDesc'] != null)
          ? jdata['mapDesc'].toString().trim() : "",
      mapX: (jdata['mapX'] != null)
          ? double.parse(jdata['mapX'].toString().trim()) : 0,
      mapY: (jdata['mapY'] != null)
          ? double.parse(jdata['mapY'].toString().trim()) : 0,
    );
    return item;
  }
}
