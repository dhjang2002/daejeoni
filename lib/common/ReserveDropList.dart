// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class CardDropList extends StatefulWidget {
  final List<String> itemList;
  final bool visible;
  final Function(String value) onChange;
  const CardDropList({Key? key,
    required this.itemList,
    required this.onChange,
    required this.visible}) : super(key: key);

  @override
  State<CardDropList> createState() => _CardDropListState();
}

class _CardDropListState extends State<CardDropList> {

  //bool _bTypeOpen = false;
  String value = "";

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              //widget.onChange("");
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(15,15,15,15),
                margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EFF5),
                  border: Border.all(
                    color: const Color(0xFF4C83B6),
                  ),
                  //borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text("필수 선택", style: ItemB1N16)
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:3),
            child: ListView.builder(
                itemCount: widget.itemList.length,
                shrinkWrap:true,
                itemBuilder: (context, index){
                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(thickness: 1, height: 1,),
                        InkWell(
                          onTap:() {
                            // setState((){
                            //   _bTypeOpen = false;
                            //
                            // });
                            value = widget.itemList[index];
                            widget.onChange(value);
                          },
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(15,15,15,15),
                              child: Text(widget.itemList[index].toString())),
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
