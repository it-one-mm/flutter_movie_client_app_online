import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VPlayScreen extends StatefulWidget {
  VPlayScreen({
    this.title = '',
    @required this.path,
  }) : assert(path != null);

  final String title;
  final String path;

  @override
  _VPlayScreenState createState() => _VPlayScreenState();
}

class _VPlayScreenState extends State<VPlayScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _playError = false;
  final _playErrorText = 'Oops cannot play video at this time!';

  final _errorTextStyle = TextStyle(
    fontSize: 22.0,
    color: Colors.redAccent,
  );

  List<String> videos = [
    'https://archive.org/download/SampleVideo1280x7205mb/SampleVideo_1280x720_5mb.mp4',
    'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4',
    'https://filesamples.com/samples/video/mp4/sample_640x360.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    '',
  ];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    try {
      _videoPlayerController = VideoPlayerController.network(videos[2]);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        errorBuilder: (context, error) {
          return Center(
            child: Text(
              '$_playErrorText',
              textAlign: TextAlign.center,
              style: _errorTextStyle,
            ),
          );
        },
      );

      _playError = false;
    } catch (e) {
      _playError = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
          Container(
            height: 220.0,
            child: _playError
                ? Center(
                    child: Text(
                      '$_playErrorText',
                      textAlign: TextAlign.center,
                      style: _errorTextStyle,
                    ),
                  )
                : _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.initialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text('Loading'),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
