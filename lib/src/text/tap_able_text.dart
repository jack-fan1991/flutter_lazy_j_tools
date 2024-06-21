import 'package:flutter/material.dart';

class TapAbleText extends StatelessWidget {
  final String prefix;
  final String tapString;
  final VoidCallback? onTap;
  final Color? tapTextColor;
  final String middleString;
  final MainAxisAlignment mainAxisAlignment;

  /// "{prefix}{middleString}{tapString}"
  /// ```dart
  /// TapAbleText(prefix: "開啟連結", middleString: ":", tapString: "https//XXX.com",)
  /// ```
  const TapAbleText(
      {super.key,
      required this.prefix,
      required this.tapString,
      this.onTap,
      this.tapTextColor,
      this.middleString = " ",
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Text(prefix),
        Text(middleString),
        GestureDetector(
          child: Text(
            tapString,
            style: TextStyle(
              color: tapTextColor ?? Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: tapTextColor, // Update the underline color here
            ),
          ),
          onTap: () => onTap?.call(),
        ),
      ],
    );
  }
}
