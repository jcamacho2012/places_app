import 'package:flutter/material.dart';

showSnackBar(
    {required BuildContext context,
    required String message,
    required Icon icon,
    required Color backgroundColor}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(message),
          ],
        )),
  );
}
