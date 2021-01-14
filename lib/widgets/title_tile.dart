import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget {
  TitleTile({
    this.title = '',
    this.onPressed,
    this.titleStyle,
  });

  final String title;
  final Function onPressed;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20.0),
      title: Text(title, style: titleStyle ?? null),
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
