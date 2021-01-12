import 'package:flutter/material.dart';
import '../widgets/spin_kit_double_bounce.dart';
import '../config/my_router.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    // Illustrate loading data
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacementNamed(context, MyRouter.HOME_SCREEN);
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
