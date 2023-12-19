// ignore_for_file: file_names

import 'package:daejeoni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewer extends StatefulWidget {
  final bool isMovie;
  final String sourceUrl;

  const MediaViewer({
    Key? key,
    required this.isMovie,
    required this.sourceUrl,
  }) : super(key: key);

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  late VideoPlayerController _controller;
  late Future <void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    if(widget.isMovie) {
      // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
      // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
      _controller = VideoPlayerController.network(widget.sourceUrl);
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'

      // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
      _initializeVideoPlayerFuture = _controller.initialize();

      // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
      _controller.setLooping(true);
      //_controller.play();
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.isMovie) {
      // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
      _controller.dispose();
    }
    super.dispose();
  }

  Widget _showMedia() {
    if(widget.isMovie) {
      // VideoPlayerController가 초기화를 진행하는 동안 로딩 스피너를 보여주기 위해 FutureBuilder를 사용.
      return Center(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
                // VideoPlayer의 종횡비를 제한하세요.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
                  child: VideoPlayer(_controller),
                );
              } else {
                // 만약 VideoPlayerController가 여전히 초기화 중이라면,
                // 로딩 스피너를 보여줍니다.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ));
    }

    return Center(
        child:Container(
          child: simpleBlurImage(widget.sourceUrl, 1.0))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text((widget.isMovie) ? "동영상" : "사진",
            style: const TextStyle(color: Colors.white)),
        elevation: 0.0,
      ),
      body: _showMedia(),
      floatingActionButton: Visibility(
        visible: widget.isMovie,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            if(widget.isMovie) {
              setState(() {
                // 영상이 재생 중이라면, 일시 중지 시킵니다.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            }
          },
          // 플레이어의 상태에 따라 올바른 아이콘을 보여줍니다.
          child: (widget.isMovie)
              ? Icon(_controller.value.isPlaying ? Icons.pause
              : Icons.play_arrow,) : const Icon(Icons.close),
        ),
      ), // 이 마지막 콤마는 build 메서드에 자동 서식이 잘 적용될 수 있도록 도와줍니다.
    );
  }
}
