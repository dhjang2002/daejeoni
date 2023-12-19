
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardCheckbox extends StatefulWidget {
  final String text;
  final bool visible;
  bool? initStatus;
  Color? background;
  Color? checkIconColor;
  double? checkIconSize;
  double? width;
  final Function(bool value) onChange;
  CardCheckbox({
    Key? key,
    required this.text,
    required this.visible,
    required this.onChange,
    this.initStatus = false,
    this.background = Colors.transparent,
    this.checkIconColor = Colors.pink,
    this.checkIconSize = 22,
    this.width = 80,
  }) : super(key: key);

  @override
  State<CardCheckbox> createState() => _CardCheckboxState();
}

class _CardCheckboxState extends State<CardCheckbox> {

  //bool _bStatus = false;

  @override
  void initState() {
    setState((){
      //_bStatus = widget.initStatus!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: GestureDetector(
        onTap:() {
          widget.initStatus = !widget.initStatus!;
          widget.onChange(widget.initStatus!);
        },

        child: Container(
          width: widget.width,
          color: widget.background,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon((widget.initStatus!)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
                  color: widget.checkIconColor,
                  size: widget.checkIconSize!
              ),

              Text(widget.text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.5, height: 1.0,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
