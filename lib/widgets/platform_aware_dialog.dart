import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatFormAwareDialog extends StatelessWidget {
  PlatFormAwareDialog({
    this.title = 'No title',
    this.content = 'No Content',
    this.contentWidget,
    this.actions = const [],
  });

  final String title;
  final String content;
  final Widget contentWidget;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final imageFilter = ImageFilter.blur(sigmaX: 6, sigmaY: 6);
    return Platform.isIOS
        ? BackdropFilter(
            filter: imageFilter,
            child: CupertinoAlertDialog(
              title: Text(title),
              content: content == 'No Content' ? contentWidget : Text(content),
              actions: [
                ...actions,
              ],
            ),
          )
        : BackdropFilter(
            filter: imageFilter,
            child: AlertDialog(
              title: Text(title),
              content: content == 'No Content' ? contentWidget : Text(content),
              actions: [
                ...actions,
              ],
            ),
          );
  }
}
