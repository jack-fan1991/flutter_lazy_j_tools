// import 'package:flutter/material.dart';
// import 'package:owl_mobile_dart_extension/src/ui_utils/picker_builder/picker_builder.dart';

// import 'abs_picker.dart';

// class IntPicker extends Picker<int> {
//   final int start;
//   final int end;

//   IntPicker(
//       {super.key,
//       required this.start,
//       required this.end,
//       required int initValue,
//       Function(int)? itemIndexCallBack,
//       ItemValueCallBack? itemValueCallBack,
//       double? itemExtent,
//       String? unit,
//       bool? showScrollbar})
//       : super(
//             pickerData: PickerData.startEnd(start, end),
//             unit: unit,
//             initValue: initValue,
//             itemIndexCallBack: itemIndexCallBack,
//             itemValueCallBack: itemValueCallBack,
//             itemExtent: itemExtent,
//             showScrollbar: showScrollbar);

//   @override
//   void generatePickData() {
//     // List<int> valueList;
//     // if (reverse) {
//     //   valueList = [for (int i = end; i >= start; i -= 1) i];
//     // } else {
//     //   valueList = [for (var i = start; i < end + 1; i += 1) i];
//     // }
//     // pickerData = PickerData(
//     //   valueList: valueList,
//     //   pickerList: valueList.map((e) => e.toString()).toList(),
//     // );
//   }

//   @override
//   void setupController() {
//     scrollControllersMap["int"] = FixedExtentScrollController(
//         initialItem: indexOfPicker(initValue.toString()));
//   }

//   @override
//   Widget? buildChildOrDefault(
//       BuildContext context, double maxHeight, double maxWidth,
//       {required PickerChildBuilder defaultChild}) {
//     return null;
//   }
// }
