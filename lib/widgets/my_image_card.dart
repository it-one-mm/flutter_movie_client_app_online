import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MyImageCard extends StatelessWidget {
  MyImageCard({this.imageUrl}) : assert(imageUrl != null);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
          return Center(
            child: Text(
              kErrorLoadingImageText,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      elevation: 5,
    );
  }
}
