import 'package:daejeoni/common/cardPhoto.dart';
import 'package:daejeoni/constant/constant.dart';
import 'package:daejeoni/models/itemFacility.dart';
import 'package:flutter/material.dart';

class CardFacility extends StatefulWidget {
  final String dataString;
  final int? crossAxisCount;
  const CardFacility({
    Key? key,
    required this.dataString,
    this.crossAxisCount = 5,
  }) : super(key: key);

  @override
  State<CardFacility> createState() => _CardFacilityState();
}

class _CardFacilityState extends State<CardFacility> {

  List <FacilityItem> items = [];

  /*
  <%-- <c:out value="${info.insttSpce}" /> --%>
              <c:if test="${fn:contains(info.insttSpce,'놀이')}">
                <div class="place_box">
                <img class="pr10px pb5px" src="/images/dolbom/2023/place_ico01.png" alt="놀이공간">
                <span class="place_desc">놀이공간</span>
                </div>
              </c:if>
              <c:if test="${fn:contains(info.insttSpce,'사무')}">
                <div class="place_box">
                  <img class="pr10px pb5px" src="/images/dolbom/2023/place_ico02.png" alt="사무공간">
                  <span class="place_desc">사무공간</span>
                </div>
              </c:if>
              <c:if test="${fn:contains(info.insttSpce,'조리')}">
                <div class="place_box">
                  <img class="pr10px pb5px" src="/images/dolbom/2023/place_ico04.png" alt="조리공간">
                  <span class="place_desc">조리공간</span>
                </div>
              </c:if>
              <c:if test="${fn:contains(info.insttSpce,'프로그램')}">
                <div class="place_box">
                  <img class="pr10px pb5px" src="/images/dolbom/2023/place_ico07.png" alt="프로그램실">
                  <span class="place_desc">프로그램실</span>
                </div>
              </c:if>
              <c:if test="${fn:contains(info.insttSpce,'화장')}">
                <div class="place_box">
                  <img class="pr10px pb5px" src="/images/dolbom/2023/place_ico03.png" alt="화장실">
                  <span class="place_desc">화장실</span>
                </div>
              </c:if>
   */

  @override
  void initState() {
    print("initState(): ${widget.dataString}");
    var list = widget.dataString.split(",");
    list.forEach((element) {
      if(element.contains("놀이") && !isContained("놀이공간")) {
        items.add(FacilityItem(
            Label: "놀이공간",
            image_url: "${SERVER}/images/dolbom/2023/place_ico01.png"
        ));
      }
      else if(element.contains("사무") && !isContained("사무공간")) {
        items.add(FacilityItem(
            Label: "사무공간",
            image_url: "${SERVER}/images/dolbom/2023/place_ico02.png"
        ));
      }
      else if(element.contains("화장") && !isContained("화장실")) {
        items.add(FacilityItem(
            Label: "화장실",
            image_url: "${SERVER}/images/dolbom/2023/place_ico03.png"
        ));
      }
      else if(element.contains("조리") && !isContained("조리공간")) {
        items.add(FacilityItem(
            Label: "조리공간",
            image_url: "${SERVER}/images/dolbom/2023/place_ico04.png"
        ));
      }
      else if(element.contains("프로그램") && !isContained("프로그램실")) {
        items.add(FacilityItem(
            Label: "프로그램실",
            image_url: "${SERVER}/images/dolbom/2023/place_ico07.png"
        ));
      }
      else {
        // items.add(FacilityItem(
        //     Label: element,
        //     image_url: "${SERVER}/images/dolbom/2023/place_ico05.png"
        // ));
      }
    });

    setState(() {
    });
    super.initState();
  }

  bool isContained(String label) {
    bool flag = false;
    for (var element in items) {
      if(element.Label==label) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width / 6;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.7,
            mainAxisSpacing: 5,
            crossAxisSpacing: 0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            FacilityItem item = items[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: imageWidth,
                  height: imageWidth,
                  padding: const EdgeInsets.only(bottom: 2),
                  child: CardPhoto(photoUrl: item.image_url),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    item.Label,
                    style: ItemBkN11,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
