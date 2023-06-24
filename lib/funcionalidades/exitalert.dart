import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// arquivo para criar widgets especificos para ios ou android

Exitalert(
    BuildContext context, {
      required String title,
      required String content,
      required String defaultActionText,
      String? cancelActionText,
    }) {
  if (!Platform.isIOS) {
    return _showMaterialAlertDialog(context,
        title: title, content: content, defaultActionText: defaultActionText, cancelActionText: 'Não sair');
  } else {
    return _showCupertinoAlertDialog(context,
        title: title, content: content, defaultActionText: defaultActionText, cancelActionText: 'Nâo sair');
  }
}

//android widgets
_showMaterialAlertDialog(
    BuildContext context, {
      required String title,
      required String content,
      required String defaultActionText,
      String? cancelActionText,
    }) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        ElevatedButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

//ios widgets
_showCupertinoAlertDialog(
    BuildContext context, {
      required String title,
      required String content,
      required String defaultActionText,
      String? cancelActionText,
    }) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}