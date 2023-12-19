
import 'dart:convert';

import 'package:daejeoni/cache/cacheBoardList.dart';
import 'package:daejeoni/cache/cacheInsList.dart';
import 'package:daejeoni/cache/cacheCareList.dart';
import 'package:daejeoni/cache/cacheNoticeList.dart';
import 'package:daejeoni/cache/cacheProgramList.dart';
import 'package:daejeoni/cache/cacheSpaceList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:daejeoni/cache/cacheMapList.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/firebase_options.dart';
import 'package:daejeoni/home/mainHome.dart';
import 'package:daejeoni/provider/sessionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'provider/gpsStatus.dart';
import "package:hex/hex.dart";

Future <void> _onBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("_onBackgroundHandler() -----------------> ");
  }
  if(message.notification != null) {
    String action = "";
    if(message.data["action"] != null) {
      action = message.data["action"];
    }

    if (kDebugMode) {
      print("title=${message.notification!.title.toString()},\n"
          "body=${message.notification!.body.toString()},\n"
          "action=$action");
    }

    // if(message.notification?.android != null) {
    //   notification.show(
    //       title:message.notification!.title.toString(),
    //       body:message.notification!.body.toString(),
    //       action: "_onBackgroundHandler"
    //
    //   );
    // }


  }
}


void showKeyHash() {
  // SHA-1 인증서 지문
  //String sha1Fingerprint = "A1:F4:28:3F:12:6B:ED:65:A3:A6:6A:F4:6A:BC:BF:A1:E8:3B:B0:D0";
  String sha1Fingerprint = "A1:F4:28:3F:12:6B:ED:65:A3:A6:6A:F4:6A:BC:BF:A1:E8:3B:B0:D0";

  // 콜론(:)을 제거하고 공백을 제외한 문자열로 변환
  String sha1FingerprintWithoutColon = sha1Fingerprint.replaceAll(":", "");

  // Base64 인코딩
  String base64EncodedFingerprint = base64.encode(HEX.decode(sha1FingerprintWithoutColon));

  // 인코딩된 값을 출력
  print(base64EncodedFingerprint);
}

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AuthRepository.initialize(appKey: kakao_javaScriptAppKey);
  KakaoSdk.init(nativeAppKey: kakao_nativeAppKey, javaScriptAppKey: kakao_javaScriptAppKey);

  if (kDebugMode) {
    showKeyHash();
  }

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GpsStatus()),
        ChangeNotifierProvider(create: (_) => SessionData()),
        ChangeNotifierProvider(create: (_) => CacheMapList()),
        ChangeNotifierProvider(create: (_) => CacheInsList()),
        ChangeNotifierProvider(create: (_) => CacheBoardList()),
        ChangeNotifierProvider(create: (_) => CacheNoticeList()),
        ChangeNotifierProvider(create: (_) => CacheProgramList()),
        ChangeNotifierProvider(create: (_) => CacheCareList()),
        ChangeNotifierProvider(create: (_) => CacheSpaceList()),
      ],
      child: const AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness:Brightness.dark,
          statusBarIconBrightness:Brightness.dark,
          systemNavigationBarColor: Colors.grey[100],
          systemNavigationBarIconBrightness:Brightness.dark,
        )
    );

    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ko', 'KR'),
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.1,
            ),
            child: child!,
          ),

          title: appName,
          theme: ThemeData(
            //fontFamily: 'Nanum_Gothic',
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                elevation: 0.0,
                titleTextStyle: TextStyle(fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.normal)
            ),
            scaffoldBackgroundColor:Colors.white,
            primaryColor: Colors.red, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(background: Colors.white),
          ),

          initialRoute: '/',
          routes: {
            "/"  : (_) => const MainHome(),
            //"/home"  : (_) => const MainHome(),
          },
        );
      },
    );
  }
}
