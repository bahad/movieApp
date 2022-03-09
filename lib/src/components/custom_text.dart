import 'package:flutter/material.dart';

enum Sizes {
  small,
  normal,
  big,
  title,
  sliverTitle,
}

class CustomText extends StatelessWidget {
  final Sizes? sizes;
  final String? text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final bool? lineLimit;
  // ignore: use_key_in_widget_constructors
  const CustomText(
      {this.text,
      this.color,
      this.sizes,
      this.textAlign,
      this.fontWeight,
      this.lineLimit});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Text(text!,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        maxLines: lineLimit == null ? 2 : 12,
        style: sizes == Sizes.normal
            ? TextStyle(
                color: color,
                fontWeight: fontWeight,
                fontSize: size.width < 390
                    ? 16
                    : size.width > 500
                        ? 24
                        : 18)
            : sizes == Sizes.title
                ? TextStyle(
                    color: color,
                    fontWeight: fontWeight,
                    fontSize: size.width < 390
                        ? 18
                        : size.width > 500
                            ? 26
                            : 20)
                : sizes == Sizes.small
                    ? TextStyle(
                        color: color,
                        fontWeight: fontWeight,
                        fontSize: size.width < 390
                            ? 14
                            : size.width > 500
                                ? 22
                                : 16)
                    : sizes == Sizes.sliverTitle
                        ? TextStyle(
                            color: color,
                            fontWeight: fontWeight,
                            fontSize: size.width < 390
                                ? 20
                                : size.width > 500
                                    ? 26
                                    : 22)
                        : TextStyle(
                            color: color,
                            fontWeight: fontWeight,
                            fontSize: size.width < 390
                                ? 16
                                : size.width > 500
                                    ? 24
                                    : 18));
  }
}
