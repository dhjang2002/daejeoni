import 'package:flutter/material.dart';

class MenuButtonCheckItem {
  String text;
  String tag;
  bool select;
  bool control;
  MenuButtonCheckItem({
    this.text = "",
    this.tag = "",
    this.select = false,
    this.control = false,
  });
}

class MenuButtonCheck extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final List<MenuButtonCheckItem> items;
  final Function(MenuButtonCheckItem item) onAll;
  final Function(List<MenuButtonCheckItem> items) onChange;
  final Color? textSelColor;
  final Color? textNormColor;
  final Color? btnColor;
  final Color? borderColor;
  final double? borderWidth;
  double? fontSize;
  int? crossAxisCount;
  double? childAspectRatio;
  double? borderRadius;
  double? crossAxisSpacing;
  double? mainAxisSpacing;
  bool? modeSelect;

  MenuButtonCheck({
    Key? key,
    required this.items,
    required this.onAll,
    required this.onChange,
    this.textSelColor   = Colors.black,
    this.textNormColor  = Colors.black,
    this.btnColor       = Colors.white,
    this.borderColor    = Colors.green,
    this.borderWidth = 1.0,
    this.margin = const EdgeInsets.all(5),
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.7,
    this.borderRadius = 5.0,
    this.crossAxisSpacing=5.0,
    this.mainAxisSpacing = 10.0,
    this.fontSize=12.0,
    this.modeSelect = false,
  }) : super(key: key);

  @override
  State<MenuButtonCheck> createState() => _MenuButtonCheckState();
}

class _MenuButtonCheckState extends State<MenuButtonCheck> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
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
            MenuButtonCheckItem item = widget.items[index];
            return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  child: Container(
                      decoration:  BoxDecoration(
                        color: (item.select) ? widget.btnColor : Colors.white,
                        borderRadius: BorderRadius.circular(widget.borderRadius!),
                        border: Border.all(
                          width: widget.borderWidth!,
                          color: (item.select) ? widget.borderColor! : const Color(0xFFC9CACF),
                        ),

                      ),
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                            item.text,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: (item.select) ? widget.textSelColor! : widget.textNormColor!,
                              fontSize: widget.fontSize!,
                              letterSpacing: -1.0,
                            ),
                          )
                      )
                  ),
                  onTap: () {
                    if(widget.modeSelect!) {
                      widget.items.forEach((element) { element.select = false; });
                      item.select = true;
                    }
                    else {
                      item.select = !item.select;
                      if (item.control) {
                        widget.onAll(item);
                      }
                    }
                    widget.onChange(widget.items);
                  },
                )
            );
          }),
    );
  }
}
