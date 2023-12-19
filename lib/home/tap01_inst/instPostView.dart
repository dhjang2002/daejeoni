
// ignore_for_file: file_names

import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InstPostView extends StatelessWidget {
  final List<ItemPost> items;
  final Function(ItemPost item) onDelete;
  const InstPostView({
    Key? key, 
    required this.items,
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return _itemView(items[index]);
        });
  }

  Widget _itemView(ItemPost item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0,10,0,5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            color: Colors.white,
            child: Row(
              children: [
                RatingBarIndicator(
                  rating: item.insttReplyGrade,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 18.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(width: 10,),
                //Text("평점 ${item.insttReplyGrade}", style: ItemBkB14,),
                Text(item.mberId, style: ItemBkN14,),
                const Spacer(),
                Visibility(
                  visible: item.isMe,
                    child: GestureDetector(
                  onTap: () {
                    onDelete(item);
                  },
                  child: const Icon(Icons.clear),
                )
                )
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(5),
            child:Text(item.insttReplyText,
              textAlign: TextAlign.justify,
              maxLines: 5,
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
