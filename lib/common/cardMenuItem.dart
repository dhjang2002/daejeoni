// ignore_for_file: must_be_immutable

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class CardMenuItem {
  String assetsPath;
  String title;
  String subTitle;
  String tag;
  bool select;

  CardMenuItem({
    this.assetsPath = "",
    this.title = "",
    this.subTitle="",
    this.tag = "",
    this.select = false,
  });
}

class CardMenu extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final List<CardMenuItem> items;
  Function(List<CardMenuItem> items)? onChange;
  Function(CardMenuItem item)? onSelect;
  final Color? textSelColor;
  final Color? textNormColor;
  final Color? btnColor;
  final Color? borderColor;
  final double? borderWidth;
  int? crossAxisCount;
  double? childAspectRatio;
  double? borderRadius;
  double? crossAxisSpacing;
  double? mainAxisSpacing;
  double? fontSize;
  double? itemGap;
  double? iconSize;

  bool? isItemVer;
  CardMenu({
    Key? key,
    required this.items,
    this.onChange,
    this.onSelect,
    this.textSelColor = Colors.black,
    this.textNormColor = Colors.black,
    this.btnColor = Colors.transparent,
    this.borderColor = Colors.green,
    this.borderWidth = 2.0,
    this.margin = const EdgeInsets.all(5),
    this.crossAxisCount = 2,
    this.childAspectRatio = 3.0,
    this.borderRadius = 8.0,
    this.crossAxisSpacing=5.0,
    this.mainAxisSpacing = 1,
    this.fontSize=12.0,
    this.itemGap=10,
    this.isItemVer = false,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  State<CardMenu> createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.items.isNotEmpty)
        ? GridView.builder(
            padding: widget.margin,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount!,
              childAspectRatio: widget.childAspectRatio!,
              mainAxisSpacing: widget.mainAxisSpacing!,
              crossAxisSpacing: widget.crossAxisSpacing!,
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, int index) {
              return widget.isItemVer! ? _itemVer(widget.items[index]) : _itemHor(widget.items[index]);
            }
        )
        : Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text("등록된 정보가 없습니다.", style: ItemG1N14,),
      ),

    );
  }

  Widget _itemHor(CardMenuItem item) {
    return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            color: widget.btnColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset(item.assetsPath,
                    width: widget.iconSize!,
                    height: widget.iconSize!, fit: BoxFit.fitHeight,),
                ),
                SizedBox(width: widget.itemGap!),
                Expanded(
                    child: Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: ItemBkN12,
                    )
                ),
              ],
            ),
          ),
          onTap: () {
            for (var element in widget.items) {
              element.select = false;
            }
            setState(() {
              item.select = true;
            });
            if(widget.onSelect != null) {
              widget.onSelect!(item);
            }
            if(widget.onChange != null) {
              widget.onChange!(widget.items);
            }
          },
        )
    );
  }

  Widget _itemVer(CardMenuItem item) {
    return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: widget.btnColor,
            // decoration:  BoxDecoration(
            //   color: (item.select) ? widget.btnColor : Colors.white,
            //   borderRadius: BorderRadius.circular(widget.borderRadius!),
            //   border: Border.all(
            //     width: widget.borderWidth!,
            //     color: (item.select) ? widget.borderColor! : const Color(0xFFC9CACF),
            //   ),
            // ),
            // alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  child: Image.asset(item.assetsPath,
                    width: widget.iconSize!,
                    height: widget.iconSize!, fit: BoxFit.fitHeight,),
                ),
                SizedBox(height: widget.itemGap!),
                Text(item.title,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: ItemBkN12,),
                Visibility(
                  visible: item.subTitle.isNotEmpty,
                  child: Text(item.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: -1.8
                    ),),
                ),
                Spacer(),
              ],
            ),
          ),
          onTap: () {
            for (var element in widget.items) {
              element.select = false;
            }
            setState(() {
              item.select = true;
            });
            if(widget.onSelect != null) {
              widget.onSelect!(item);
            }
            if(widget.onChange != null) {
              widget.onChange!(widget.items);
            }
          },
        )
    );
  }
}
