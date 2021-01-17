import 'package:flutter/material.dart';
import 'my_image_card.dart';
import '../utils/constants.dart';

class MyCard extends StatelessWidget {
  MyCard({
    @required this.length,
    @required this.index,
    this.imageUrl = '',
    this.onTap,
  }) : assert(length != null, index != null);

  final int length;
  final int index;
  final String imageUrl;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: index == 0 ? kLeftScreenSpace : kCardSpacing,
          right: length - 1 == index ? kLeftScreenSpace : 0,
        ),
        width: kCardWidth,
        child: MyImageCard(
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
