// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/InputForm.dart';
import 'package:daejeoni/common/menuButtonRadio.dart';
import 'package:daejeoni/common/searchForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

const Color _colorGrayBack = Color(0xFFF4F4F4);

class _ContentView extends StatefulWidget {
  final String title;
  final double viewHeight;
  final List<MenuButtonRadioItem> items_type;
  final Function(bool bDirty, String keyword, String strState, String strType, String strDateBegin, String strDateEnd) onClose;
  const _ContentView({
    Key? key,
    required this.items_type,
    required this.title,
    required this.viewHeight,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {

  // 교육진행상태(0또는빈:전체,1:접수예정,2접수중) - 검색용
  // List<MenuButtonRadioItem> items_state = [
  //   MenuButtonRadioItem(text: "전체",    id:"", select: true),
  //   MenuButtonRadioItem(text: "접수예정", id:"1", select: false),
  //   MenuButtonRadioItem(text: "접수중",   id:"2", select: false),
  // ];
  // PROGRM001 : 프로그램, 003 : 양성과정, 004: 손오공 돌봄공동체, 005: 부모상담, 006: 공동육아나눔터, 007 : 돌봄봉사단, 008 : 설문조사


  //bool bSelect = false;
  String keyword = "";
  String strState = "";
  String strType = "";
  String strDateBegin = "";
  String strDateEnd = "";

  @override
  void initState() {
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
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: const Row(
                            children: [
                              Text(
                                "검색어",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SearchForm(
                            readOnly: false,
                            valueText: "",
                            suffixIcon: const Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                              size: 28,
                            ),
                            hintText: '제목/내용',
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

                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                        //   child: const Row(
                        //     children: [
                        //       Text(
                        //         "상태",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // MenuButtonRadio(
                        //   margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        //   btnColor: Colors.white,
                        //   items: items_state,
                        //   onChange: (List<MenuButtonRadioItem> items) {
                        //     strState = "";
                        //     for (var element in items) {
                        //       if(element.select) {
                        //         strState += element.id.toString();
                        //         break;
                        //       }
                        //     }
                        //     //setState(() {});
                        //   },
                        // ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                          child: const Row(
                            children: [
                              Text(
                                "유형",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MenuButtonRadio(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          items: widget.items_type,
                          childAspectRatio:1.9,
                          btnColor:Colors.blueAccent,
                          borderColor:Colors.blueAccent,
                          textSelColor:Colors.white,
                          onChange: (List<MenuButtonRadioItem> items) {
                            strType = "";
                            for (var element in items) {
                              if(element.select) {
                                strType += element.tag.toString();
                                break;
                              }
                            }
                            //setState(() {});
                          },
                        ),

                        /*
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: const Row(
                            children: [
                              Text(
                                "교육기간 선택",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InputForm(
                                    onlyDigit: false,
                                    readOnly:true,
                                    hintText: 'YYYY-MM-DD',
                                    valueText: strDateBegin,
                                    onChange: (value) {},
                                    onMenu: (controller) async {
                                      showSelectMonth(
                                          context: context,
                                          title: '교육시작',
                                          useDay: true,
                                          date: DateTime.now(),
                                          onResult: (DateTime date) {
                                            strDateBegin
                                            = "${date.year}-${toZeroString(date.month)}-${toZeroString(date.day)}";
                                            controller.text = strDateBegin;
                                          });
                                      },
                                  )
                              ),

                              const Padding(
                                padding: EdgeInsets.only(left:10, right: 10),
                                child: Text("~",),
                              ),
                              Expanded(
                                  child: InputForm(
                                    onlyDigit: false,
                                    readOnly:true,
                                    hintText: 'YYYY-MM-DD',
                                    valueText: strDateEnd,
                                    onChange: (value) {},
                                    onMenu: (controller) async {
                                      showSelectMonth(
                                          context: context,
                                          title: '교육종료',
                                          useDay: true,
                                          date: DateTime.now(),
                                          onResult: (DateTime date) {
                                            strDateEnd
                                            = "${date.year}-${toZeroString(date.month)}-${toZeroString(date.day)}";
                                            controller.text = strDateEnd;
                                          });
                                    },
                                  )
                              ),
                            ],
                          ),
                        ),
                        */
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
                        widget.onClose(true, keyword, strState, strType, strDateBegin, strDateEnd);
                      }
                  ),
              ),
            ],
          )
      ),
    );
  }
}

Future <void> showSearchCare({
  required BuildContext context,
  required String title,
  required List<MenuButtonRadioItem> items_type,
  required Function(bool bDirty,
      String keyword, String strState, String strType, String strDateBegin, String strDateEnd) onResult}) {
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
            items_type: items_type,
            viewHeight:viewHeight,
            onClose: (bDirty, keyword, strState, strType, strDateBegin, strDateEnd){
              onResult(bDirty, keyword, strState, strType, strDateBegin, strDateEnd);
            },
          ),
        ),
      );
    },
  );
}