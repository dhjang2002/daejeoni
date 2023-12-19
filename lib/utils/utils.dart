// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:daejeoni/Utils/photo_viewer.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transition/transition.dart';

String cvtYesNo(String answer) {
  if(answer=="Y" || answer=="Yes" || answer=="YES") {
    return "예";
  }
  return "아니오";
}

String cvtAprove(String answer) {
  if(answer=="Y" || answer=="Yes" || answer=="YES") {
    return "승인";
  }
  return "대기";
}

String cvtActiveFund(String answer) {
  if(answer=="Y" || answer=="Yes" || answer=="YES") {
    return "활동비 지원";
  }
  return "활동비 미지원";
}

String toZeroString(int value) {
  return (value<10) ? "0${value}" : value.toString();
}

String getUrlParam({required String website, required Map<String, dynamic> data}) {
  String url = website;
  if(data.isNotEmpty) {
    String param = "?";
    data.forEach((key, value) {
      if (param.length > 1) {
        param = param + "&";
      }
      param = param + "${key}=${value}";
      //print("${key}=${value}");
    });
    url = url + param;
  }

  print(url);
  return url;
}

String getDeviceOS() {
  if (Platform.isAndroid) {
    return "android";
  }
  else if (Platform.isIOS) {
    return "ios";
  }
  return "unknown";
}

String buildRandomAlphaNumeric(int length) {
  // 16자리 (문자 + 숫자) 조합
  // 난수 발생함수 초기화(seed->microsecond)
  Random rand = Random(DateTime.now().microsecond);

  // A(65~Z(97), a(97)~z(122), 1(48)~9(57)

  int c = 0;
  String alphaNumeric = "";
  for(int n=0; n<length; n++) {
    int kind = rand.nextInt(512)%3;
    switch(kind) {
      case 0: // A(65~Z(97)
        c = rand.nextInt(26)+65;
        break;
      case 1: // a(97)~z(122)
        c = rand.nextInt(26)+97;
        break;
      case 2: // 1(48)~9(57)
        c = rand.nextInt(10)+48;
        break;
    }
    alphaNumeric = "$alphaNumeric${String.fromCharCode(c).toString()}";
  }
  return alphaNumeric;
}

String getAreaFromAddress(String addr1) {
  String area = "";

  if(addr1.isEmpty) {
    return area;
  }

  List<String> token = addr1.split(" ");

  if(token.length<2) {
    return area;
  }

  if(token[0]=="세종특별자치시") {
    return "세종시";
  }

  if(token[0]=="제주특별자치도") {
    return token[1];
  }

  if(token[0]=="경남" && token[1]=="창원시") {
    return "${token[1]} ${token[2]}";
  }

  if(token[0]=="충남" && token[1]=="천안시") {
    return "${token[1]} ${token[2]}";
  }

  return "${token[0]} ${token[1]}";
}

void showPhoto(
    {required BuildContext context,
    required String title,
    required String url}) {
  Navigator.push(
    context,
    Transition(
        child: PhotoViewer(
          title: title,
          url: url,
        ),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT),
  );
}

Widget customImage(String url, double size) {
  return SizedBox(
    height: size,
    child: OctoImage(
      image: NetworkImage(url),
      progressIndicatorBuilder: (context, progress) {
        double? value;
        var expectedBytes = progress?.expectedTotalBytes;
        if (progress != null && expectedBytes != null) {
          value = progress.cumulativeBytesLoaded / expectedBytes;
        }
        return CircularProgressIndicator(value: value);
      },
      errorBuilder: (context, error, stacktrace) => const Icon(Icons.error),
    ),
  );
}

Widget circleAvatar(String url, double size) {
  return SizedBox(
    child: OctoImage.fromSet(
      fit: BoxFit.fill,
      image: NetworkImage(
        url,
      ),
      octoSet: OctoSet.circleAvatar(
        backgroundColor: Colors.black,
        text: const Text(""),
      ),
    ),
    height: size,
  );
}

Widget simpleBlurImage(String url, double aspectRatio) {
  return AspectRatio(
      aspectRatio: aspectRatio, //269 / 173,
      child: (url.isNotEmpty)
          ? OctoImage(
              image: NetworkImage(url),
              placeholderBuilder: OctoPlaceholder.blurHash(
                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
              ),
              errorBuilder: (context, error, stacktrace) => Image.asset(
                  "assets/icon/icon_empty_person.png",
                  fit: BoxFit.fill),
              fit: BoxFit.cover,
            )
          : Image.asset("assets/icon/icon_empty_person.png", fit: BoxFit.fill
      )
  );
}

Widget simpleBlurImageWithName(String value, double fontSize, String url, double aspectRatio) {
  String tag = "";
  if(value.isNotEmpty) {
    tag = value.substring(0, 1);
  }
  return AspectRatio(
      aspectRatio: aspectRatio, //269 / 173,
      child: (url.isNotEmpty)
          ? OctoImage(
        image: NetworkImage(url),
        placeholderBuilder: OctoPlaceholder.blurHash(
          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
        ),
        errorBuilder: (context, error, stacktrace) => Image.asset(
            "assets/icon/icon_empty_person.png",
            fit: BoxFit.fill),
        fit: BoxFit.cover,
      )
          : Container(
        color: const Color(0xffcbc9d9),//grey[300],
        child: Center(
          child: Text(tag,
            style: TextStyle(color:Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ));
}

String currencyFormat(String digit) {
  if (digit.isNotEmpty) {
    int price = int.parse(digit);
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "", decimalDigits: 0);
    return formatCurrency.format(price);
  }
  return "0";
}

String numberFormat(int price) {
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "", decimalDigits: 0);
    return formatCurrency.format(price);
}

Future <File?> pickupVideo() async {
  var pickedImage =
  await ImagePicker.platform.getVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> takeVideo() async {
  var pickedImage =
  await ImagePicker.platform.getVideo(source: ImageSource.camera, maxDuration: const Duration(seconds: 60));
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> pickupImage() async {
  var pickedImage =
      await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <File?> takeImage() async {
  var pickedImage =
      await ImagePicker.platform.pickImage(source: ImageSource.camera);
  File? imageFile = pickedImage != null ? File(pickedImage.path) : null;
  return imageFile;
}

Future <CroppedFile?> cropImage(File imageFile) async {
  ImageCropper imageCropper = ImageCropper();
  CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              //CropAspectRatioPreset.ratio3x2,
              //CropAspectRatioPreset.original,
              //CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPreset.ratio16x9
            ]
          : [
              //CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              //CropAspectRatioPreset.ratio3x2,
              //CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPreset.ratio5x3,
              //CropAspectRatioPreset.ratio5x4,
              //CropAspectRatioPreset.ratio7x5,
              //CropAspectRatioPreset.ratio16x9
            ],
      compressQuality: 75,
      uiSettings:
        [
          AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            //lockAspectRatio: true,
            hideBottomControls: true
          ),
          IOSUiSettings(
            title: '이미지 자르기',
            doneButtonTitle: "자르기",
            cancelButtonTitle: "취소",
            //aspectRatioPickerButtonHidden:true,
            //hidesNavigationBar:true,
            //showActivitySheetOnDone:false,
            //showCancelConfirmationDialog:false,
            //rotateClockwiseButtonHidden:false,
            hidesNavigationBar:true,
            rotateButtonsHidden:true,
            resetButtonHidden:false,
            aspectRatioPickerButtonHidden:true,
            resetAspectRatioEnabled:false,
            aspectRatioLockDimensionSwapEnabled:true,
            aspectRatioLockEnabled:true,
          )
        ]
  );

  return croppedFile;
}

Future <String> getFilePath(uniqueFileName) async {
  String path = '';
  Directory dir = await getApplicationDocumentsDirectory();
  path = '${dir.path}/$uniqueFileName';
  return path;
}

String getNameFromPath(String path) {
  if (path.length > 3) {
    File file = File(path);
    return file.path.split('/').last.toLowerCase();
  }
  return "";
}

String getExtFromPath(String path) {
  if (path.length > 3) {
    File file = File(path);
    return file.path.split('.').last.toLowerCase();
  }
  return "";
}

String getDayCount(String dateString) {
  if (dateString.length >= 10) {
    if (dateString.indexOf(".") > 0) {
      dateString = dateString.replaceAll(".", "-");
    }
    DateTime birthday = DateFormat('yyyy-MM-dd').parse(dateString);
    DateTime today = DateTime.now();
    var diff = (today.difference(birthday).inDays) + 1;
    return "만난지 $diff일 ";
  }
  return "";
}


