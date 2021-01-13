import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/internet_handler.dart';
import '../models/series.dart';
import '../models/movie.dart';
import '../widgets/platform_aware_dialog.dart';
import '../widgets/spin_kit_double_bounce.dart';
import '../config/my_router.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    _sub?.cancel();

    super.dispose();
  }

  void _init() {
    // check internet connection
    InternetHandler.checkConnection(
      onSuccess: () {
        _sub = Stream.periodic(Duration(seconds: 1), (val) {
          final moviesList = context.read<List<Movie>>();
          final seriesList = context.read<List<Series>>();

          // Check all of the firestore data is loaded
          if (moviesList != null && seriesList != null) {
            Navigator.pushReplacementNamed(context, MyRouter.HOME_SCREEN);
          }
        }).listen((event) {});
      },
      onError: () {
        _sub?.cancel();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => PlatFormAwareDialog(
            title: 'Please check your Internet Connection!',
            contentWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  iconSize: 35.0,
                  onPressed: () async {
                    // Close the dialog
                    Navigator.pop(dialogContext);

                    await Future.delayed(Duration(seconds: 1));

                    _init();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          size: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
