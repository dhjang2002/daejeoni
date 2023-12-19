// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class CardDropListCheck extends StatefulWidget {
  final List<String> itemList;
  final bool visible;
  final Function(String value) onChange;
  final double? viewHeight;
  const CardDropListCheck({
        Key? key,
        required this.itemList,
        required this.onChange,
        required this.visible,
        this.viewHeight=0,
      })
      : super(key: key);

  @override
  State<CardDropListCheck> createState() => _CardDropListCheckState();
}

class _CardDropListCheckState extends State<CardDropListCheck> {
  String value = "";

  List<bool> checkList = <bool>[];

  bool _bReady = false;
  @override
  void initState() {
    checkList = List.filled(widget.itemList.length, false);
    setState(() {
      _bReady = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_bReady) {
      return Container();
    }

    // height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 200.0,
    bool shrinkWrap = (widget.viewHeight==0);

    return Visibility(
      visible: widget.visible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EFF5),
                  border: Border.all(
                    color: const Color(0xFF4C83B6),
                  ),
                  //borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text("필수 선택", style: ItemB1N16)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            height: (shrinkWrap) ? null : widget.viewHeight,
            child: ListView.builder(
                itemCount: widget.itemList.length,
                shrinkWrap: shrinkWrap,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
                          child: Row(children: [
                            Checkbox(
                              value: checkList[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkList[index] = value!;
                                });
                                String selValue = "";
                                for(int n=0; n<checkList.length; n++) {
                                  if(checkList[n]) {
                                    if(selValue.isNotEmpty) {
                                      selValue += ", ";
                                    }
                                    selValue += widget.itemList[n];
                                  }
                                }

                                widget.onChange(selValue);
                              },
                            ),
                            Text(widget.itemList[index].toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ]),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
