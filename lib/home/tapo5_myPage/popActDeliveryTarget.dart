// ignore_for_file: non_constant_identifier_names
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/common/cardFace.dart';
import 'package:daejeoni/common/cardGRadio.dart';
import 'package:daejeoni/common/inputForm.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/home/tapo5_myPage/popSelectMonth.dart';
import 'package:daejeoni/models/ItemChild.dart';
import 'package:daejeoni/models/infoActDeliveryReport.dart';
import 'package:daejeoni/models/itemActDeliveryTarget.dart';
import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:daejeoni/common/buttonSingle.dart';
import 'package:intl/intl.dart';

class _ContentView extends StatefulWidget {
  final String title;
  final List<ItemActDeliveryTarget> items;
  final Function(bool bDirty) onClose;
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
  @override
  void initState() {
    _validate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.5,
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
      body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: ListView.builder(
            itemCount: widget.items.length,
              itemBuilder: (context, index) {
                ItemActDeliveryTarget item = widget.items[index];
                return _showItem(item);
              }
          ),
        )
      ),
    );
  }

  Widget _showItem(ItemActDeliveryTarget item) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CardFace(
                      photoUrl: (item.childSexdstn=="F")
                          ? "assets/mypage/avter_02.png"
                          :"assets/mypage/avter_01.png"),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right:10),
                                  child: Text("${item.title()}",
                                    maxLines: 1,
                                    style: ItemBkB15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(item.desc(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ItemBkN14,),
                      ],
                    )
                ),
              ],
            ),

            const SizedBox(height: 15,),
            const Divider(height: 1,),
          ],
        )
    );
  }

  void _validate() {
  }
}

Future<void> showDeliveryTarget({
  required BuildContext context,
  required String title,
  required List<ItemActDeliveryTarget> items,
  required Function(bool bDirty) onResult}) {
  double viewHeight = MediaQuery.of(context).size.height * 0.85;
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
            onClose: (bDirty) {
              onResult(bDirty);
            },
          ),
        ),
      );
    },
  );
}