// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardFace extends StatelessWidget {
  String? photoUrl;
  CardFace({
    Key? key,
    required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUrl = (photoUrl!.isNotEmpty && photoUrl!.startsWith("http"));
    return (isUrl)
        ? CachedNetworkImage(
            fit:BoxFit.fill,
            imageUrl: photoUrl!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
                child: SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator())),
            errorWidget: (context, url, error) => Image.asset("assets/icon/profil_empty.png", fit: BoxFit.fitHeight,),
          )
        : ((photoUrl!.isNotEmpty)
          ? CircleAvatar(
              //radius: 100,
              backgroundColor: Colors.transparent,
              child: Image.asset(photoUrl!, fit: BoxFit.fitWidth)
            )
          : Image.asset("assets/icon/profil_empty.png", fit: BoxFit.fitHeight,)
    );
  }
}
