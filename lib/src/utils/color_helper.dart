// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';

extension TextColor on ColorHelper {
  bool _isLight(Brightness brightness) => Brightness.light == brightness;
  // Text預設的顏色
  Color? defaultTextColor(Brightness brightness) =>
      _isLight(brightness) ? Colors.black : ColorHelper.LightestGrey;
  Color background(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.LightestGrey : ColorHelper.DarkestGrey;
  Color? titleLarge(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkestGrey : ColorHelper.LightestGrey;
  Color? titleMedium(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkerGrey : ColorHelper.LighterGrey;
  Color? titleSmall(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkGrey : ColorHelper.LightGrey;
  Color? bodyLarge(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkestGrey : ColorHelper.LightestGrey;
  Color? displayMedium(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkerGrey : ColorHelper.LighterGrey;
  Color? bodySmall(Brightness brightness) =>
      _isLight(brightness) ? ColorHelper.DarkGrey : ColorHelper.LightGrey;
}

class ColorHelper {
  ColorHelper._internal();

  factory ColorHelper() => _instance;

  static late final ColorHelper _instance = ColorHelper._internal();

  //Grey
  static const LightestGrey = Color(0xFFF8FAFC);
  static const LighterGrey = Color(0xFFE9EDEF);
  static const LightGrey = Color(0xFFD1D7DD);
  static const LightGreyBorder = Color(0xFFE3E6EA);
  static const Grey = Color(0xFFA3ABB2);
  static const DarkGrey = Color(0xFF686E74);
  static const DarkerGrey = Color(0xFF3C4145);
  static const DarkestGrey = Color(0xFF1D1F20);
  static const AppLogoTextGrey = Color(0xFF4C4948);
  static const BackgroundGrey = Color(0xFFF7F7F7);

  //Green
  static const LightestGreen = Color(0xFFD3ECDB);
  static const LighterGreen = Color(0xFFACD3B7);
  static const LightGreen = Color(0xFF7CB38D);
  static const Green = Color(0xFF57916E);
  static const DarkGreen = Color(0xFF36764F);
  static const DarkerGreen = Color(0xFF255F44);
  static const DarkestGreen = Color(0xFF1B4230);

  //Gold
  static const LightestGold = Color(0xFFFBFAF2);
  static const LighterGold = Color(0xFFEEE8CB);
  static const LightGold = Color(0xFFE1D8AD);
  static const Gold = Color(0xFFD4CA9E);
  static const DarkGold = Color(0xFFBFB58C);
  static const DarkerGold = Color(0xFFA59D79);
  static const DarkestGold = Color(0xFF817A5D);

  //Gold
  static const LightestRoseGold = Color(0xFFFAF5ED);
  static const LighterRoseGold = Color(0xFFF0E2CE);
  static const LightRoseGold = Color(0xFFE6D3B9);
  static const RoseGold = Color(0xFFCFBBA1);
  static const DarkRoseGold = Color(0xFFBEA88B);
  static const DarkerRoseGold = Color(0xFFA68C74);
  static const DarkestRoseGold = Color(0xFF90776B);

  //Orange
  static const LightestOrange = Color(0xFFFFF9EE);
  static const LighterOrange = Color(0xFFFFD784);
  static const LightOrange = Color(0xFFFFC349);
  static const Orange = Color(0xFFF7AC15);
  static const DarkOrange = Color(0xFFE07612);
  static const DarkerOrange = Color(0xFF7D4007);
  static const DarkestOrange = Color(0xFF57300A);

  //Red
  static const LightestRed = Color(0xFFFFF6F5);
  static const LighterRed = Color(0xFFFFB6A8);
  static const LightRed = Color(0xFFFF9884);
  static const Red = Color(0xFFEA5E2E);
  static const DarkRed = Color(0xFFD23A07);
  static const DarkerRed = Color(0xFF862200);
  static const DarkestRed = Color(0xFF491300);

  //Blue
  static const LighterBlue = Color(0xFFE6F6FF);
  static const LightBlue = Color(0xFF3AB3E2);
  static const Blue = Color(0xFF078ABC);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
