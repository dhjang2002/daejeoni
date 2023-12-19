// ignore_for_file: non_constant_identifier_names, file_names
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/common/searchForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final List<MenuButtonCheckItem> items_age;
  final List<MenuButtonCheckItem> items_area;
  final List<MenuButtonCheckItem> items_typeDir;
  final List<MenuButtonCheckItem> items_typeLink;
  final double viewHeight;
  final Function(bool bDirty, String keyword, String agString, String arString, String tdString, String tlString) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.items_age,
    required this.items_area,
    required this.items_typeDir,
    required this.items_typeLink,
    required this.viewHeight,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView> {

  String keyword = "";
  String insttAgeType = "";
  String insttSgg = "";
  String upperInsttSn1 = "";
  String upperInsttSn2 = "";

  void setParamPrevious() {
    keyword = "";

    insttAgeType = "";
    for (var element in widget.items_age) {
      if(element.select) {
        if(insttAgeType.isNotEmpty) {
          insttAgeType += ",";
        }
        insttAgeType += element.tag;
      }
    }


    insttSgg = "";
    for (var element in widget.items_area) {
      if(element.select) {
        if(insttSgg.isNotEmpty) {
          insttSgg += ",";
        }
        insttSgg += element.tag;
      }
    }

    upperInsttSn1 = "";
    for (var element in widget.items_typeDir) {
      if(element.select) {
        if(upperInsttSn1.isNotEmpty) {
          upperInsttSn1 += ",";
        }
        upperInsttSn1 += element.tag;
      }
    }

    upperInsttSn2 = "";
    for (var element in widget.items_typeLink) {
      if(element.select) {
        if(upperInsttSn2.isNotEmpty) {
          upperInsttSn2 += ",";
        }
        upperInsttSn2 += element.tag;
      }
    }
  }

  @override
  void initState() {
    setParamPrevious();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorGrayBack,
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: _colorGrayBack,
        title: Text(widget.title),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),

      body: Container(
          color: Colors.white,
          child:Stack(
            children: [
              Positioned(
                top: 0, left: 0, right: 0, bottom: 80,
                child: SizedBox(
                  //margin: const EdgeInsets.only(bottom: 100),
                  height: widget.viewHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SearchForm(
                            textInputAction:TextInputAction.done,
                            readOnly: false,
                            valueText: "",
                            suffixIcon: const Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                              size: 28,
                            ),
                            hintText: '돌봄센터',
                            onCreated: (TextEditingController controller) {
                              //_findValue_controller = controller;
                            },
                            onChange: (String value) {
                              keyword = value.trim();
                            },
                            onSummit: (String value) {
                              keyword = value.trim();
                            },
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: const Row(
                            children: [
                              Text(
                                "돌봄기관",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " - 연령선택(중복가능)",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          items: widget.items_age,
                          childAspectRatio:1.9,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item) {
                            if(item.select) {
                              for (var element in widget.items_age) {
                                if (!element.control) {
                                  element.select = false;
                                }
                              }
                            }
                          },
                          onChange: (List<MenuButtonCheckItem> items) {
                            insttAgeType = "";
                            bool checked = false;
                            for (var element in items) {
                              if(!element.control && element.select) {
                                checked = true;
                              }
                              if(element.select) {
                                if(insttAgeType.isNotEmpty) {
                                  insttAgeType = "$insttAgeType,";
                                }
                                insttAgeType += element.tag.toString();
                                //break;
                              }
                            }

                            items[0].select = !checked;
                            setState(() {});
                          },
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: const Row(
                            children: [
                              Text(
                                "우리지역",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " - 지역선택(중복가능)",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          items: widget.items_area,
                          childAspectRatio:1.9,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item) {
                            if(item.select) {
                              for (var element in widget.items_area) {
                                if (!element.control) {
                                  element.select = false;
                                }
                              }
                            }
                          },
                          onChange: (List<MenuButtonCheckItem> items) {
                            insttSgg = "";
                            bool checked = false;
                            for (var element in items) {
                              if(!element.control && element.select) {
                                checked = true;
                              }
                              if(element.select) {
                                if(insttSgg.isNotEmpty) {
                                  insttSgg = "$insttSgg,";
                                }
                                insttSgg += element.tag.toString();
                                //break;
                              }
                            }

                            items[0].select = !checked;
                            setState(() {});
                          },
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: const Row(
                            children: [
                              Text(
                                "돌봄시설",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " - 분류선택(중복가능)",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: const Row(
                            children: [
                              Text(
                                "- 예약신청형",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          items: widget.items_typeDir,
                          childAspectRatio:1.9,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item){
                            if(item.select) {
                              for (var element in widget.items_typeDir) {
                                if(!element.control) {
                                  element.select = false;
                                }
                              }
                              for (var element in widget.items_typeLink) {
                                element.select = false;
                              }
                            }
                          },
                          onChange: (List<MenuButtonCheckItem> items) {
                            //bSelect = false;
                            upperInsttSn1 = "";
                            for (var element in items) {
                              if(element.select) {
                                if(upperInsttSn1.isNotEmpty) {
                                  upperInsttSn1 = "$upperInsttSn1,";
                                }
                                upperInsttSn1 += element.tag.toString();
                                //break;
                              }
                            }

                            widget.items_typeDir[0].select = !getServiceCheck();
                            setState(() {});
                          },
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: const Row(
                            children: [
                              Text(
                                "- 홈페이지 연결형",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          items: widget.items_typeLink,
                          childAspectRatio:1.9,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item){},
                          onChange: (List<MenuButtonCheckItem> items) {
                            upperInsttSn2 = "";
                            for (var element in items) {
                              if(!element.control && element.select) {
                                if(upperInsttSn2.isNotEmpty) {
                                  upperInsttSn2 = "$upperInsttSn2,";
                                }
                                upperInsttSn2 += element.tag.toString();
                              }
                            }

                            widget.items_typeDir[0].select = !getServiceCheck();

                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                  bottom: 0,left: 0, right: 0,
                  child:ButtonSingle(
                      visible: true,
                      isBottomPading: true,
                      text: "검색하기",
                      enable: true,
                      onClick: () {
                        Navigator.pop(context);
                        widget.onClose(true, keyword, insttAgeType, insttSgg, upperInsttSn1, upperInsttSn2);
                      }
                  ),
              ),
            ],
          )
      ),
    );
  }

  bool getServiceCheck() {
    for (var element in widget.items_typeDir) {
      if(!element.control && element.select) {
        return true;
      }
    }
    for (var element in widget.items_typeLink) {
      if(!element.control && element.select) {
        return true;
      }
    }
    return false;
  }
}



Future <void> showSearchHouse({
  required BuildContext context,
  required String title,
  required List<MenuButtonCheckItem> items_age,
  required List<MenuButtonCheckItem> items_area,
  required List<MenuButtonCheckItem> items_typeDir,
  required List<MenuButtonCheckItem> items_typeLink,
  required Function(bool bDirty, String keyword, String agString, String arString, String tdString, String tlString) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.9;
  return showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    useRootNavigator: false,
    isDismissible: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: SizedBox(
          height: viewHeight,
          child: _ContentView(
            title: title,
            items_age: items_age,
            items_area: items_area,
            items_typeDir: items_typeDir,
            items_typeLink: items_typeLink,
            viewHeight:viewHeight,
            onClose: (bDirty, keyword, agString, arString, tdString, tlString){
              onResult(bDirty, keyword, agString, arString, tdString, tlString);
            },
          ),
        ),
      );
    },
  );
}