// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String appName   = "부인암 생존자의 림프순환운동";
final String buildDate = DateTime.now().toString().substring(0,10);//"2023.03.17";

//di
// const String kakao_RestAppKey       = "77457cafbb88a36d303ac9de8aa62c0f";
// const String kakao_nativeAppKey     = '4e80cc28dd4efe6bffb6c844db6a51f6';
// const String kakao_javaScriptAppKey = 'b918ee254855f4a45c47dbb162f5add5';

const String kakao_RestAppKey       = "74cd49f0b3ecd9dcb2936e41fbc71fd0";
const String kakao_nativeAppKey     = '722afd009be805e3a0583e1dffab4248';
const String kakao_javaScriptAppKey = '005e7f1ac1088fb2f82b6885589eef84';
 //my test
 // const String kakao_nativeAppKey = "aa35f39b8e55b1266e72217dbcb6171d";
 // const String kakao_javaScriptAppKey = '2d50f62e4423d5eaece8e2c7942a2c0e';

// 개발PC
//-----------------------------------------------------------------
// const String IP     = "http://10.10.10.6:8080";
// const String HTTP   = "http://10.10.10.6:8080";
// const String HTTPS  = "http://10.10.10.6:8080";
// const String URL_IMAGE      = "http://211.175.164.221";

// 개발서버
//-----------------------------------------------------------------
// const String IP     = "http://211.175.164.221";
// const String HTTP   = "http://211.175.164.221";
// const String HTTPS  = "http://211.175.164.221";
// const String URL_IMAGE = "https://www.daejeoni.or.kr";

// 운용서버
//-----------------------------------------------------------
const String IP     = "http://114.108.134.94";
const String HTTP   = "http://www.daejeoni.or.kr";
const String HTTPS  = "https://www.daejeoni.or.kr";
const String URL_IMAGE = "https://www.daejeoni.or.kr";
//------------------------------------------------------------


const String SERVER         = HTTPS;
//const String URL_IMAGE      = "https://www.daejeoni.or.kr";
//const String URL_IMAGE      = "http://211.175.164.221";

const String URL_ROOT       = SERVER;
const String URL_HOME       = SERVER;
const String URL_API        = SERVER;
const String URL_NO_IMAGE   = "${URL_IMAGE}no-img.png";
//const String URL_MALL       = "https://smartstore.naver.com/bcfmall1/products";

const String URL_MakerSelect    =  "";
const String URL_MakerMap       =  "$URL_IMAGE/images/app/map_icon.png";
const String URL_MakerPrg       =  "$URL_IMAGE/images/app/program_icon.png"; // 프로그램
const String URL_MakerSos01     =  "$URL_IMAGE/images/app/sos_icon3.png"; // 병원
const String URL_MakerSos02     =  "$URL_IMAGE/images/app/sos_icon1.png"; // 약국
const String URL_MakerSos03     =  "$URL_IMAGE/images/app/sos_icon2.png"; // 기관

const String IMG_EMPTY = "assets/images/common_img.png";
const String IMG_SOS01 = "assets/images/hospital_img.png";
const String IMG_SOS02 = "assets/images/pharmacy_img.png";
const String IMG_SOS03 = "assets/images/agency_img.png";

const String USER_AGENT = "smartsn.daejeoni.or.kr";

const int STAGE_LIST = 0;
const int STAGE_MAP  = 1;

const Color ColorY0 = Color(0xFFFFFCF1);
const Color ColorB0 = Color(0xFF57ABFF);
const Color ColorB1 = Colors.blue;//Color(0xFF4C83B6);
const Color ColorB2 = Color(0xFF133D86);
const Color ColorB3 = Color(0xFF14327A);

const Color ColorG1 = Colors.grey;
const Color ColorG2 = Color(0xFFB1B2B9);
const Color ColorG3 = Color(0xFFC0C0C0);
const Color ColorG4 = Color(0xFFD0D0D0);
const Color ColorG5 = Color(0xFFE0E0E0);
const Color ColorG6 = Color(0xFFF0F0F0);
const Color ColorG9 = Color(0xFFFAFAFA);
// drawer Menu
const double CardItemIconSize = 15;
const double DrawerItemMenuIconSize = 18;
const double ItemMenuIconSize = 18;
const TextStyle ItemBkN11 = TextStyle(fontSize: 11, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.1, color: Colors.black, );

const TextStyle ItemBkN12 = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: Colors.black, );
const TextStyle ItemG1N12 = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: Colors.grey, );
const TextStyle ItemG1N24 = TextStyle(fontSize: 24, fontWeight: FontWeight.normal,   letterSpacing: -0.5, height: 1.0, color: Colors.grey, );
const TextStyle ItemG2N12 = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: ColorG2);

const TextStyle ItemBkB14 = TextStyle(fontSize: 14, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.2, color: Colors.black, );
const TextStyle ItemBkN14 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -1.2, height: 1.2, color: Colors.black, );
const TextStyle ItemB1B14 = TextStyle(fontSize: 14, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.2, color: ColorB1);
const TextStyle ItemB1N14 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: ColorB1);
const TextStyle ItemR1B14 = TextStyle(fontSize: 14, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.2, color: Colors.red,);
const TextStyle ItemG1N14 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: Colors.grey, );
const TextStyle ItemG2N14 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: ColorG2);

const TextStyle ItemBkB15 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold,   letterSpacing: -1.0, height: 1.2, color: Colors.black,);
const TextStyle ItemBkB12 = TextStyle(fontSize: 12, fontWeight: FontWeight.bold,   letterSpacing: -1.0, height: 1.2, color: Colors.black,);
const TextStyle ItemBkN15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.black, );
const TextStyle ItemB1N15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: ColorB1);
const TextStyle ItemR1B15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.red,);
const TextStyle ItemR1B12 = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.red,);
const TextStyle ItemG1N15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.grey,  );
const TextStyle ItemG2N15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.2, color: ColorG2);

const TextStyle ItemBkB16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold,   letterSpacing: -1.0, height: 1.2, color: Colors.black,);
const TextStyle ItemBkN16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.black, );
const TextStyle ItemBuN16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.blueAccent, );
const TextStyle ItemWkN16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.white, );
const TextStyle ItemB1N16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: ColorB1);
const TextStyle ItemG1N16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.2, color: Colors.grey, );
const TextStyle ItemR1B16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold,   letterSpacing: -1.0, height: 1.2, color: Colors.red, );

const TextStyle ItemBkB18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.1, color: Colors.black);
const TextStyle ItemBkN18 = TextStyle(fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.1, color: Colors.black);
const TextStyle ItemB1N18 = TextStyle(fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.1, color: ColorB1);
const TextStyle ItemB1B18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.1, color: ColorB1);
const TextStyle ItemG1N18 = TextStyle(fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.1, color: Colors.grey,  );
const TextStyle ItemG2B18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.1, color: ColorG2);

// dialog title, menu item
const TextStyle ItemBkB20 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.0, color: Colors.black, );
const TextStyle ItemBkN20 = TextStyle(fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.0, color: Colors.black, );
const TextStyle ItemB1N20 = TextStyle(fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: -0.5, height: 1.0, color: ColorB1);
const TextStyle ItemB1B20 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.0, color: ColorB1);
const TextStyle ItemBkB24 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 1.0, color: Colors.black, );

const TextStyle ContBkN15 = TextStyle(fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.4, color: Colors.black, );
const TextStyle ContBkN16 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -1.0, height: 1.4, color: Colors.black, );


const TextStyle ItemGrTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold,   letterSpacing: -0.5, height: 0.8, color: Colors.green, );

const BorderSide BSG5 = BorderSide(color: ColorG5, width: 1.0,);

const int moveMilisceond = 300;

double AxisExtentWidth  = 0;
double AxisExtentHeight = 0;
double AxisExtentRatio  = 0;
double mainAxisExtent   = 0;
double getMainAxis(BuildContext context) {
  return (MediaQuery.of(context).size.height/MediaQuery.of(context).size.width);
}

double getMainAxisExtent(BuildContext context) {
  AxisExtentWidth  = MediaQuery.of(context).size.width;
  AxisExtentHeight = MediaQuery.of(context).size.height;
  AxisExtentRatio = AxisExtentHeight / AxisExtentWidth;

  if (AxisExtentRatio < 1.18) {        // 캘럭시 플립 wide: 589 X 688
    mainAxisExtent = 410;//430;

  } else if (AxisExtentRatio < 1.51) { // tab: normal 1.5
    mainAxisExtent = 440;
  } else if (AxisExtentRatio < 1.54) { // tab: 685 X 1049
    mainAxisExtent = 440;
  } else if (AxisExtentRatio < 1.76) { // phone:
    mainAxisExtent = 440;
  } else if (AxisExtentRatio < 1.93) { // phone: 360 X 692
    mainAxisExtent = 340;
  } else if (AxisExtentRatio < 2.11) { // phone: 360x732, 384x805, 2.10:384X805
    mainAxisExtent = 330;//340;
  } else if (AxisExtentRatio < 2.17) { // ios: 360x732, 414 X 896
    mainAxisExtent = 380;
  } else if (AxisExtentRatio < 2.63) { // 캘럭시 플립 small: 320, 320 X 838
    mainAxisExtent = 360;//380;
  }else {
    mainAxisExtent = 380;
  }
  return mainAxisExtent;
}

String getMainAxisInfo(BuildContext context) {
  getMainAxisExtent(context);

  String info =
      " RT:${AxisExtentRatio.toStringAsFixed(2)},"
      " (${AxisExtentWidth.toInt()} x ${AxisExtentHeight.toInt()})";

  // if (kDebugMode) {
  //   print("------------------------------------------------------------------------------");
  //   print("AxisExtentWidth: $AxisExtentWidth");
  //   print("AxisExtentHeight: $AxisExtentHeight");
  //   print("AxisExtentRatio: $AxisExtentRatio");
  //   print("mainAxisExtent: $mainAxisExtent");
  //   print("------------------------------------------------------------------------------");
  //   print("Axis Info => $info");
  // }
  return info;
}


const double app_top_size_menu = 24;
const double app_top_size_back = 28;
const double app_top_size_close = 28;
const double app_top_size_refresh = 24;
const double app_top_size_bell = 22;
const double app_top_size_user = 16;

