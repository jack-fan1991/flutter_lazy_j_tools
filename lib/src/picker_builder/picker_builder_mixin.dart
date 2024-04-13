import 'dart:math';

import 'package:flutter/material.dart';
import '../dialog_builder/dialog_builder.dart';
import 'widgets/picker_view.dart';

mixin StringBottomSheetPickerMixin {
  showStringPicker({
    required BuildContext context,
    required PickerData pickerData,
    ItemIndexCallBack? itemIndexCallBack,
    void Function(String)? itemValueCallBack,
    String? initValue,
    double? itemExtent,
    ShapeBorder? dialogShape,
    String? title,
    double? maxDialogRatio,
    bool? showScrollbar,
    int? maxPickerItems,
    Color? backgroundColor,
  }) {
    PickerView pickerBuilder = PickerView.stringPicker(
      pickerData: pickerData,
      initValue: initValue,
      itemIndexCallBack: itemIndexCallBack,
      itemValueCallBack: itemValueCallBack,
      itemExtent: itemExtent,
      title: title,
      showScrollbar: showScrollbar,
      backGroundColor: backgroundColor,
    );

    double pickerHeight = pickerBuilder.getTotalSpace(maxItem: maxPickerItems);
    DialogStyle.bottomSheet.show(
        dialogHeight: min(pickerHeight, MediaQuery.of(context).size.height),
        context: context,
        child: pickerBuilder,
        shape: dialogShape,
        maxRatio: maxDialogRatio);
  }
}
