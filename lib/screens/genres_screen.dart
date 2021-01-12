import 'package:flutter/material.dart';
import '../widgets/my_drawer.dart';

class GenresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genres'),
      ),
      drawer: MyDrawer(),
    );
  }
}
