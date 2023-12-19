import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardDescriptionImage extends StatelessWidget {
  final String imageUrl;
  final Function(double scale)? onScale;
  CardDescriptionImage({
    Key? key,
    required this.imageUrl,
    this.onScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: true,
        child: SizedBox(
          //height: 400,
          width: double.infinity,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: imageUrl,
              /*
              imageBuilder: (context, imageProvider) => PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: BoxDecoration(color: Colors.amber),
                // onScaleEnd:(
                //     BuildContext context,
                //     ScaleEndDetails details,
                //     PhotoViewControllerValue controllerValue) {
                //   // print("onScaleEnd(): "
                //   //     "scale:${controllerValue.scale}"
                //   //     "position:${controllerValue.position}"
                //   //);
                //   //view_height = view_height*controllerValue.scale!;
                //   if(onScale!=null && controllerValue.scale != null) {
                //     onScale!(controllerValue.scale!);
                //   }
                // },
                // initialScale:0.5,
               //    maxScale: 2.0,
               //    minScale: 0.5,
                   //disableGestures:true,
              ),
            */
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.fitWidth),
              ),
            ),
            placeholder: (context, url) => const Center(
                child: SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator())
            ),
            errorWidget: (context, url, error) => Container(),
          ),
        )
    );
  }
}

Future <Size> calculateImageDimension(String imageUrl) {
  bool isOk = true;
  Completer<Size> completer = Completer();
  Image image = Image(
      image: CachedNetworkImageProvider(
          imageUrl,
          errorListener: (){
            print("Invalid Image url................");
            isOk = false;
            //return null;
          }
      )
  );

  if(isOk) {
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(
              myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
  }
  return completer.future;
}

Future <double> computeImageHeight(BuildContext context, String imageUrl) async {
  Size size = await calculateImageDimension(imageUrl);
  double height = 0;
  if(size != null) {
    height = (MediaQuery.of(context).size.width / size.width) * size.height;
    if (kDebugMode) {
      print("imageUrl imageSize=${size.width} X ${size.height}");
      print("imageUrl just height =$height");
    }
  }
  return height;
}

class CardImageWebview extends StatefulWidget {
  final String imageUrl;
  const CardImageWebview({
    Key? key,
    required this.imageUrl
  }) : super(key: key);

  @override
  State<CardImageWebview> createState() => _CardImageWebviewState();
}

class _CardImageWebviewState extends State<CardImageWebview> {
  late WebViewController _webViewController;
  bool _bReady = false;

  @override
  void initState() {
    // if(Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }

    setState(() {
      _bReady = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!_bReady) {
      return const Center(child: const CircularProgressIndicator());
    }
    return Container();
    /*
    return  WebView(
      zoomEnabled: true,
      initialUrl: widget.imageUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },

      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },

      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },

      onPageStarted: (String url) {
        print('Page started loading: $url');
      },

      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },

      gestureNavigationEnabled: false,
    );
    */
    /*
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.amber,
        padding: EdgeInsets.all(10),
        child: WebView(
          zoomEnabled: true,
          initialUrl: widget.imageUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
          },

          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },

          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },

          onPageStarted: (String url) {
            print('Page started loading: $url');
          },

          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },

          gestureNavigationEnabled: false,
        ),
      ),
    );
    // if(!_bReady) {
    //   return const Center(child: const CircularProgressIndicator());
    // }
    */
  }
}


