import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/my_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MyRouter.LOADING_SCREEN,
      onGenerateRoute: MyRouter.onGenerateRoute,
    );
  }
}
