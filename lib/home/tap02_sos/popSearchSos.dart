// ignore_for_file: non_constant_identifier_names, file_names
import 'package:daejeoni/common/cardGCheck.dart';
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/common/searchForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final double viewHeight;
  final List<MenuButtonCheckItem> care_kind_items;
  final List<GCheckItem> sosOperPhTypes;
  final List<GCheckItem> sosOperHsTypes;
  final Function(bool bDirty, String keyword, String mapCtgryCd, String sosOperType) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.care_kind_items,
    required this.sosOperPhTypes,
    required this.sosOperHsTypes,
    required this.viewHeight,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView> {

  String keyword = "";
  String mapCtgryCd = "";
  String sosOperType = "";

  void setParamPrevious() {
    mapCtgryCd = "";
    for (var element in widget.care_kind_items) {
      if(element.select) {
        if(mapCtgryCd.isNotEmpty) {
          mapCtgryCd += ",";
        }
        mapCtgryCd += element.tag;
      }
    }

    sosOperType = "";
    for (var element in widget.sosOperPhTypes) {
      if(element.bSelect) {
        if (sosOperType.isNotEmpty) {
          sosOperType += ",";
        }
        sosOperType += element.tag;
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
        elevation: 0.1,
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
                top: 0, left: 0, right: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  height: widget.viewHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: SearchForm(
                            textInputAction:TextInputAction.done,
                            readOnly: false,
                            valueText: "",
                            suffixIcon: const Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                              size: 28,
                            ),
                            hintText: '기관명칭',
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
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                          child: const Row(
                            children: [
                              Text(
                                "기관선택",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          modeSelect: true,
                          items: widget.care_kind_items,
                          childAspectRatio:2.0,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item){
                            if(item.select) {
                              for (var element in widget.care_kind_items) {
                                if (!element.control) {
                                  element.select = false;
                                }
                              }
                            }
                          },
                          onChange: (List<MenuButtonCheckItem> items) {
                            mapCtgryCd = "";
                            bool checked = false;
                            for (var element in items) {
                              if(!element.control && element.select) {
                                checked = true;
                              }
                              if(!element.control && element.select) {
                                if(mapCtgryCd.isNotEmpty) {
                                  mapCtgryCd = "$mapCtgryCd,";
                                }
                                mapCtgryCd += element.tag.toString();
                              }
                            }
                            items[0].select = !checked;
                            setState(() {});
                          },
                        ),
                        Visibility(
                          visible: widget.care_kind_items[1].select,
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: CardGCheck(
                                tag: '',
                                isVertical: false,
                                isUseCode: true,
                                aList: widget.sosOperHsTypes,
                                initValue: '',
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                onSubmit: (String tag, String answerTag, String answerText) {
                                  sosOperType = answerTag;
                                },
                              ),
                            )
                        ),
                        Visibility(
                            visible: widget.care_kind_items[2].select,
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: CardGCheck(
                                tag: '',
                                isVertical: false,
                                isUseCode: true,
                                aList: widget.sosOperPhTypes,
                                initValue: '',
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                onSubmit: (String tag, String answerTag, String answerText) {
                                  sosOperType = answerTag;
                                },
                              ),
                            )
                        ),
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
                        widget.onClose(true, keyword, mapCtgryCd, sosOperType);
                      }
                  ),
              ),
            ],
          )
      ),
    );
  }
}

Future<void> showSearchSos({
  required BuildContext context,
  required String title,
  required List<MenuButtonCheckItem> care_kind_items,
  required List<GCheckItem> sosOperPhTypes,
  required List<GCheckItem> sosOperHsTypes,
  required Function(bool bDirty, String keyword, String mapCtgryCd, String sosOperType) onResult}) {
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
            care_kind_items: care_kind_items,
            sosOperPhTypes:sosOperPhTypes,
            sosOperHsTypes:sosOperHsTypes,
            viewHeight:viewHeight,
            onClose: (bDirty, keyword, mapCtgryCd, sosOperType){
              onResult(bDirty, keyword, mapCtgryCd, sosOperType);
            },
          ),
        ),
      );
    },
  );
}