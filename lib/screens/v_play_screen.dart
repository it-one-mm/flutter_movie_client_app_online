import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../config/service_locator.dart';
import '../services/movie_service.dart';

class VPlayScreen extends StatefulWidget {
  VPlayScreen({
    this.title = '',
    this.isMovie = false,
    this.movieId = '',
    @required this.path,
  }) : assert(path != null);

  final String title;
  final String path;
  final bool isMovie;
  final String movieId;

  @override
  _VPlayScreenState createState() => _VPlayScreenState();
}

class _VPlayScreenState extends State<VPlayScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _playError = false;
  String _videoUrl = '';

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
    'http://download1649.mediafire.com/u8z2navn572g/m59e4vi2zkhamqr/test2.mp4',
  ];

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    try {
      if (widget.isMovie) {
        await getIt<MovieService>().updateViewCount(widget.movieId);
      }

      final endPoint = 'https://mf-api.herokuapp.com';
      final response = await http
          .get('$endPoint?url=${widget.path}')
          .timeout(Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _videoUrl = data[0]['file'];
      }

      _videoPlayerController = VideoPlayerController.network(_videoUrl);
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

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0';
    } else {
      // IOS
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    // final directory = Platform.isAndroid
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    // return directory.path;
  }

  Future<void> _handleDownload() async {
    final permissionReady = await _checkPermission();

    if (permissionReady) {
      final localPath =
          (await _findLocalPath()) + Platform.pathSeparator + 'Download';

      final savedDir = Directory(localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      await FlutterDownloader.enqueue(
        url: _videoUrl,
        savedDir: localPath,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You have to allowed permission to Download.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
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
          if (!_playError &&
              _chewieController != null &&
              _chewieController.videoPlayerController.value.initialized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FlatButton(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_circle_down, color: Colors.black),
                    SizedBox(width: 5.0),
                    Text(
                      'Download',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                onPressed: _handleDownload,
              ),
            ),
        ],
      ),
    );
  }
}
