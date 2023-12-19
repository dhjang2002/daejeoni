import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class ButtonToggle extends StatefulWidget {
  final List<String> items;
  final Function(int index, String value) onChange;
  int? initSelect;
  final Color? selBtnColor;
  final Color? normBtnColor;
  final TextStyle selStyle;
  final TextStyle normStyle;
  final double? minWidth;
  final double? minHeight;
  ButtonToggle({
    Key? key,
    required this.items,
    required this.onChange,
    this.initSelect = 0,
    this.selBtnColor = ColorB2,
    this.normBtnColor = ColorG4,
    this.selStyle = const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.5,
        height: 1.0,
        color: Colors.white),
    this.normStyle = const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.5,
        height: 1.0,
        color: Colors.black),
    this.minWidth = 120,
    this.minHeight = 28,
  }) : super(key: key);

  @override
  State<ButtonToggle> createState() => _ButtonToggleState();
}

class _ButtonToggleState extends State<ButtonToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.minHeight,
      width: widget.minWidth,
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
                onTap: () {
                  if(widget.initSelect != 0) {
                    setState(() {
                      widget.initSelect = 0;
                    });
                    widget.onChange(0, widget.items[0]);
                  }
                },
                child: Container(
                  //padding: EdgeInsets.fromLTRB(0,8,0,8),
                  decoration: BoxDecoration(
                    color: (widget.initSelect == 0) ? widget.selBtnColor : widget.normBtnColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)
                      ),
                  ),
                  child: Center(
                    child: Text(
                      widget.items[0], maxLines: 1, overflow: TextOverflow.fade,
                      style:
                          (widget.initSelect == 0) ? widget.selStyle : widget.normStyle,
                    ),
                  ),
            ),
              )
          ),
          Expanded(
              child: GestureDetector(
                onTap: () {
                  if(widget.initSelect != 1) {
                    setState(() {
                      widget.initSelect = 1;
                    });
                    widget.onChange(1, widget.items[1]);
                  }
                },
                child: Container(
                  //padding: EdgeInsets.fromLTRB(0,8,0,8),
                  decoration: BoxDecoration(
                    color: (widget.initSelect == 1) ? widget.selBtnColor : widget.normBtnColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.items[1], maxLines: 1, overflow: TextOverflow.fade,
                      style:
                      (widget.initSelect == 1) ? widget.selStyle : widget.normStyle,
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
