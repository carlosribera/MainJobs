import 'package:flutter/cupertino.dart';

Widget TextWidget({
  required String text,
  required double textSize,
  required Color color,
}) {
  return Text(text,
      style: TextStyle(
        fontSize: textSize,
        color: color,
      ));
}
