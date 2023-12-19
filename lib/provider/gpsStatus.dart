// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:daejeoni/utils/permissionHandler.dart';
class GpsStatus with ChangeNotifier {

  bool isInit = false;
  bool isValid = false;
  DateTime? _lastTimeStamp;
  late Position _currentPosition;

  String usersId = "";

  double longitude() {
    return _currentPosition.longitude;
  }

  double latitude(){
    return _currentPosition.latitude;
  }

  bool isTimeOver() {
    if(!isInit) {
      return true;
    }

    final timegap = DateTime.now().difference(_lastTimeStamp!);
    bool cantExit = timegap >= const Duration(minutes: 3);
    return cantExit;
  }

  bool bWait = false;
  Future <void> updateGeolocator(bool bAct) async {

    if(bWait) {
      return;
    }

    bool flag = isTimeOver();

    if(bAct || flag) {
      bWait = true;
      notifyListeners();
      if(!await PermissionHandler.checkLocation()) {
        bWait = false;
        notifyListeners();
        return;
      }

      if (Platform.isIOS) {
        print("Platform is IOS >>> ");
        _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,//best,
            forceAndroidLocationManager: false,
            //timeLimit: Duration(seconds: 10)
        );
      }
      else{
        _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.reduced,//best,
            forceAndroidLocationManager: false,
            //timeLimit: Duration(seconds: 10)
        );
      }

      isInit = true;
      bWait = false;
      _lastTimeStamp = DateTime.now();
      isValid = true;
      notifyListeners();
    }
  }
}