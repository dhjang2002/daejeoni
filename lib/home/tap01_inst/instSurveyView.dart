
import 'package:daejeoni/common/buttonState.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemInstSurvey.dart';
import 'package:flutter/material.dart';

class SurveyView extends StatelessWidget {
  final List<ItemInstSurvey> items;
  final Function(ItemInstSurvey item)? onSurvey;
  final Function(ItemInstSurvey item)? onDelete;
  const SurveyView({
    Key? key, 
    required this.items,
    this.onDelete,
    this.onSurvey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        //shrinkWrap: true,
        //physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return _itemView(items[index]);
        });
  }

  Widget _itemView(ItemInstSurvey item) {
    bool isNotExpire = item.isDateInRange() && item.qustnrRespondCnt.isEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(0,10,0,5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(item.qustnrSj,
                        textAlign: TextAlign.justify,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: ItemBkB14,
                      ),
                  )
                ),
                Container(
                  width: 130,
                  padding: const EdgeInsets.only(right: 5),
                  //color: Colors.amber,
                  child: Text("${item.getYDayStamp(item.bgngDt)}\n~${item.getYDayStamp(item.endDt)}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: ItemBkN12,
                  ),
                ),
                SizedBox(
                  width: 120,
                  //color: Colors.grey,
                  //padding: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 28,
                        child: ButtonState(
                          text: "응답인원:${item.qustnrRespondCnt}",
                          enable: false,
                          disableColor: Colors.green,
                          borderColor: Colors.green,
                          borderRadius: 10,
                          textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white
                          ), onClick: () {},
                        ),
                      ),
                      // SizedBox(
                      //   width: 90,
                      //   height: 28,
                      //   child: ButtonState(
                      //     text: "설문기간아님",
                      //     enable: false,
                      //     disableColor: Colors.grey,
                      //     borderColor: Colors.grey,
                      //     borderRadius: 10,
                      //     textStyle: TextStyle(
                      //         fontSize: 12,
                      //         color: Colors.black
                      //     ), onClick: () {},
                      //   ),
                      // ),
                      const SizedBox(height: 10,),
                      Visibility(
                        visible: true,//isNotExpire,
                        child: SizedBox(
                          width: 90,
                          height: 32,
                          child: ButtonState(
                            text: (isNotExpire) ? '설문참여' : "설문기간아님",
                            enable: (isNotExpire),
                            enableColor: (isNotExpire) ? Colors.pink : Colors.grey,
                            borderColor: (isNotExpire) ? Colors.pink : Colors.grey,
                            borderRadius: 5,
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: (isNotExpire) ? Colors.white : Colors.black,
                            ),
                            onClick: () {
                              if(isNotExpire && onSurvey != null) {
                                onSurvey!(item);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
