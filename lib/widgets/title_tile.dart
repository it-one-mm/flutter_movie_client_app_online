import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget {
  TitleTile({
    this.title = '',
    this.onPressed,
  });

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20.0),
      title: Text(title),
      trailing: Transform.translate(
        offset: Offset(5, 0),
        child: IconButton(
          onPressed: onPressed,
          splashRadius: 25.0,
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
