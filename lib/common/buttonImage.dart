// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

import 'package:daejeoni/constant/constant.dart';
import 'package:flutter/material.dart';

class ButtonImage extends StatelessWidget {
  //final Widget? icon;
  final String path;
  final Function() onClick;
  final bool?  visible;
  final bool?  enable;
  //final Color? textColor;
  final Color? backgroundColor;
  final Color? disableColor;
  final Color? borderColor;
  final double radious;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconGap;
  const ButtonImage({
    Key? key,
    required this.path,
    required this.onClick,
    //this.icon,
    this.visible = true,
    this.enable = true,
    //this.textColor = Colors.white,
    this.backgroundColor  = Colors.transparent,
    this.borderColor  = const Color(0xFFE6E6E6),
    this.disableColor = Colors.transparent,
    this.radious = 10.0,
    this.padding = const EdgeInsets.fromLTRB(0,20,0,20),
    this.fontSize = 16,
    this.iconGap = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            //padding: padding,
            child:ClipRRect(
              borderRadius: BorderRadius.circular(radious),
              child: Image.asset(path, fit: BoxFit.fill), // Text(key['title']),
            ),

            decoration:  BoxDecoration(
                color: (enable!) ? backgroundColor : disableColor,
                borderRadius: BorderRadius.circular(radious),
                border: Border.all(
                  width: 1,
                  color: borderColor!,
                ),
            ),
          ),
          onTap: () {
            if(enable!) {
              onClick();
            }
          },
        ),
      ),
    );
  }
}
