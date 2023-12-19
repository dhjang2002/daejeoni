// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/menuButtonCheck.dart';
import 'package:daejeoni/common/searchForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final List<MenuButtonCheckItem> items;
  final double viewHeight;
  final Function(bool bDirty, String keyword, String idString) onClose;
  const _ContentView({
    Key? key,
    required this.items,
    required this.title,
    required this.viewHeight,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView> {
  String keyword = "";
  String mapCtgryCd = "";

  void setParamPrevious() {
    //_reqParam.setCategory(mapCtgryCd);
    mapCtgryCd = "";
    for (var element in widget.items) {
      if(element.select) {
        if(mapCtgryCd.isNotEmpty) {
          mapCtgryCd += ",";
        }
        mapCtgryCd += element.tag;
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
                            hintText: '검색어',
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
                                "체험 MAP",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        MenuButtonCheck(
                          items: widget.items,
                          childAspectRatio:2.0,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onAll: (MenuButtonCheckItem item ){
                            if(item.select) {
                              for (var element in widget.items) {
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
                        widget.onClose(true, keyword, mapCtgryCd);
                      }
                  ),
              ),
            ],
          )
      ),
    );
  }
}

Future<void> showSearchExp({
  required BuildContext context,
  required String title,
  required List<MenuButtonCheckItem> items,
  required Function(bool bDirty, String keyword, String idString) onResult}) {
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
            items: items,
            viewHeight:viewHeight,
            onClose: (bDirty, keyword, idString){
              onResult(bDirty, keyword, idString);
            },
          ),
        ),
      );
    },
  );
}