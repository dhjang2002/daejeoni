// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';

class ButtonState extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Function() onClick;
  final bool?  visible;
  final bool?  enable;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final Color? enableColor;
  final Color? disableColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  double? borderRadius;
  ButtonState({
    Key? key,
    required this.text,
    required this.onClick,
    this.visible = true,
    this.enable  = true,
    this.padding          = const EdgeInsets.only(bottom: 2),
    this.enableColor      = const Color(0xFFFFFFFF),
    this.disableColor     = const Color(0xFFF0F0F0),
    this.borderColor      = Colors.grey,
    this.enableTextColor  = Colors.black,
    this.disableTextColor = Colors.black,
    this.borderRadius = 5.0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? btnTextStyle = (textStyle!=null)
        ? textStyle
        : TextStyle(color:(enable!)? enableTextColor: disableTextColor,
            fontSize:16.0,
            fontWeight: FontWeight.normal, height: 1.0);

    return Visibility(
      visible: visible!,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: InkWell(
            child: Container(
              width: double.infinity,
              padding: padding,
              child: Center(
                  child:Text(text,
                      style: btnTextStyle!)
              ),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius!),
                  border: Border.all(
                    color: borderColor!,
                    width: 1.0,
                  ),
                  color: (enable!)? enableColor : disableColor,
              ),
            ),
            onTap:() {
              //if(enable!) {
                onClick();
              //}
            },
          ),
        ),
      ),
    );
  }
}
