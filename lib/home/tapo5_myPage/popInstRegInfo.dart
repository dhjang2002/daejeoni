// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/dialogbox.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemInstReserve.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final List<ItemInstReserve> items;
  final Function(String cmd, ItemInstReserve info) onClose;
  const _ContentView({
    Key? key,
    required this.title,
    required this.items,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_ContentView> createState() => __ContentViewState();
}

class __ContentViewState extends State<_ContentView> {
  bool _bEnable = true;
  Color bgColor = Colors.white;
  Color fgColor = Colors.black;
  String title = "";

  //late SessionData _session;

  @override
  void initState() {
    //_session = Provider.of<SessionData>(context, listen: false);
    if(widget.items[0].type()=="상시") {
      bgColor = Colors.green;
      fgColor = Colors.white;
      title = "예약정보-상시";
    } else {
      bgColor = Colors.deepOrange;
      fgColor = Colors.white;
      title = "예약정보-일시";
    }
    _validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _validate() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: fgColor),),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: fgColor,
                  size: app_top_size_close,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
      body: GestureDetector(
          onTap: () async { FocusScope.of(context).unfocus(); },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 여기에 다른 위젯들을 추가합니다.
                          //const Text("인적사항", style: ItemBkB16,),
                          ListView.builder(
                              itemCount: widget.items.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return _showItem(widget.items[index]);
                              }
                          ),
                          const SizedBox(height: 50,),
                          Visibility(
                            visible: false,
                            child:ButtonSingle(
                                visible: true,
                                isBottomPading: false,
                                text: "예약취소",
                                enable: _bEnable,
                                onClick: () {
                                  Navigator.pop(context);
                                  //widget.onClose("DELETE", widget.info);
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _showItem(ItemInstReserve item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0,1,0,10),
        child: Column(
          children: [
            _rowItem("예약번호", item.insttResveSn,false, false),
            _rowItem("기관명", item.insttNm,false, false),
            _rowItem("예약일자", item.insttResveDt,false, false),
            _rowItem("신청일자", item.regDt, false, false),
            _rowItem("아동 이름", item.insttResveChildNm, false, false),
            _rowItem("아동 성별", item.sex(), false, false),
            _rowItem("아동 생년월일", item.insttResveChldrnBrdt, false, false),
            _rowItem("유형", item.type(), false, false),
            _rowItem("상태", item.status(), false, true),
            //_rowItem("출결", "", false, false),

            Container(
              margin: const EdgeInsets.only(top:5, right: 5),
              child:Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 90,
                    height:  38,
                    child: ButtonState(
                      text: "예약취소",
                      enableColor: bgColor,
                      borderColor: bgColor,
                      textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                      onClick: () {
                        showYesNoDialogBox(
                            context: context,
                            height: 240,
                            title: "확인",
                            message: "예약 정보를 삭제하시겠습니까?\n",
                            onResult: (bYes) async {
                              if(bYes) {
                                Navigator.pop(context);
                                widget.onClose("DELETE_ONE", item);
                              }
                            }
                        );
                      },),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 90,
                    height:  38,
                    child: ButtonState(
                        text: "전체 예약취소",
                        enableColor: bgColor,
                        borderColor: bgColor,
                        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                        onClick: (){
                          showYesNoDialogBox(
                              context: context,
                              height: 240,
                              title: "확인",
                              message: "예약 정보를 삭제하시겠습니까?\n",
                              onResult: (bYes) async {
                                if(bYes) {
                                  Navigator.pop(context);
                                  widget.onClose("DELETE_GRP", item);
                                }
                              }
                          );
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  Widget _rowItem(String label, String value, bool useState, bool bLast) {
    const labelSize = 90.0;
    //const rowHeight = 40.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border(
          top: BSG5,
          left: BSG5,
          right: BSG5,
          bottom: (bLast)
              ? BSG5
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            //height: rowHeight,
            width: labelSize,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: const Border(right: BSG5,),
            ),
            child: Text(label, style: ItemBkB14,),
          ),

          Visibility(
            visible: !useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:10, top: 10, bottom: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  //height: rowHeight,
                  color: Colors.white,
                  child: Text(value, style: ItemBkN15,),
                )
            ),
          ),

          Visibility(
            visible: useState,
            child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left:20),
                  alignment: Alignment.centerLeft,
                  //height: rowHeight,
                  color: Colors.white,
                  child: SizedBox(
                    width: 80,
                    height: 32,
                    child: ButtonState(
                      padding: const EdgeInsets.all(8),
                      enable: false,
                      text: value,
                      //borderColor: Colors.amber,
                      textStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.black
                      ),
                      onClick: () {
                        //_doEdit(false, "정보수정", item);
                      },
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }


}

Future<void> showInstRegInfo({
  required BuildContext context,
  required String title,
  required List<ItemInstReserve> items,
  required Function(String cmd, ItemInstReserve info) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.75;
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
            onClose: (cmd, info) {
              onResult(cmd, info);
            },
          ),
        ),
      );
    },
  );
}