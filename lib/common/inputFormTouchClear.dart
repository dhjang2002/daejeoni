// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:daejeoni/constant/constant.dart';

class InputFormTouchClear extends StatefulWidget {

  Color? hilite;
  final String hintText;
  final String valueText;
  final Color? background;
  final String? title;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? readOnly;
  final bool? suffixAction;
  final bool? disable;
  final bool? clearLock;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String value) onChange;
  final Function(String value)? onSubmitted;

  final Function(TextEditingController controller)? onControl;
  final Function()? onMenu;
  InputFormTouchClear({
    Key? key,
    this.hilite,
    required this.onChange,
    required this.hintText,
    required this.valueText,
    this.suffixAction = false,
    this.title = "",
    this.background = Colors.white,
    this.prefixIcon,
    this.suffixIcon = const Text(""),
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.clearLock = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.disable=false,
    this.contentPadding = const EdgeInsets.fromLTRB(5, 10, 5, 10),
    this.onMenu,
    this.onControl,
    this.onSubmitted,
    this.textStyle = ItemBkN14,
    this.hintStyle = ItemG1N14,
    this.textAlign = TextAlign.end,
  }) : super(key: key);

  @override
  State<InputFormTouchClear> createState() => _InputFormTouchClearState();
}

class _InputFormTouchClearState extends State<InputFormTouchClear> {
  FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  void _onFocusChange() {
    if(_focusNode.hasFocus) {
      if(!widget.clearLock!) {
        if (!widget.readOnly!) {
          controller.text = "";
          widget.onChange("");
        }
      }
    }
    else {
      if(controller.text.trim().isEmpty) {
        controller.text = "";
      }
    }
  }

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    if(widget.onControl != null) {
      widget.onControl!(controller);
    }

    setState(() {
      controller.text = widget.valueText;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Color fillColor = Colors.transparent;
    Color fillColor = (widget.readOnly!) ? Colors.transparent : Colors.white;
    if(widget.disable!) {
      fillColor = Colors.transparent;
    }

    TextInputAction inputAction = widget.textInputAction!;
    TextInputType keyboard = widget.keyboardType!;
    if(widget.maxLines!>1) {
      inputAction = TextInputAction.none;
      keyboard = TextInputType.multiline;
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: (widget.title!.isNotEmpty) ? true : false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Text(widget.title!,
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: controller,
              focusNode: _focusNode,
              readOnly: widget.readOnly!,
              enabled: (!widget.disable!),
              obscureText: widget.obscureText!,
              textAlign: widget.textAlign!,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength:widget.maxLength,
              cursorColor: Colors.black,
              keyboardType: keyboard,
              textInputAction: inputAction,
              style: widget.textStyle,
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
                contentPadding: widget.contentPadding,
                isDense: true,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Colors.pinkAccent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onChanged: (String value) {
                widget.onChange(value);
              },
              onSubmitted: (value){
                if(widget.onSubmitted!=null) {
                  widget.onSubmitted!(value);
                }
              }
            ),
          ),
      ]
    );
  }
}
