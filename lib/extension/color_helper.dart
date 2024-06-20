import 'dart:math';

import 'package:flutter/material.dart';

extension ColorHelper on Color {
  // Color darker(double amount) {
  //   return Color.fromARGB(
  //     alpha,
  //     (red * (1 - amount)).round(),
  //     (green * (1 - amount)).round(),
  //     (blue * (1 - amount)).round(),
  //   );
  // }

  Color darker(double amount) {
    final hsl = HSLColor.fromColor(this);

    final hslDark =
        hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

extension ComplementaryColor on Color {
  /// 找對比色
  Color getComplementaryColor() {
    // Calculate the hue of the color
    final hslColor = HSLColor.fromColor(this);
    final hue = hslColor.hue;

    // Calculate the hue of the complementary color (by adding 180 to the hue)
    final complementaryHue = (hue + 180) % 360;

    // Create a new HSLColor with the complementary hue and the same saturation and lightness
    final complementaryColorHSL = HSLColor.fromAHSL(hslColor.alpha,
        complementaryHue, hslColor.saturation, hslColor.lightness);

    // Convert the complementary color back to the RGB color space and return it
    return complementaryColorHSL.toColor();
  }

  /// 找對比色
  Color? convertOverlayColor(
    Color color, {
    double threshold = 0.4,
    Color? Function()? whenLight,
    Color? Function()? whenDark,
  }) {
    final double baseColorBrightness = color.computeLuminance();
    const double emphasisBrightness = 0.05; // 決定強調顏色亮度，越小越暗
    final double delta = baseColorBrightness - emphasisBrightness;
    final isColorLight = delta > threshold;
    return isColorLight
        ? whenLight?.call() ?? Colors.grey[900]
        : whenDark?.call() ?? Colors.grey[200];
  }
}

extension ColorDistance on Color {
  bool isCloseTo(Color other,
      {double threshold = 0.25, showThresholdTable = false}) {
    double distance = sqrt(pow(red - other.red, 2) +
        pow(green - other.green, 2) +
        pow(blue - other.blue, 2));
    double maxDistance = sqrt(pow(255, 2) * 3);
    bool isClose = distance / maxDistance < threshold;
    if (showThresholdTable) {
      debugPrint("--- Color Distance Table ---");
      debugPrint(
          "Test result : $threshold => isClose : ${isCloseTo(other, threshold: threshold)}");
      debugPrint("----------------------------");
      for (int i = 0; i < 100; i++) {
        final t = i / 100;
        debugPrint(
            "Threshold : $t => isClose : ${isCloseTo(other, threshold: t)}");
      }
    }

    return isClose;
  }
}
