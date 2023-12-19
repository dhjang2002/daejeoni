
// ignore_for_file: file_names

import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemInstGallery.dart';
import 'package:flutter/material.dart';

class InstGalleryView extends StatelessWidget {
  final List<ItemInstGallery> items;
  final double imageWidth;
  final Function(ItemInstGallery item) onClick;
  const InstGalleryView({
    Key? key, 
    required this.items,
    required this.onClick,
    required this.imageWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.48,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index){
          return _itemView(items[index]);
        }, );
  }

  Widget _itemView(ItemInstGallery item) {
    String url = "$URL_IMAGE/cmm/fms/getImage.do?atchFileId=${item.atchFileId}&fileSn=0";
    return GestureDetector(
      onTap: () {
        onClick(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: imageWidth,
              height: imageWidth,
              //color: Colors.amber,
              child: CardPhoto(photoUrl: url,),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(3, 10, 5, 0),
            child:Text(item.boardSj,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ItemBkB16,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(3, 5, 5, 0),
            child:Text(item.boardCn,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ItemBkN14,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(3, 5, 5, 0),
            child:Text(item.regDt.substring(0,10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ItemBkN14,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
