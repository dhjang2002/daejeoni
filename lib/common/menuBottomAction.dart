import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';

/*
void showAlertDialog(BuildContext context){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return  Stack(
          clipBehavior: Clip.none, alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width*.6,
                height: 180,
                margin: const EdgeInsets.only(right: 10, bottom: 250),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100]
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you agree with the terms?",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("No")
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Yes")
                        )
                      ],
                    )
                  ],
                )
            )
          ],
        );
      }
  );
}
*/
/*
void showDialogPop({
  required BuildContext context,
  required String title,
  required Text body,
  required Text content,
  required int choiceCount,
  String? yesText = "확인",
  String? cancelText = "취소",
  required Function(bool isOK) onResult}) {
  showDialog(
    context: context,
    barrierDismissible: false, //다이얼로그 바깥을 터치 시에 닫히도록 하는지 여부 (true: 닫힘, false: 닫히지않음)
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20)),
            content: SingleChildScrollView(
              //내용 정의
              child: ListBody(
                children: <Widget>[
                  body,
                  const SizedBox(height: 5),
                  content,
                ],
              ),
            ),
            actions: <Widget>[
              //버튼 정의
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onResult(true); // 현재 화면을 종료하고 이전 화면으로 돌아가기
                },
                child: Text(
                  yesText!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Visibility(
                visible: (choiceCount > 1) ? true : false,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 현재 화면을 종료하고 이전 화면으로 돌아가기
                    onResult(false);
                  },
                  child: Text(
                    cancelText!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          )
      );
    },
  );
}
*/

/*
void showPopupMessage(BuildContext context, Text message) async {
  double height = (MediaQuery.of(context).size.height / 3 > 150)
      ? MediaQuery.of(context).size.height / 3
      : 150;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              message,
            ],
          ),
        ),
      );
    },
  );
}
*/

class BMenuItem {
  final String? itemId;
  final Widget? icon;
  final String? label;
  BMenuItem({this.itemId, this.icon, this.label});
}

Future <void> showBottomActionMenu({
    required BuildContext ctx,
    required List<BMenuItem> items,
    double height = 180,
    Color background = const Color(0xFFFFFFFF),
    Color btnColor   = const Color(0xFFFFFFFF),
    required Function(String itemId, String label) onTap}) {
  return showModalBottomSheet(
    context: ctx,
    useRootNavigator: true,
    isDismissible: false,
    builder: (context) {
      return Container(
        color: background,
        height: height,
        padding: const EdgeInsets.only(top:20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                //shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  BMenuItem item = items[index];
                  return  Container(
                    color: background,
                    child: InkWell(
                      splashColor: Colors.grey,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        title: Container(
                          color: background,
                          child: Row(
                            children: [
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 40, height: 40,
                                child: item.icon,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                item.label!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onTap(item.itemId!, item.label!);
                      },
                    ),
                  );
                },
              ),
            ),
            //Divider(thickness: 1,),
            ButtonSingle(text: '닫기', enable: true, visible: true,
                enableColor: btnColor,
                enableTextColor: Colors.black,
                onClick: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
        ),
      );
    },
  );
}





