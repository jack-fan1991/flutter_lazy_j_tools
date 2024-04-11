import 'package:flutter/material.dart';
import 'package:flutter_lazy_j_tools/src/utils/color_helper.dart';
import 'factory/abs_picker.dart';
import 'factory/string_picker.dart';
import 'picker_builder_mixin.dart';
export './factory/abs_picker.dart';
export './factory/int_picker.dart';
export './factory/string_picker.dart';
export './picker_builder_mixin.dart';

typedef ItemIndexCallBack = Function(int);

typedef PickerCallBack<T> = void Function(T? value, String displayName);
typedef WidgetBuilder<T> = Widget Function(T? value, String displayName);

class SelectableItem<VALUE_TYPE> extends StatefulWidget {
  final PickerData<VALUE_TYPE> pickerData;
  final String title;
  final double? maxDialogRatio;
  final int? maxItem;
  final String hint;
  final Color? pickerBackgroundColor;
  final Color? borderColor;
  final int initIndex;
  final WidgetBuilder<VALUE_TYPE>? builder;
  final PickerCallBack<VALUE_TYPE>? onSelect;
  final PickerCallBack<VALUE_TYPE>? onPickerInit;

  /// Tap action is pop a buttonSheet picker
  /// Provide default widget as SelectableItem
  /// Use [builder] replace widget with customer
  const SelectableItem({
    Key? key,
    required this.pickerData,
    this.title = '',
    this.initIndex = 0,
    this.maxDialogRatio,
    this.maxItem,
    this.hint = "",
    this.pickerBackgroundColor,
    this.borderColor,
    this.builder,
    this.onPickerInit,
    this.onSelect,
  }) : super(key: key);

  @override
  State<SelectableItem> createState() => _SelectableItemState<VALUE_TYPE>();
}

class _SelectableItemState<VALUE_TYPE> extends State<SelectableItem<VALUE_TYPE>>
    with StringBottomSheetPickerMixin {
  late PickerData<VALUE_TYPE> pickerData;
  late final int initIndex;
  late String displayName;
  late VALUE_TYPE? pickerValue;

  @override
  void initState() {
    pickerData = widget.pickerData;
    initIndex = widget.initIndex;
    displayName =
        pickerData.isEmpty ? widget.hint : pickerData.displayNameAt(initIndex);
    pickerValue = pickerData.isEmpty ? null : pickerData.valueAt(initIndex);
    widget.onPickerInit?.call(pickerValue, displayName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showStringPicker(
            context: context,
            pickerData: pickerData,
            itemValueCallBack: (displayName) => {
                  setState(() {
                    this.displayName = displayName;
                    pickerValue = pickerData.findValue(displayName);
                    widget.onSelect?.call(pickerValue, displayName);
                  })
                },
            title: widget.title,
            initValue: displayName,
            maxDialogRatio: widget.maxDialogRatio,
            itemExtent: 60,
            showScrollbar: true,
            backgroundColor: widget.pickerBackgroundColor,
            maxItem: widget.maxItem);
      },
      child: widget.builder?.call(pickerValue, displayName) ??
          DefaultChild(
              borderColor: widget.borderColor, displayName: displayName),
    );
  }
}

class DefaultChild extends StatelessWidget {
  const DefaultChild({
    Key? key,
    required this.borderColor,
    required this.displayName,
  }) : super(key: key);

  final Color? borderColor;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? ColorHelper.LightGrey),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
            displayName,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

/// Maintain the UI outside the picker
class PickerView extends StatelessWidget {
  final Picker picker;
  final double titleTopPadding = 15;
  final double titleBottomPadding = 10;
  final String? title;
  final Color? backGroundColor;
  final TextStyle titleStyle = const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700);
  const PickerView(
      {Key? key, required this.picker, this.title, this.backGroundColor})
      : super(key: key);

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

  factory PickerView.stringPicker(
      {required PickerData pickerData,
      String? initValue,
      Function(int)? itemIndexCallBack,
      Function(String)? itemValueCallBack,
      double? itemExtent,
      String? title,
      bool? showScrollbar,
      Color? backGroundColor}) {
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
    );
  }
  get titleSpace => title == null ? 0 : picker.itemExtent;

  double getTotalSpace({int? maxItem}) =>
      titleSpace +
      picker.getTotalSpace(maxItem: maxItem) +
      0.5 * picker.itemExtent!;

  Widget buildTitle(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: titleTopPadding,
          bottom: titleBottomPadding,
        ),
        child: Text(title!, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
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
