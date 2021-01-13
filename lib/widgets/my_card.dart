import 'package:flutter/material.dart';

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
          left: index == 0 ? 20.0 : 10.0,
          right: length - 1 == index ? 20.0 : 0.0,
        ),
        width: 100.0,
        child: Card(
          margin: EdgeInsets.all(0),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
              return Center(
                child: Text(
                  'Image Not Found!',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
