// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class DropMenuItem {
  final String text;
  String? oid;
  bool  selected;
  DropMenuItem({
    required this.text,
    this.oid = "",
    this.selected = false,
  });
}

class CardDropListComboCheck extends StatefulWidget {
  List<DropMenuItem>? itemList;
  final bool?   multiSelect;
  final double? viewHeight;
  final bool? visible;
  bool?   stateOpen;
  String? title;
  final Function(List<String> valueList, String values) onChange;
  final Function(bool state)? onState;
  CardDropListComboCheck({
    Key? key,
    required this.itemList,
    required this.onChange,
    this.visible = true,
    this.stateOpen = false,
    this.onState,
    this.viewHeight=0,
    this.multiSelect = true,
    this.title = "필수선택",
  }) : super(key: key);

  @override
  State<CardDropListComboCheck> createState() => _CardDropListComboCheckState();
}

class _CardDropListComboCheckState extends State<CardDropListComboCheck> {
  bool _bReady = false;

  @override
  void initState() {

    setState(() {
      _bReady = true;
    });

    super.initState();
  }

  void _setCheck(int index, bool value) {
    List<String> valueList = [];
    if(!widget.multiSelect!) {
      for (int n=0; n<widget.itemList!.length; n++) {
        widget.itemList![n].selected = false;
      }
    }

    widget.itemList![index].selected = value;
    String selectedValue = "";
    for (int n=0; n< widget.itemList!.length; n++) {
      if(widget.itemList![n].selected) {
        valueList.add(widget.itemList![n].text);
        if(selectedValue.isNotEmpty) {
          selectedValue += " / ";
        }
        selectedValue += widget.itemList![n].text;
      }
    }
    setState((){});
    widget.onChange(valueList, selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    if (!_bReady) {
      return Container();
    }

    // height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 200.0,
    bool shrinkWrap = (widget.viewHeight==0);

    return Visibility(
      visible: widget.visible!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10,8,10,8),
              decoration: (!widget.stateOpen!)
                  ? BoxDecoration(color: Colors.white, border: Border.all(color: ColorG4))
                  : BoxDecoration(color: Colors.white, border: Border.all(color: ColorB1)),
              child: Row(
                children: [
                  Text(widget.title!,
                      style: (!widget.stateOpen!) ? ItemBkN15 : ItemB1N15),
                  const Spacer(),
                  IconButton(
                      icon: Icon((widget.stateOpen!)
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                        color: Colors.black,),
                      padding: EdgeInsets.zero, // 패딩 설정
                      constraints: const BoxConstraints(),
                      onPressed: (){
                        setState(() {
                          widget.stateOpen = !widget.stateOpen!;
                          if(widget.onState!=null) {
                            widget.onState!(widget.stateOpen!);
                          }
                        });
                      }),
                ],
              )),
          Visibility(
            visible: widget.stateOpen!,
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              height: (shrinkWrap) ? null : widget.viewHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorG4,
                ),
                //borderRadius: BorderRadius.circular(5.0),
              ),
              child: (widget.itemList!.isNotEmpty)
                  ? ListView.builder(
                  itemCount: widget.itemList!.length,
                  shrinkWrap: shrinkWrap,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(children: [
                              Checkbox(
                                value: widget.itemList![index].selected,
                                onChanged: (bool? value) {
                                  _setCheck(index, value!);
                                },
                              ),
                              Text(widget.itemList![index].text.toString(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ]),
                          ),
                          const Divider(
                            thickness: 1,
                            height: 1,
                          ),
                        ],
                      ),
                    );
                  })
                  : const Center(
                      child:Text("예약 가능한 시간대가 없습니다.", style: ItemG1N16,)),
            ),
          ),
        ],
      ),
    );
  }
}
