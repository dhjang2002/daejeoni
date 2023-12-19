// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daejeoni/constant/constant.dart';

class InputForm extends StatefulWidget {

  Color? hilite;
  final bool onlyDigit;
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
  final bool? touchClear;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String value)? onChange;
  final Function(String value)? onSubmitted;
  final Function(TextEditingController controller) ? onControl;
  final Function(TextEditingController controller)? onMenu;
  InputForm({
    Key? key,
    required this.onlyDigit,
    required this.hintText,
    required this.valueText,
    this.hilite,
    this.onChange,
    this.touchClear = false,
    this.suffixAction = false,
    this.title = "",
    this.background = Colors.white,
    this.prefixIcon,
    this.suffixIcon = const Text(""),
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.disable=false,
    this.contentPadding = const EdgeInsets.fromLTRB(8, 10, 8, 10),
    this.onMenu,
    this.onControl,
    this.onSubmitted,
    this.textStyle = ItemBkN15,
    this.hintStyle = ItemG2N15,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  void _onFocusChange() {
    //print(">>>>>> has Focue: initValue=$initValue");
    if(_focusNode.hasFocus) {
      if(!widget.readOnly! && widget.touchClear!) {
          controller.text = "";
      }
    }
    else {
      //print(">>>>>> kill Focue: initValue=$initValue");
      if(controller.text.trim().isEmpty && widget.touchClear!) {
        controller.text = initValue;
        if(widget.onChange != null) {
          widget.onChange!(initValue);
        }
      }
    }
  }

  String initValue = "";

  @override
  void initState() {
    initValue = widget.valueText;
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
    Color fillColor = (widget.readOnly!) ? ColorG6 : Colors.white;
    if(widget.disable!) {
      fillColor = ColorG6;
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
              inputFormatters: (widget.onlyDigit)
                    ? [FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),] : null,
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
                suffixIconColor: Colors.black,
                suffixIcon: (widget.onMenu != null)
                    ? Container(
                  margin: EdgeInsets.only(right: 5),
                    child:Icon(Icons.arrow_drop_down)) : null,
                suffixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 24,),

                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1, color: ColorG6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1,
                      color: (widget.readOnly!) ? Colors.grey : Colors.pink),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(width: 1,
                      color: (widget.readOnly!) ? Colors.grey : Colors.black),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onChanged: (String value) {
                if(widget.onChange!=null) {
                  widget.onChange!(value.trim());
                }
              },
              onSubmitted: (value){
                if(widget.onSubmitted!=null) {
                  widget.onSubmitted!(value.trim());
                }
              },
              onTap: () {
                  if(widget.onMenu != null) {
                    widget.onMenu!(controller);
                  }
              },
            ),
          ),
    ]);
  }
}
