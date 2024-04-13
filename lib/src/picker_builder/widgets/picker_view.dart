import 'package:flutter/material.dart';
import '../factory/abs_picker.dart';
import '../factory/string_picker.dart';
export '../factory/abs_picker.dart';
export '../factory/int_picker.dart';
export '../factory/string_picker.dart';
export '../picker_builder_mixin.dart';

typedef ItemIndexCallBack = Function(int);

typedef PickerCallBack<T> = void Function(T? value, String displayName);

/// Maintain the UI outside the picker
class PickerView extends StatelessWidget {
  final Picker picker;
  final double titleTopPadding = 15;
  final double titleBottomPadding = 10;

  /// Default style is Theme.of(context).textTheme.titleLarge
  final String? title;

  /// Default use Theme.of(context).dialogBackgroundColor
  final Color? backGroundColor;

  final Widget Function(String title, TextStyle? defaultStyle)? titleBuilder;

  const PickerView({
    Key? key,
    required this.picker,
    this.title,
    this.backGroundColor,
    required this.titleBuilder,
  }) : super(key: key);

  // factory PickerView.intPicker(
  //     {required int start,
  //     required int end,
  //     int? initValue,
  //     Function(int)? itemIndexCallBack,
  //     ItemValueCallBack? itemValueCallBack,
  //     double? itemExtent,
  //     String? title,
  //     bool? showScrollbar,
  //     Color? backGroundColor}) {
  //   IntPicker picker = IntPicker(
  //     start: start,
  //     end: end,
  //     initValue: initValue ?? start,
  //     itemIndexCallBack: itemIndexCallBack,
  //     itemValueCallBack: itemValueCallBack,
  //     itemExtent: itemExtent,
  //     showScrollbar: showScrollbar,
  //   );
  //   return PickerView(
  //     picker: picker,
  //     title: title,
  //     backGroundColor: backGroundColor,
  //   );
  // }

  factory PickerView.stringPicker({
    required PickerData pickerData,
    String? initValue,
    Function(int)? itemIndexCallBack,
    Function(String)? itemValueCallBack,
    double? itemExtent,
    String? title,
    bool? showScrollbar,
    Color? backGroundColor,
    Widget Function(String title, TextStyle? defaultStyle)? titleBuilder,
  }) {
    StringPicker picker = StringPicker(
        pickerData: pickerData,
        initValue: initValue ?? pickerData.itemDisplayList.first,
        itemIndexCallBack: itemIndexCallBack,
        itemValueCallBack: itemValueCallBack,
        itemExtent: itemExtent,
        showScrollbar: showScrollbar);
    return PickerView(
      picker: picker,
      title: title,
      backGroundColor: backGroundColor,
      titleBuilder: titleBuilder,
    );
  }
  double get titleSpace => (title == null ? 0 : picker.itemExtent) ?? 0;

  double getTotalSpace({int? maxItem}) =>
      titleSpace +
      picker.getTotalSpace(maxItem: maxItem) +
      0.5 * picker.itemExtent!;

  Widget buildTitle(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleLarge;
    if (titleBuilder != null) {
      return titleBuilder!(title!, defaultStyle);
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: titleTopPadding,
          bottom: titleBottomPadding,
        ),
        child: Text(title!, style: defaultStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor ?? Theme.of(context).dialogBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title == null ? const SizedBox() : buildTitle(context),
          picker
        ],
      ),
    );
  }
}
