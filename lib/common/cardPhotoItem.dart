// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:daejeoni/utils/mediaView.dart';

class CardPhotoItem {
  final String url;
  final String type;
  CardPhotoItem({
    required this.url,
    required this.type,
  });
}

class CardPhotos extends StatefulWidget {
  final List<CardPhotoItem> items;
  BoxFit? fit;
  void Function(String url)? onZoom;
  void Function(String type, String photoUrl)? onTap;
  CardPhotos({
    Key? key,
    required this.items,
    this.onTap,
    this.onZoom,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<CardPhotos> createState() => _CardPhotosState();
}

class _CardPhotosState extends State<CardPhotos> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return _errOrEmpty();
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (index)
                {
                  setState(() {
                    _currentPageNotifier.value = index;
                  });
                },
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return _showPhoto(widget.items[index]);
                }
            )
          ),
          Visibility(
            visible: widget.items.length>1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: CirclePageIndicator(
                itemCount: widget.items.length,
                dotColor: Colors.grey,
                selectedDotColor: Colors.black,
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errOrEmpty() {
    final padding = MediaQuery.of(context).size.width/4;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        //borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.fromLTRB(padding,0,padding,0),
      child: Image.asset(
        "assets/icon/tk_empty_photo.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _showPhoto_old(CardPhotoItem item) {
    if (item.url.isEmpty) {
      return _errOrEmpty();
    }
    if (item.type == "p") {
      return CachedNetworkImage(
        fit: widget.fit,
        imageUrl: item.url,
        // imageBuilder: (context, imageProvider) => Container(
        //   decoration: BoxDecoration(
        //     shape: BoxShape.rectangle,
        //     color: Colors.white,
        //     image: DecorationImage(image: imageProvider, fit: widget.fit),
        //   ),
        // ),
        placeholder: (context, url) => const Center(
            child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator()
            )
        ),
        errorWidget: (context, url, error) => _errOrEmpty(),
      );
    }

    return MediaView(
      isMovie: true,
      sourceUrl: item.url,
    );
  }
  Widget _showPhoto(CardPhotoItem item) {
    if (item.url.isEmpty) {
      return _errOrEmpty();
    }
    if (item.type == "p") {
      return Container(
        constraints: BoxConstraints(),
        child: Stack(
          children: [
            Positioned(
                top: 0, left: 0, right: 0, bottom: 0,
                child: CachedNetworkImage(
                  fit: widget.fit,
                  imageUrl: item.url,
                  // imageBuilder: (context, imageProvider) => Container(
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     color: Colors.white,
                  //     image: DecorationImage(image: imageProvider, fit: widget.fit),
                  //   ),
                  // ),
                  placeholder: (context, url) => const Center(
                      child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator()
                      )
                  ),
                  errorWidget: (context, url, error) => _errOrEmpty(),
                )
            ),
            Positioned(
                bottom: 5,
                right: 5,
                child: Visibility(
                  visible: widget.onZoom != null,
                  child: IconButton(
                    onPressed: () {
                      if(widget.onZoom != null) {
                        widget.onZoom!(item.url);
                      }
                    },
                    icon: Icon(Icons.zoom_in_outlined),
                  ),
                )
            ),
          ],
        ),
      );
    }

    return MediaView(
      isMovie: true,
      sourceUrl: item.url,
    );
  }
}
