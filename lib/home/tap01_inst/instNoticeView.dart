import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemInstNotice.dart';
import 'package:flutter/material.dart';

class InstNoticeView extends StatelessWidget {
  final List<ItemInstNotice> items;
  final Function(ItemInstNotice item)? onClick;
  const InstNoticeView({
    Key? key, 
    required this.items,
    this.onClick
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorG6,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          //shrinkWrap: true,
          //physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _itemView(items[index]);
          }),
    );
  }

  Widget _itemView(ItemInstNotice item) {
    // final span=TextSpan(text:item.boardCn);
    // final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
    // tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if(onClick != null) {
                onClick!(item);
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.boardSj, style: ItemBkB15, maxLines: 3,
                          textAlign:TextAlign.justify,
                          overflow: TextOverflow.ellipsis,),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(item.regDt.substring(0,10), style: ItemG1N14,),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
                    child: Text(item.boardCn,
                        style: ItemBkN15, maxLines: (item.showMore) ? 44 : 3,
                        textAlign:TextAlign.justify,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
