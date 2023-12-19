
// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemFavoriteGps.dart';
import 'package:flutter/material.dart';

class CardGpsTile extends StatelessWidget {
  final ItemFavoriteGps item;
  final bool? modeEdit;
  final bool?  bSelect;
  final double? tileHeight;
  final Function(ItemFavoriteGps item)? onTab;
  final Function(ItemFavoriteGps item)? onAction;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const CardGpsTile({
    Key? key,
    required this.item,
    this.tileHeight = 130,
    this.modeEdit = false,
    this.bSelect = true,
    this.onTab,
    this.onAction,
    this.margin  = const EdgeInsets.fromLTRB(1, 1, 1, 1),
    this.padding = const EdgeInsets.fromLTRB(5, 0, 10, 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return _cardItem(context);
  }

  Widget _cardItem(BuildContext context) {
    String imagePath = 'assets/inst/map.png';
    return GestureDetector(
      onTap: (){
        if(onTab != null) {
          onTab!(item);
        }
      },
      child: Container(
        height: tileHeight,
        padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
            border: Border.all(
              width: 1,
              color: (bSelect!)? Colors.pink: Colors.white,
            ),
        ),
        // margin: margin,
        // padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 아이콘
            SizedBox(
              // width: 40,
              // height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  //color: Colors.white,
                ),
              ),
            ),

            Expanded(
                child: Container(
                    padding: padding,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // title
                        Container(
                            padding: const EdgeInsets.only(left: 5, right: 0,),
                            child: Text(item.mapTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                //textAlign:TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.7,
                                  height: 1.1, color:
                                Colors.black,
                                )
                            )
                        ),
                        // 주소
                        Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(item.mapAddr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                //textAlign:TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1.7,
                                  height: 1.1, color:
                                  Colors.grey,
                                )
                            )
                        ),
                      ],
                    )
                )
            ),
            Visibility(
              visible: modeEdit! && !item.bCurrent,
                child: Container(
                  //padding: EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red,),
                    onPressed: () {
                      if(onAction != null) {
                        onAction!(item);
                      }
                    },
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
