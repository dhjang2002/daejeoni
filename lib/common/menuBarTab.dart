// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class MenuBarTab extends StatefulWidget {
  final List<String> items;
  final double barHeight;
  final Function(int index) onChange;
  final int? initChoice;
  final EdgeInsetsGeometry? padding;
  final bool? useIndicator;
  final double? tabGap;
  final double? indicatorSize;
  final double? tabHeight;
  final TextStyle? onStyle;
  final TextStyle? offStyle;
  final bool? enable;
  const MenuBarTab({
    Key? key,
    required this.items,
    required this.barHeight,
    required this.onChange,
    this.initChoice=0,
    this.padding = const EdgeInsets.all(3),
    this.useIndicator = true,
    this.tabGap = 2,
    this.indicatorSize=3,
    this.tabHeight = 38,
    this.onStyle = ItemBkN16,
    this.offStyle = ItemG1N16,
    this.enable = true,
  }) : super(key: key);

  @override
  State<MenuBarTab> createState() => _MenuBarTabState();
}

class _MenuBarTabState extends State<MenuBarTab> {

  late int _tabIndex=0;

  @override
  void initState() {
    setState((){
      _tabIndex = widget.initChoice!;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.barHeight,
      //color:Colors.amber,
      child: GridView.builder(
          padding: widget.padding,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.items.length,
            childAspectRatio:1.0,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: widget.items.length,
          itemBuilder: (context, int index) {
            return SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  GestureDetector(
                    child: Container(
                        height: widget.tabHeight,
                        width: double.infinity,
                        color: Colors.transparent,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        alignment: Alignment.center,
                        child: Text(
                          widget.items[index],
                          style: (_tabIndex == index)
                              ? widget.onStyle
                              : widget.offStyle,
                        )),
                    onTap: () {
                      if(widget.enable!) {
                        if (_tabIndex != index) {
                          setState(() {
                            _tabIndex = index;
                          });
                          widget.onChange(_tabIndex);
                        }
                      }
                    },
                  ),
                  Visibility(
                      visible: widget.useIndicator!,
                      child: SizedBox(height: widget.tabGap)),
                  Visibility(
                    visible: widget.useIndicator!,
                    child: Container(
                        width: double.infinity,
                        height: widget.indicatorSize,
                        color: (_tabIndex == index) ? ColorB3 : Colors.grey[300]),
                  ),
                ]));
          }),
    );
  }
}
