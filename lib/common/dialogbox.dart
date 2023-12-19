import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daejeoni/constant/constant.dart';

class _DialogContent extends StatelessWidget {
  final String message;
  final bool shrinkWrap;
  final bool? isCenter;
  const _DialogContent({
    Key? key,
    required this.message,
    required this.shrinkWrap,
    this.isCenter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle bodyStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: -0.8, height: 1.1, color: Colors.black);
    List items = message.split("\n");
    return Container(
      //color: Colors.amber,
      padding: const EdgeInsets.only(left:10, right: 10),
      alignment: (isCenter! )? Alignment.center : Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: shrinkWrap,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            if(isCenter!) {
              return Center(child: Text(
                  items[index],
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle));
            }
            return Text(items[index],
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                style: bodyStyle);
        }
      ),
    );
  }
}

void showOkDialogBox({
  required BuildContext context,
  required String title,
  required String message,
  String? btnText = "확인",
  double? height = 250,
  bool?   alignHorCenter = true,
  EdgeInsets? margin = const EdgeInsets.all(10),
  Function(bool isOK)? onResult,}) {
  showDialog(
    context: context,
    barrierDismissible: true, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            insetPadding: margin!,
            contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width*0.9,//double.minPositive,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Center(child: Text(title, maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: ItemBkN20),
                    ),
                  ),
                  const Divider(thickness: 1),

                  // body
                  Expanded(child: _DialogContent(
                      shrinkWrap:true,
                      isCenter: alignHorCenter,
                      message: message)
                  ),

                  const SizedBox(height: 10),

                  // button
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color:ColorB3,
                            child: Center(
                              child: Center(child: Text(btnText!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16)),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            if(onResult != null) {
                              onResult(true);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      );
    },
  );
}

void showYesNoDialogBox({
  required BuildContext context,
  required String title,
  required String message,
  String? btnYes = "예",
  String? btnNo  = "아니오",
  double? height = 300,
  bool?   reverse = false,
  bool?   alignHorCenter = true,
  EdgeInsets? margin = const EdgeInsets.all(10),
  required Function(bool isOK) onResult}) {
  showDialog(
    context: context,
    barrierDismissible: false, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => true,//false,
          child: AlertDialog(
            insetPadding: margin!,
            contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width*0.85,//double.minPositive,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ItemBkN18
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),

                  // body
                  Expanded(
                      child: _DialogContent(
                      shrinkWrap:true,
                      isCenter: alignHorCenter,
                      message: message)
                  ),
                  const SizedBox(height: 10),

                  // Yes/No Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            color:(reverse!) ? ColorB3: const Color(0xFFEEEEF0),
                            child: Center(child: Center(child: Text(btnYes!,
                                style: TextStyle(
                                    color: (reverse) ? Colors.white : const Color(0xFFB1B2B9),
                                    fontWeight: FontWeight.normal, fontSize: 16)))),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            onResult(true);
                          },
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              color:(!reverse) ? ColorB3: const Color(0xFFEEEEF0),
                              child: Center(child: Center(child: Text(btnNo!,
                                  style: TextStyle(
                                      color: (!reverse) ? Colors.white : const Color(0xFFB1B2B9),
                                      fontWeight: FontWeight.normal, fontSize: 16)))),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              onResult(false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      );
    },
  );
}

void showToastDialog({
  required BuildContext context,
  required String message,
  Function()? onResult,
  EdgeInsetsGeometry? padding = const EdgeInsets.only(left:10, right:10),
  double? topGap = -5,
  Color?  barrierColor = const Color(0x00000000),
  Color?  background = const Color(0xFFFFFFFF),
  bool?   barrierDismissible = false,
  bool?   onWillPop = false,}) {
  double topOffset = MediaQuery.of(context).padding.top+topGap!;
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible!,
      barrierColor: barrierColor,
      builder: (BuildContext context){
        return  WillPopScope(
            onWillPop: () async => onWillPop!,
            child: Stack(
              clipBehavior: Clip.none, alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width*0.95,
                    height: 48,
                    margin: EdgeInsets.only(top: topOffset),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: padding!,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(message, overflow: TextOverflow.ellipsis, maxLines: 1,
                          style: ItemB1N16,
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
                            child: const Icon(Icons.clear, size: 22, color: Colors.black,),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            onResult!();
                          },
                        ),
                      ],
                    )
                )
              ],
            )
        );
      }
  );
}

void showValueInputDialog({
  required BuildContext context,
  required String title,
  required String item,
  required Function(bool isOK, String value) onResult}) {
  TextEditingController v1Controller = TextEditingController();
  showDialog (
    context: context,
    barrierDismissible: false, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Center(child: Text(title)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black, backgroundColor:Colors.grey[200]),
              onPressed: () {
                onResult(false, v1Controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('취소', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor:Colors.blue),
              onPressed: () {
                onResult(true, v1Controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('확인', style: TextStyle(fontSize: 18)),
            ),
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height:  120,
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: 1,),
                        Container(
                          margin: const EdgeInsets.only(top:10),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(item, overflow: TextOverflow.ellipsis,),
                              const Spacer()
                            ],
                          ),),
                        Container(
                          margin: const EdgeInsets.only(top:15),
                          width: double.infinity,
                          child: TextField(
                            controller: v1Controller,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            onChanged: (value){
                            },
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20, 15, 20, 15),
                              isDense: true,
                              hintText: "",
                              hintStyle: const TextStyle(color: Color(0xffcbc9d9)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey.shade200),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      );
    },
  );
}

void showSnackbar(BuildContext context, String message) {
  var snack = SnackBar(
    content: Text(message, style: const TextStyle(fontSize: 16),),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

void showToastMessage(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.amber,
      textColor: ColorB3,
      fontSize: 16.0);
}