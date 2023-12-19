// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class MenuBarTabLabel extends StatefulWidget {
  final Widget label;
  final int labelFlex;
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
  const MenuBarTabLabel({
    Key? key,
    required this.label,
    required this.labelFlex,
    required this.items,
    required this.barHeight,
    required this.onChange,
    this.initChoice = 0,
    this.padding = const EdgeInsets.all(5),
    this.useIndicator = true,
    this.tabGap = 1,
    this.indicatorSize = 3,
    this.tabHeight = 36,
    this.onStyle  = ItemBkN14,
    this.offStyle = ItemG1N14,
  }) : super(key: key);

  @override
  State<MenuBarTabLabel> createState() => _MenuBarTabLabelState();
}

class _MenuBarTabLabelState extends State<MenuBarTabLabel> {
  late int _tabIndex;

  @override
  void initState() {
    _tabIndex = widget.initChoice!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int menuFlex = 10 - widget.labelFlex;
    return SizedBox(
      height: widget.barHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: widget.labelFlex,
              child: widget.label
          ),
          Expanded(
              flex: menuFlex,
              child: GridView.builder(
                  padding: widget.padding,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.items.length,
                    childAspectRatio: 1.0,
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
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 0, 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.items[index],
                                      style: (_tabIndex == index)
                                          ? widget.onStyle
                                          : widget.offStyle,
                                    )),
                                onTap: () {
                                  if (_tabIndex != index) {
                                    setState(() {
                                      _tabIndex = index;
                                    });
                                    widget.onChange(_tabIndex);
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
                                    color: (_tabIndex == index)
                                        ? ColorB3
                                        : Colors.grey[300]),
                              ),
                            ]));
                  })),
        ],
      ),
    );
  }
}
