// ignore_for_file: must_be_immutable, file_names
import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/ItemContent.dart';
import 'package:flutter/material.dart';

class CardEventTile extends StatelessWidget {
  final ItemContent item;
  final Function(ItemContent item) onFavorites;
  final bool? bTitleTag;
  double? imageSize;
  double? gapHeight;
  bool? boldTitle;
  bool? isSelectPlanetPerson;

  final Function(ItemContent item)? onTab;
  final Function(ItemContent item)? onTabPhoto;
  final Function(ItemContent item)? onTabContent;
  final Function(ItemContent item)? onTapTitle;
  final Function(ItemContent item)? onPlanetItem;

  CardEventTile({
    Key? key,
    required this.item,
    required this.onFavorites,
    this.bTitleTag = false,
    this.imageSize,
    this.onTab,
    this.onTabPhoto,
    this.onTabContent,
    this.onTapTitle,
    this.onPlanetItem,
    this.isSelectPlanetPerson = false,
    this.boldTitle = true,
    this.gapHeight = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mapType = item.content_type;




    //item.image_url = "";





    switch(mapType) {
      case "MAP": return TypeMap(context);
      case "SOS": return TypeSos(context);
      case "INS": return TypeInst(context);
      case "PRG": return TypePrg(context);
      default: return Container();
    }
  }


  Widget TypePrg(BuildContext context) {
    imageSize ??= MediaQuery.of(context).size.width * 0.3;
    String imageUrl = item.image_url;
    if(!imageUrl.startsWith("http")) {
      imageUrl = IMG_EMPTY;
    }
    String dist = "${(item.distance * 100).truncate() / 100} Km";
    return GestureDetector(
        onTap: () {
          if (onTab != null) {
            onTab!(item);
          }
        },

        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: imageSize,
                height: imageSize,
                child: CardPhoto(photoUrl: imageUrl),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      //color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 프로그램 타이틀/거리
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(
                                    item.content_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: (boldTitle!) ? ItemBkB14 : ItemBkN14
                                ),),
                                const SizedBox(width: 10,),
                                Text(dist, style: ItemG1N12,),
                                //SizedBox(width: 10,)
                              ],
                            ),
                          ),
                          // 프로그램 카테고리
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_type.png",
                              value: item.getEduType()),
                          // 접수기간
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_date.png",
                              value: item.receptionPeriod()),
                          // 주소
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_map.png",
                              value: item.addrBasic()),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        )
    );
  }

  Widget TypeInst(BuildContext context) {
    imageSize ??= MediaQuery.of(context).size.width * 0.2;
    String imageUrl = item.image_url;
    if(!imageUrl.startsWith("http")) {
      imageUrl = IMG_EMPTY;
    }
    String dist = "${(item.distance * 100).truncate() / 100} Km";
    return GestureDetector(
        onTap: () {
          if (onTab != null) {
            onTab!(item);
          }
        },

        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: imageSize,
                height: imageSize,
                child: CardPhoto(photoUrl: imageUrl),
              ),

              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                    item.content_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: (boldTitle!) ? ItemBkB14 : ItemBkN14
                                ),),
                                const SizedBox(width: 10,),
                                Text(dist, style: ItemG1N12,),
                                //SizedBox(width: 10,)
                              ],
                            ),
                          ),
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_type.png",
                              value: item.getHiName()),
                          _labelCard(
                            isFavorites: false,
                            imagePath: "assets/icon/hot_map.png",
                            value: item.addrBasic(),
                            maxLines: 1,
                          ),

                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_person.png",
                              value: "예약가능인원: ${item.capacity}명"),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        )
    );
  }
  Widget TypeSos(BuildContext context) {
    imageSize ??= MediaQuery.of(context).size.width * 0.3;
    String imageUrl = item.image_url;
    if(item.sos_code=="1") {
      imageUrl = IMG_SOS01;
    } else if(item.sos_code=="2") {
      imageUrl = IMG_SOS02;
    } else {
      imageUrl = IMG_SOS03;
    }
    String dist = "${(item.distance * 100).truncate() / 100} Km";

    bool isHolyday = false;
    bool isNight = false;
    if(item.mapCtgryCd=="2") {
      isNight = item.isPhNight();
      isHolyday = item.isPhHolyday();
    } else if(item.mapCtgryCd=="1") {
      isNight = item.isHsNightOp();
    }
    return GestureDetector(
        onTap: () {
          if (onTab != null) {
            onTab!(item);
          }
        },

        child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  width: imageSize,
                  //height: imageSize,
                  //color: Colors.amber,
                  child: Stack(
                    children: [
                      Positioned(
                          child: CardPhoto(photoUrl: imageUrl)
                      ),

                      Positioned(
                        bottom: 0, left: 0, right: 0,
                          child: Row(
                            children: [
                              const Spacer(),
                              Visibility(
                                visible: isNight,
                                child:Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  padding: const EdgeInsets.fromLTRB(3,3,3,3),
                                  color: Colors.green,
                                  child: const Text("야", style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                              Visibility(
                                visible: isHolyday,
                                child:Container(
                                  margin: const EdgeInsets.only(right: 0),
                                  padding: const EdgeInsets.fromLTRB(3,3,3,3),
                                  color: Colors.red,
                                  child: const Text("휴", style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(
                                      item.content_title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: (boldTitle!) ? ItemBkB14 : ItemBkN14
                                  ),),
                                  const SizedBox(width: 10,),
                                  Text(dist, style: ItemG1N12,),
                                  //SizedBox(width: 10,)
                                ],
                              ),
                            ),
                            _labelCard(
                                isFavorites: false,
                                imagePath: "assets/icon/hot_map.png",
                                value: item.addrBasic()),
                            _labelCard(
                                isFavorites: false,
                                imagePath: "assets/icon/hot_type.png",
                                value: item.tel),
                          ],
                        ),
                      ),
                    )),
          ],
        )
        )
    );
  }
  Widget TypeMap(BuildContext context) {
    imageSize ??= MediaQuery.of(context).size.width * 0.3;
    String imageUrl = item.image_url;
    if(!imageUrl.startsWith("http")) {
      imageUrl = IMG_EMPTY;
    }
    String dist = "${(item.distance * 100).truncate() / 100} Km";
    return GestureDetector(
        onTap: () {
          if (onTab != null) {
            onTab!(item);
          }
        },

        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: imageSize,
                height: imageSize,
                child: CardPhoto(
                    photoUrl: imageUrl,
                  //fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      //color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(
                                    item.content_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: (boldTitle!) ? ItemBkB14 : ItemBkN14
                                ),),
                                const SizedBox(width: 10,),
                                Text(dist, style: ItemG1N12,),
                                //SizedBox(width: 10,)
                              ],
                            ),
                          ),
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_type.png",
                              value: item.getPlayName()),
                          _labelCard(
                              isFavorites: false,
                              imagePath: "assets/icon/hot_map.png",
                              value: item.addrBasic()),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        )
    );
  }

  Widget _labelCard({
    required isFavorites,
    required String imagePath,
    required String value,
    bool? isBold = false,
    bool? isRedColor = false,
    bool? isSelectable = false,
    int?  maxLines=1,
  }) {
    Color iconColor;
    TextStyle style = ItemBkN12;
    if(isSelectable!) {
      iconColor = const Color(0xFF4C83B6);
      style = ItemB1B14;
    }
    else {
      iconColor = (isRedColor!) ? Colors.red : Colors.green;
      if (isBold!) {
        style = ItemBkB14;
      }
      if (isRedColor) {
        style = ItemR1B14;
      }
    }
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, gapHeight!, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if(isFavorites) {
                onFavorites(item);
              }
            },
            child: Image.asset(imagePath,
                width: CardItemIconSize,
                height: CardItemIconSize,
                color: iconColor),
          ),
          const SizedBox(width: 3),
          Expanded(
              child: Text(
                value,
                maxLines: maxLines,
                style: style,
                overflow: TextOverflow.ellipsis,
              )
          )
        ],
      ),
    );
  }
}
