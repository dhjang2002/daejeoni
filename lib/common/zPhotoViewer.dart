import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomPhotoViewer extends StatefulWidget {
  // 'https://example.com/sample_image.jpg'
  final String url;
  const ZoomPhotoViewer({
    Key? key,
    required this.url
  }) : super(key: key);

  @override
  State<ZoomPhotoViewer> createState() => _ZoomPhotoViewerState();
}

class _ZoomPhotoViewerState extends State<ZoomPhotoViewer> {
  double _scale = 0.5;
  double _previousScale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
            _previousScale = _scale;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
              _scale = (_previousScale * details.scale).clamp(0.5, 5.0);
              });
           },
            child:Container(
              child: PhotoView(
                imageProvider: NetworkImage(widget.url),
                minScale: 0.25,
                maxScale: 5.0,
                initialScale: _scale,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            )
        ),
      ),
    );
  }
}
