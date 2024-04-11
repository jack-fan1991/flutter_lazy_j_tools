import 'package:flutter/material.dart';
import 'package:flutter_lazy_j_tools/src/utils/color_helper.dart';

import 'abs_picker.dart';

class StringPicker extends Picker<String> {
  StringPicker(
      {super.key,
      required PickerData pickerData,
      required String initValue,
      Function(int)? itemIndexCallBack,
      Function(String)? itemValueCallBack,
      double? itemExtent,
      String? unit,
      bool? showScrollbar})
      : super(
            pickerData: pickerData,
            unit: unit,
            initValue: initValue,
            itemIndexCallBack: itemIndexCallBack,
            itemValueCallBack: itemValueCallBack,
            itemExtent: itemExtent,
            showScrollbar: showScrollbar);

  @override
  void generatePickData() {}

  @override
  void setupController() {
    scrollControllersMap["StringPicker"] =
        FixedExtentScrollController(initialItem: indexOfPicker(initValue));
  }

  @override
  Widget? buildChildOrDefault(
      BuildContext context, double maxHeight, double maxWidth,
      {required PickerChildBuilder defaultChild}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: pickerData.itemDisplayList.length,
        itemBuilder: (_, i) {
          return InkWell(
              onTap: () {
                itemIndexCallBack?.call(i);
                itemValueCallBack?.call(pickerData.itemDisplayList[i]);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: i == 0
                    ? const BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 0.0, color: ColorHelper.LightGrey),
                            bottom: BorderSide(
                                width: 0.0, color: ColorHelper.LightGrey)))
                    : const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.0, color: ColorHelper.LightGrey))),
                width: maxWidth,
                height: itemExtent,
                child: Center(
                  child: Text(pickerData.itemDisplayList[i],
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ));
        });
  }
}
