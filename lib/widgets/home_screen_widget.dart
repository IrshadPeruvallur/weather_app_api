import 'dart:ui';

import 'package:flutter/material.dart';

Widget WidgetText(String data, {Color? clr, double? fz, FontWeight? fw}) {
  return Text(
    data,
    style: TextStyle(
      color: clr,
      fontSize: fz,
      fontWeight: fw,
    ),
  );
}

Widget TempIconWidget(context, imagePath, IconName, value,
    {double? imageSize}) {
  Size size = MediaQuery.of(context).size;

  return Row(
    children: [
      Image(
        image: AssetImage(imagePath),
        width: imageSize,
      ),
      SizedBox(
        width: size.width * .015,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WidgetText(IconName, fw: FontWeight.w700, fz: size.width * .035),
          WidgetText(value, fz: size.width * .05, fw: FontWeight.w700),
        ],
      )
    ],
  );
}
