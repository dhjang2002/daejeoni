// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DateForm{
  late String   timeString;
  late DateTime timeStamp;

  DateForm() {
    timeStamp  = DateTime.now();
    timeString = DateFormat('yyyy.MM.dd hh:mm:ss a').format(timeStamp);
  }

  DateForm set(DateTime stamp) {
    timeStamp = stamp;
    return this;
  }

  DateForm parse(String stampString) {
    timeString = stampString;
    //print("$timeString");
    timeStamp = DateTime.parse(timeString.trim());
    return this;
  }

  String getStamp() {
    return timeString;
  }

  String getWeek() {
    String value = DateFormat('EE').format(timeStamp);
    switch(value) {
      case 'Mon': return "월";
      case 'Tue': return "화";
      case 'Wed': return "수";
      case 'Thu': return "목";
      case 'Fri': return "금";
      case 'Sat': return "토";
      case 'Sun': return "일";
    }
    return "?";
  }

  String getMonth() {
    return DateFormat('M').format(timeStamp);
  }

  String getDate() {
    return DateFormat('yyyy.MM.dd').format(timeStamp);
  }

  String getMonthDate() {
    return DateFormat('MM.dd').format(timeStamp);
  }

  String getTime() {
    return DateFormat('HH:mm a').format(timeStamp);
  }

  String getVisitDay() {
    return "${getDate()} (${getWeek()}) ${getTime()}";
  }

  int passInHour() {
      return DateTime.now().difference(timeStamp).inHours;
  }

  String chatStamp() {

    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days:1));
    Duration diff  = today.difference(timeStamp);
    if(diff.inDays<2) {
      if (today.day == timeStamp.day) {
        return DateFormat('오늘\nHH:mm a').format(timeStamp);
      }
      if (yesterday.day == timeStamp.day) {
        return "어제\n${DateFormat('HH:mm a').format(timeStamp)}";
      }
    }

    return "${DateFormat('yyyy.MM.dd').format(timeStamp)}\n${DateFormat('HH:mm a').format(timeStamp)}";
  }

  static String showStamp(DateTime? timeStamp) {
    if(timeStamp==null) {
      return "yyyy.MM.dd hh:mm:ss a";
    }
    return DateFormat('yyyy.MM.dd hh:mm:ss a').format(timeStamp);
  }

  static String getKorWeek(String value) {
    switch(value) {
      case 'Mon': return "월";
      case 'Tue': return "화";
      case 'Wed': return "수";
      case 'Thu': return "목";
      case 'Fri': return "금";
      case 'Sat': return "토";
      case 'Sun': return "일";
    }
    return "?";
  }

  static int getDDay(String dateString) {
    var td = DateTime.now();
    var today  = DateTime.utc(td.year, td.month, td.day);
    if (dateString.length >= 8) {
      var day  = DateFormat('yyyy.M.d').parse(dateString);
      var eday = DateTime.utc(day.year, day.month, day.day);
      var diff = eday.difference(today).inDays;
      return diff;
    }
    return 365;
  }


  static String getTimeStampWithMin(DateTime day) {
    return DateFormat('hh:mm').format(day);
  }

  static String getDayStampWithDay(DateTime day) {
    return DateFormat('yyyy.MM.dd').format(day);
  }

  static String getDayStampWithTime(DateTime day) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(day);
  }

  static String getDayStampHourMin(DateTime day) {
    return "${DateFormat('yyyy.MM.dd').format(day)} ${getHourMin(day)}";
  }

  static String getDayStampHourMinWithWeek(DateTime day) {
    return "${DateFormat('yyyy.MM.dd').format(day)} (${getKorWeek(DateFormat('EE').format(day))}) ${getHourMin(day)}";
  }

  static DateTime setTime(int hour, int min, int sec) {
    DateTime now = DateTime.now();
    return DateTime.utc(
        now.year, now.month, now.day,
        hour, min, sec);
  }

  static DateTime makeTime(String timeText) {
    DateTime now = DateTime.now();
    if(timeText.length==5) {
      String hh = timeText.substring(0, 2);
      String mm = timeText.substring(3, 5);
      now = DateTime.utc(
          now.year, now.month, now.day,
          int.parse(hh).toInt(),
          int.parse(mm).toInt());
    }
    return now;
  }

  static DateTime makeDateTime(String dateString, String timeText) {
    DateTime dateTime = DateFormat('yyyy.M.d').parse(dateString);
    if(timeText.length==5) {
      String hh = timeText.substring(0, 2);
      String mm = timeText.substring(3, 5);
      return DateTime.utc(
          dateTime.year, dateTime.month, dateTime.day,
          int.parse(hh).toInt(),
          int.parse(mm).toInt()
      );
    }
    return dateTime;
  }

  static DateTime makeStamp(String dateString) {
     if(dateString.split(":").length<3) {
       dateString += ":00:00:00";
     }
    return DateFormat('yyyy.MM.dd hh:mm:ss').parse(dateString);
  }

  static String getYDayStamp(String dateString) {
    if(dateString.length<10) {
      return "";
    }
    DateTime dateStamp = DateFormat('yyyy.M.d').parse(dateString);
    return "${DateFormat('yyyy.MM.dd').format(dateStamp)} (${getKorWeek(DateFormat('EE').format(dateStamp))})";
  }

  static String getDateStamp(DateTime dateStamp) {
    return "${DateFormat('yyyy.MM.dd').format(dateStamp)} (${getKorWeek(DateFormat('EE').format(dateStamp))})";
  }

  static String getHourMin(DateTime dateStamp) {
    String hourMin = "${dateStamp.hour.toString().padLeft(2, '0')}"
        ":${dateStamp.minute.toString().padLeft(2, '0')}";
    return hourMin;
  }

  static String getMDayStamp(String dateString) {
    if(dateString.length<10) {
      return "";
    }

    DateTime dateStamp = DateFormat('yyyy.M.d').parse(dateString);
    return "${DateFormat('MM.dd').format(dateStamp)} (${getKorWeek(DateFormat('EE').format(dateStamp))})";
  }

  static String getRangeDate(String startString, String endString) {
    if(startString==null || startString.length<1 || endString==null || endString.length<1)
      return "";

    DateTime startStamp = DateFormat('yyyy.MM.dd').parse(startString);
    DateTime endStamp = DateFormat('yyyy.MM.dd').parse(endString);

    String yy1 = DateFormat('yyyy').format(startStamp);
    String yy2 = DateFormat('yyyy').format(endStamp);
    String mm2 = DateFormat('MM').format(endStamp);
    String dd2 = DateFormat('dd').format(endStamp);

    String dayStart = DateFormat('yyyy.MM.dd').format(startStamp);
    if (kDebugMode) {
      print("${DateFormat('yyyy.MM.dd').format(startStamp)} ~ ${DateFormat('yyyy.MM.dd').format(endStamp)}");
    }
    String dayEnd = "";
    if(yy1 != yy2) {
      dayEnd += "$yy2.";
    }

    dayEnd += "$mm2.";
    dayEnd += dd2;
    return "$dayStart ~ $dayEnd";
  }

  static String getRangeStamp(DateTime startStamp, DateTime endStamp) {
    String yy1 = DateFormat('yyyy').format(startStamp);
    String yy2 = DateFormat('yyyy').format(endStamp);
    String mm2 = DateFormat('MM').format(endStamp);
    String dd2 = DateFormat('dd').format(endStamp);

    String dayStart = DateFormat('yyyy.MM.dd').format(startStamp);
    if (kDebugMode) {
      print("${DateFormat('yyyy.MM.dd').format(startStamp)} ~ ${DateFormat('yyyy.MM.dd').format(endStamp)}");
    }
    String dayEnd = "";
    if(yy1 != yy2) {
      dayEnd += "$yy2.";
    }

    dayEnd += "$mm2.";
    dayEnd += dd2;
    return "$dayStart ~ $dayEnd";
  }
}