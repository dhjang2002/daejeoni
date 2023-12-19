// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardPhoto extends StatelessWidget {
  String? photoUrl;
  BoxFit? fit;
  double? radious;
  Function()? onZoom;
  CardPhoto({
    Key? key,
    this.fit = BoxFit.fill,
    this.radious = 8,
    this.onZoom,
    required this.photoUrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isInvalid = photoUrl==null || photoUrl!.contains("atchFileId=null");
    if(isInvalid) {
      return Container();
    }
    bool isUrl    = (photoUrl!.isNotEmpty && photoUrl!.startsWith("http"));
    bool isAssets = (photoUrl!.isNotEmpty && photoUrl!.startsWith("assets/"));
    return Stack(
      children: [
        Positioned(child: (isUrl)
            ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radious!)),
            child: CachedNetworkImage(
              fit:BoxFit.fill,
              imageUrl: photoUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: imageProvider, fit: fit),
                ),
              ),
              placeholder: (context, url) => const Center(
                  child: SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Container(color: const Color(0xFFFAFAFA)),
            ))
            : (isAssets) ? (Image.asset(photoUrl!, fit: fit))
            : ((photoUrl!.isNotEmpty)
            ? Image.file(File(photoUrl!), fit: fit)
            : Container(color: const Color(0xFFFAFAFA))
        )),
        Positioned(
          bottom: 10,
          left: 5,
          right: 5,
          child: Visibility(
            visible: onZoom != null,
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    FloatingActionButton.small(
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.zoom_in_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () {
                          onZoom!();
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
