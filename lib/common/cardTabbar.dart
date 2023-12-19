// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TabbarItem {
  String name;
  String tag;
  String? cText;
  TabbarItem({
    this.name="",
    this.tag="",
    this.cText="",
  });
}

class CardTabbar extends StatefulWidget {
  final List<TabbarItem> items;
  final int index;
  double? tabHeight;
  double? itemWidth;
  Function(int index, TabbarItem item)? onChange;
  double? textSize;
  Color? selectColor;
  Color? normalColor;
  Color? selectBarColor;
  Color? normalBarColor;
  CardTabbar({
    Key? key,
    required this.items,
    required this.index,
    this.tabHeight=50,
    this.itemWidth=100,
    this.textSize = 16,
    this.normalColor = Colors.grey,
    this.selectColor = Colors.black,
    this.normalBarColor = Colors.grey,
    this.selectBarColor = Colors.black,
    this.onChange,
  }) : super(key: key);

  @override
  State<CardTabbar> createState() => _CardTabbarState();
}

class _CardTabbarState extends State<CardTabbar> {
  //int curr_Index = 0;

  @override
  void initState() {
    //curr_Index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      height: widget.tabHeight,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      //color: Colors.amber,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.items.length,
          itemBuilder: (context, index){
            TabbarItem item = widget.items[index];
            String label = item.name;
            if(item.cText!.isNotEmpty) {
              label = "${item.name}(${item.cText})";
            }
            return GestureDetector(
                onTap: (){
                  // setState(() {
                  //   curr_Index = index;
                  // });
                  if(widget.onChange != null) {
                    widget.onChange!(index, item);
                  }
                },
                child:Container(
                  padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
                  width: widget.itemWidth,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0, left: 0, right: 0,
                        child: Center(
                            child:Text(
                              (index==widget.index) ? label : item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: widget.textSize,
                              fontWeight: (index==widget.index) ? FontWeight.bold : FontWeight.normal,
                              letterSpacing: -1.0,
                              height: 1.2,
                              color: (index==widget.index) ? widget.selectColor : widget.normalColor,
                            ),
                            )
                        ),
                      ),

                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(1, 5, 1, 3),
                          height: 2,
                          color: (index==widget.index) ? widget.selectBarColor : widget.normalBarColor,
                        ),
                      ),

                    ],
                  ),
                )
            );
          }),
    );
  }
}
