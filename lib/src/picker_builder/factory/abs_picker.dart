import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Fast sample
/// ```
/// PickerData pickerData=  PickerData( [1,2,3,4,5], ["星期一","星期二","星期三","星期四","星期五"])
/// pickerData.valueList = [1,2,3,4,5]
/// pickerData.itemList = ["星期一","星期二","星期三","星期四","星期五"]
/// ```
class PickerData<T> {
  final List<T> valueList;
  final List<String> itemDisplayList;
  PickerData({
    required this.valueList,
    required this.itemDisplayList,
  }) : assert(valueList.length == itemDisplayList.length ||
            (valueList.length + itemDisplayList.length) == 0);

  factory PickerData.empty() => PickerData(
        valueList: [],
        itemDisplayList: [],
      );

  /// ```
  /// PickerData pickerData=  PickerData.startEnd(0, 5)
  /// pickerData.valueList = [0,1,2,3,4,5]
  /// pickerData.itemList = ["0","1","2","3","4","5"]
  /// ```
  static PickerData<int> startEnd(int start, int end) {
    List<int> valueList;
    valueList = [for (var i = start; i < end + 1; i += 1) i];
    return PickerData(
      valueList: valueList,
      itemDisplayList: valueList.map((e) => e.toString()).toList(),
    );
  }

  bool get isEmpty => valueList.length + itemDisplayList.length == 0;
  T findValue(String displayName) =>
      valueList[itemDisplayList.indexOf(displayName)];

  T valueAt(int idx) => valueList[idx];

  String findDisplayName(T value) => itemDisplayList[valueList.indexOf(value)];

  String displayNameAt(int idx) => itemDisplayList[idx];

  int indexOfItemsValueList(T value) => valueList.indexOf(value);

  int indexOfItemsDisplayNameList(String displayName) =>
      itemDisplayList.indexOf(displayName);
}

mixin  PickerSetupMixin<T> {
  double getTotalSpace({int? maxItem});
  void setupController();
  void generatePickData();
  T setup();
}

typedef PickerChildBuilder = Widget Function(
    BuildContext context, double maxHeight, double maxWidth);

abstract class Picker<T> extends StatefulWidget with PickerSetupMixin<T> {
  final MainAxisAlignment mainAxisAlignment;
  final T initValue;
  final String? unit;
  final Color? bgColor;
  final double? itemExtent;
  final double paddingAll;
  final bool reverse;
  final bool? showScrollbar;
  final bool looping;
  final PickerData<dynamic> pickerData;
  final Function(int)? itemIndexCallBack;
  final Function(T)? itemValueCallBack;
  final Map<String, FixedExtentScrollController> scrollControllersMap = {};
  Picker({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    required this.initValue,
    this.unit,
    this.bgColor,
    this.itemExtent = 50,
    this.paddingAll = 4.0,
    this.showScrollbar = false,
    this.looping = false,
    this.reverse = false,
    required this.pickerData,
    this.itemIndexCallBack,
    this.itemValueCallBack,
  });

  @override
  State<Picker<T>> createState() => _PickerState<T>();

  int indexOfPicker(String value) => pickerData.itemDisplayList.indexOf(value);

  @override
  double getTotalSpace({int? maxItem}) {
    if (maxItem == null) {
      return itemExtent! * pickerData.itemDisplayList.length;
    } else {
      return itemExtent! * min(maxItem, pickerData.itemDisplayList.length);
    }
  }

  Widget? buildChildOrDefault(
      BuildContext context, double maxHeight, double maxWidth,
      {required PickerChildBuilder defaultChild});
  @override
  T setup() {
    generatePickData();
    setupController();
    return initValue!;
  }
}

class _PickerState<T> extends State<Picker<T>> {
  T? selectValue;
  late int selectIndex = 0;
  late String unit;
  late PickerData pickerData;

  @override
  void initState() {
    super.initState();
    selectValue = widget.setup();
    unit = widget.unit ?? "";
  }

  Widget defaultPicker(
      BuildContext context, double maxHeight, double maxWidth) {
    return CupertinoPicker(
      useMagnifier: true,
      magnification: 1.0,
      backgroundColor: widget.bgColor ?? Theme.of(context).backgroundColor,
      itemExtent: widget.itemExtent!,
      onSelectedItemChanged: (int index) {
        selectIndex = index;
      },
      looping: widget.looping,
      children: widget.pickerData.itemDisplayList.map((e) {
        int idx = pickerData.itemDisplayList.indexOf(e);
        return GestureDetector(
          onTap: () => widget.itemIndexCallBack?.call(selectIndex),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        widget.pickerData.itemDisplayList[idx].toString(),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      )))
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget layoutBuilderChild(
      BuildContext context, double maxHeight, double maxWidth) {
    return Row(
      children: <Widget>[
        Expanded(child: defaultPicker(context, maxHeight, maxWidth)),
        unit.isEmpty ? const SizedBox() : Text(unit)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: <Widget>[
          Expanded(
            child: widget.buildChildOrDefault(
                context, constraints.maxHeight, constraints.maxWidth,
                defaultChild: defaultPicker)!,
          ),
          unit.isEmpty ? const SizedBox() : Text(unit)
        ],
      );
    });
  }
}
