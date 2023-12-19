import 'package:daejeoni/provider/sessionData.dart';

class RequestParam {
  int page;
  int countPerPage;
  double? longitude;
  double? latitude;
  String mapCtgryCd;
  String area;
  String searchKeyword;
  String mapTy;
  String order;
  String orderDir;
  String upperInsttSn1;  // 운영형태1
  String upperInsttSn2;  // 운영형태2
  String insttAgeType;   // 나이

  String insttSgg;       // 지역

  String upperInsttSnInfo;
  String insttAgeTypeInfo;   // 나이
  String insttSggInfo;

  // 프로그램 검색
  String strState;
  String prgType;
  String prgTypeInfo;
  String strDateBegin;
  String strDateEnd;

  String sosOperType; // 의료기관 구분 병원:1. 약국:2. 의료기관:3

  String avaHoliday;  // 공유일 운영여부(Y)
  String avaNight;    // 야간 운영여부(Y)

  String mapCtgryCdInfo;

  String ctgryCd;     // 양육정보 카테고리
  String ctgryCdInfo;
  late SessionData session;

  String orderValue;
  String orderDesc;
  List<String> orderList = <String>[
    "이름순",
    "거리순",
  ];

  RequestParam({
    this.ctgryCd = "",
    this.ctgryCdInfo = "",
    this.upperInsttSnInfo="",
    this.mapCtgryCdInfo="",
    this.insttAgeTypeInfo = "",
    this.insttSggInfo = "",

    this.avaHoliday = "",
    this.avaNight="",
    this.sosOperType="",
    this.insttAgeType = "",
    this.upperInsttSn1 = "",
    this.upperInsttSn2 = "",
    this.insttSgg = "",
    this.longitude,
    this.latitude,
    this.page = 1,
    this.countPerPage = 8,
    this.mapCtgryCd = "",
    this.area = "30",
    this.searchKeyword = "",
    this.mapTy= "",
    this.orderValue = "이름순",
    this.orderDesc  = "기관/행사 명칭 순서로 표시",
    this.order = "MAPTITLE",
    this.orderDir = "asc",

    this.strState = "",
    this.prgType = "",
    this.prgTypeInfo = "",
    this.strDateBegin = "",
    this.strDateEnd = "",
  });

  void setOrderList(String listData, String value) {
    var list = listData.split(",");
    orderList.clear();
    list.forEach((element) {
      orderList.add(element);
    });
    setOrder(value);
  }

  void setPageToCount(int count) {
    countPerPage = count;
  }

  void setOrder(String value) {
    orderValue = value;
    //print("setOrder():orderby=$orderValue");
    switch(orderValue) {
      case "이름순":
        order = "MAPTITLE";
        orderDir = "asc";
        orderDesc  = "기관/행사 명칭 순서로 표시";
        break;
      case "거리순":
        order = "MYDSTNC";
        orderDir = "asc";
        orderDesc  = "거리 순서로 표시";
        break;
      case "최신순":
        order = "MAPDATE";
        orderDir = "desc";
        orderDesc  = "최신 자료 순서로 표시";
        break;
      default:
        order = "MAPTITLE";
        orderDir = "asc";
        orderDesc  = "기관/행사 명칭 순서로 표시";
    }
  }

  @override
  String toString(){
    return 'RequestParam {'
        'page:$page, '
        'countPerPage:$countPerPage, '
        'mapCtgryCd:$mapCtgryCd, '
        'order:$order, '
        '}';
  }

  void setSession(SessionData session) {
    this.session = session;
  }

  void setLocation(double lng, double lat) {
    longitude = lng;
    latitude = lat;
  }

  void setCategory(String code) {
    mapCtgryCd = code;
  }

  void setKeyword(String word) {
    searchKeyword = word;
  }

  void setMapType(String type) {
    mapTy = type;
  }

  // Map<String, dynamic> toRequest({String keyword="request"}) {
  //   return toMap();
  // }

  String getInfo() {
    String value = "";
    String result = "";

    switch(mapTy) {
      case "SOS":
      {
          if (mapCtgryCdInfo.isNotEmpty) {
            value = mapCtgryCdInfo.replaceAll("전체", "전체기관");
            result += "[$value] ";
          }

          if (avaHoliday == "Y") {
            result += " [공휴일]";
          }
          if (avaNight == "Y") {
            if (mapCtgryCd == "1") {
              result += " [야간진료]";
            }
            if (mapCtgryCd == "2") {
              result += " [야간운영]";
            }
          }
          break;
      }
      case "MAP": {
        // 체험
        if(mapCtgryCdInfo.isNotEmpty) {
          result += "[$mapCtgryCdInfo] ";
          result = result.replaceAll("전체", "전체 MAP");
        }
        break;
      }
      case "INS": {
        if(insttSggInfo.isNotEmpty) {
          value = insttSggInfo.replaceAll("전체", "지역전체");
          result += "[$value] ";
        }

        // 돌봄기관
        if(insttAgeTypeInfo.isNotEmpty) {
          value = insttAgeTypeInfo.replaceAll("전체", "모든연령");
          result += "[$value] ";
        }

        if(upperInsttSnInfo.isNotEmpty) {
          value = upperInsttSnInfo.replaceAll("전체", "전체기관");
          result += "[$value] ";
          //result += "[$upperInsttSnInfo] ";
        }

        break;
      }
      case "CAR": {
        value  = ctgryCdInfo;
        result = "[$value] ";
        break;
      }
      case "SPA": {
        value = "모든공간";
        result = "[$value] ";
        break;
      }
      case "PRG": {
        if(prgTypeInfo.isNotEmpty) {
          value = prgTypeInfo.replaceAll("전체", "모든행사");
          result += "[$value] ";
        }
        if(insttSggInfo.isNotEmpty) {
          value = insttSggInfo.replaceAll("전체", "지역전체");
          result += "[$value] ";
        }
        break;
      }
      default:
        value = "알수없음";
        result = "[$value] ";
        break;
    }

    if(searchKeyword.isNotEmpty)
    {
      result += ' 키워드: "$searchKeyword"';
    } else {
      result += ' 키워드: ';
    }

    return result;
  }

  /*
  "avaHoliday": "Y" (약국 공휴일 여부)
  "avaNight": "Y" (약국, 병원 야간 여부)
   */

  Map<String, dynamic> getInsParamAll(int count, String area) {
    Map<String, dynamic> param = {
      'page': 1,
      'countPerPage': count
    };

    if(longitude != null) {
      param.addAll({'gpsLcLng': longitude});
    }

    if(latitude != null) {
      param.addAll({'gpsLcLat': latitude});
    }

    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }

    if(mapTy.isNotEmpty) {
      param.addAll({'mapTy': mapTy});
    }

    //if(mapCtgryCd.isNotEmpty)
        {
      param.addAll({'mapCtgryCd': mapCtgryCd});
    }

    if(area.isNotEmpty) {
      param.addAll({'area': area});
    }

    if(insttAgeType.isNotEmpty) {
      param.addAll({'insttAgeType': insttAgeType});
    }

    if(upperInsttSn1.isNotEmpty) {
      param.addAll({'upperInsttSn1': upperInsttSn1});
    }
    if(upperInsttSn2.isNotEmpty) {
      param.addAll({'upperInsttSn2': upperInsttSn2});
    }
    if(insttSgg.isNotEmpty) {
      param.addAll({'insttSgg': insttSgg});
    }
    if(sosOperType.isNotEmpty) {
      param.addAll({'sosOperType': sosOperType});
    }

    if(avaHoliday.isNotEmpty) {
      param.addAll({'avaHoliday': avaHoliday});
    }
    if(avaNight.isNotEmpty) {
      param.addAll({'avaNight': avaNight});
    }
    return param;
  }
  Map<String, dynamic> getExpParamAll(int count, String area) {
    Map<String, dynamic> param = {
      'page': 1,
      'countPerPage': count
    };

    if(longitude != null) {
      param.addAll({'gpsLcLng': longitude});
    }

    if(latitude != null) {
      param.addAll({'gpsLcLat': latitude});
    }

    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }

    if(mapTy.isNotEmpty) {
      param.addAll({'mapTy': mapTy});
    }

    //if(mapCtgryCd.isNotEmpty)
        {
      param.addAll({'mapCtgryCd': mapCtgryCd});
    }

    if(area.isNotEmpty) {
      param.addAll({'area': area});
    }

    if(insttAgeType.isNotEmpty) {
      param.addAll({'insttAgeType': insttAgeType});
    }

    if(upperInsttSn1.isNotEmpty) {
      param.addAll({'upperInsttSn1': upperInsttSn1});
    }
    if(upperInsttSn2.isNotEmpty) {
      param.addAll({'upperInsttSn2': upperInsttSn2});
    }
    if(insttSgg.isNotEmpty) {
      param.addAll({'insttSgg': insttSgg});
    }
    if(sosOperType.isNotEmpty) {
      param.addAll({'sosOperType': sosOperType});
    }

    if(avaHoliday.isNotEmpty) {
      param.addAll({'avaHoliday': avaHoliday});
    }
    if(avaNight.isNotEmpty) {
      param.addAll({'avaNight': avaNight});
    }
    return param;
  }

  Map<String, dynamic> getSosParamAll(int count, String area) {
    Map<String, dynamic> param = {
      'page': 1,
      'countPerPage': count
    };

    if(longitude != null) {
      param.addAll({'gpsLcLng': longitude});
    }

    if(latitude != null) {
      param.addAll({'gpsLcLat': latitude});
    }

    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }

    if(mapTy.isNotEmpty) {
      param.addAll({'mapTy': mapTy});
    }

    //if(mapCtgryCd.isNotEmpty)
        {
      param.addAll({'mapCtgryCd': mapCtgryCd});
    }

    if(area.isNotEmpty) {
      param.addAll({'area': area});
    }

    if(insttAgeType.isNotEmpty) {
      param.addAll({'insttAgeType': insttAgeType});
    }

    if(upperInsttSn1.isNotEmpty) {
      param.addAll({'upperInsttSn1': upperInsttSn1});
    }
    if(upperInsttSn2.isNotEmpty) {
      param.addAll({'upperInsttSn2': upperInsttSn2});
    }
    if(insttSgg.isNotEmpty) {
      param.addAll({'insttSgg': insttSgg});
    }
    if(sosOperType.isNotEmpty) {
      param.addAll({'sosOperType': sosOperType});
    }

    if(avaHoliday.isNotEmpty) {
      param.addAll({'avaHoliday': avaHoliday});
    }
    if(avaNight.isNotEmpty) {
      param.addAll({'avaNight': avaNight});
    }
    return param;
  }



  Map<String, dynamic> getMapParam() {
    Map<String, dynamic> map = {
      'page': page,
      'countPerPage': countPerPage
    };

    if(longitude != null) {
      map.addAll({'gpsLcLng': longitude});
    }
    if(latitude != null) {
      map.addAll({'gpsLcLat': latitude});
    }
    if(searchKeyword.isNotEmpty) {
      map.addAll({'searchKeyword': searchKeyword});
    }
    if(mapTy.isNotEmpty) {
      map.addAll({'mapTy': mapTy});
    }
    //if(mapCtgryCd.isNotEmpty)
        {
      map.addAll({'mapCtgryCd': mapCtgryCd});
    }
    if(area.isNotEmpty) {
      map.addAll({'area': area});
    }
    if(order.isNotEmpty) {
      map.addAll({'orderBy': order});
    }

    if(insttAgeType.isNotEmpty) {
      map.addAll({'insttAgeType': insttAgeType});
    }

    if(upperInsttSn1.isNotEmpty) {
      map.addAll({'upperInsttSn1': upperInsttSn1});
    }
    if(upperInsttSn2.isNotEmpty) {
      map.addAll({'upperInsttSn2': upperInsttSn2});
    }

    if(insttSgg.isNotEmpty) {
      map.addAll({'insttSgg': insttSgg});
    }

    if(avaHoliday.isNotEmpty) {
      map.addAll({'avaHoliday': avaHoliday});
    }
    if(avaNight.isNotEmpty) {
      map.addAll({'avaNight': avaNight});
    }
    return map;
  }

  Map<String, dynamic> getPrgParam() {
    Map<String, dynamic> param = {
      'page': page,
      'countPerPage': countPerPage,
      'area': '',
      'guCode':insttSgg,
    };

    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }

    //if(strState.isNotEmpty) {
      param.addAll({'eduProgrsSt': strState});
    //}

    //if(strType.isNotEmpty) {
      param.addAll({'eduTy': prgType});
    //}

    if(strDateBegin.isNotEmpty) {
      param.addAll({'searchStrDate': strDateBegin});
    }
    if(strDateEnd.isNotEmpty) {
      param.addAll({'searchEndDate': strDateEnd});
    }

    if(longitude != null && latitude != null) {
      param.addAll({'gpsLcLng': latitude});
      param.addAll({'gpsLcLat': longitude});
    }

    if(order.isNotEmpty) {
      param.addAll({'orderBy': order});
    }

    return param;
  }

  Map<String, dynamic> getPrgParamAll(int count, int area) {
    Map<String, dynamic> param = {
      'page': 1,
      'countPerPage': count,
      'area': area,
      'guCode':insttSgg,
    };

    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }

    //if(strState.isNotEmpty) {
      param.addAll({'eduProgrsSt': strState});
    //}

    //if(strType.isNotEmpty) {
      param.addAll({'eduTy': prgType});
    //}

    if(strDateBegin.isNotEmpty) {
      param.addAll({'searchStrDate': strDateBegin});
    }
    if(strDateEnd.isNotEmpty) {
      param.addAll({'searchEndDate': strDateEnd});
    }

    if(longitude != null && latitude != null) {
      param.addAll({'gpsLcLng': latitude});
      param.addAll({'gpsLcLat': longitude});
    }

    if(order.isNotEmpty) {
      param.addAll({'orderBy': order});
    }

    return param;
  }
  // {
  // "page" : 1,
  // "countPerPage": 2,
  // "board_id": "board011",
  // "ctgryCd": "cardNews"
  // }

  Map<String, dynamic> getCareParam() {
    Map<String, dynamic> param = {
      'page': page,
      'countPerPage': countPerPage,
      'board_id':'board011'
    };
    if(searchKeyword.isNotEmpty) {
      param.addAll({'searchKeyword': searchKeyword});
    }
    param.addAll({'ctgryCd': ctgryCd});
    return param;
  }



}
