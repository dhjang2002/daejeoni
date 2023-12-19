// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';

class ButtonSingle extends StatelessWidget {
  final String text;
  final Function() onClick;
  final bool?  visible;
  final bool?  enable;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final Color? enableColor;
  final Color? disableColor;
  final double? textSize;
  final bool? isBottomPading;
  final EdgeInsetsGeometry? padding;
  const ButtonSingle({
    Key? key,
    required this.text,
    required this.onClick,
    this.isBottomPading = true,
    this.visible = true,
    this.enable = true,
    this.enableColor      = Colors.black,
    this.disableColor     = const Color(0xFFEEEEF0),
    this.enableTextColor  = Colors.white,
    this.disableTextColor = Colors.black,
    this.padding = const EdgeInsets.fromLTRB(0,20,0,20),
    this.textSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color textColor = (enable!) ? Colors.white : Colors.grey;
    return Visibility(
      visible: visible!,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: InkWell(
            child: Container(
              width: double.infinity,
              padding: (isBottomPading!)
                  ? const EdgeInsets.fromLTRB(0,20,0,40)
                  : padding,
              child: Center(
                  child:Text(text,
                      style: TextStyle(
                          color:(enable!)? enableTextColor: disableTextColor,
                          fontSize:textSize,
                          fontWeight: FontWeight.normal,
                          height: 1.0
                      )
                  )
              ),
              decoration:  BoxDecoration(
                  color: (enable!)? enableColor : disableColor,
                  borderRadius: BorderRadius.circular(0.0)
              ),
            ),
            onTap:() {
              if(enable!) {
                onClick();
              }
            },
          ),
        ),
      ),
    );
  }
}
