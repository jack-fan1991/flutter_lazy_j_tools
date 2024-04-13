import 'package:flutter/material.dart';
import 'package:flutter_lazy_j_tools/src/picker_builder/widgets/picker_view.dart';
import 'package:flutter_lazy_j_tools/src/utils/color_helper.dart';

typedef WidgetBuilder<T> = Widget Function(T? value, String displayName);

class SelectableItemWidget<VALUE_TYPE> extends StatefulWidget {
  final PickerData<VALUE_TYPE> pickerData;
  final String title;
  final double? maxDialogRatio;

  /// Maximum Displayed Items in Picker
  final int? maxPickerItems;
  final Color? pickerBackgroundColor;
  final Color? borderColor;

  /// The index of pickerData items witch want to be show first
  final int initIndex;

  /// If no initIndex setting show hint
  final String hint;
  final WidgetBuilder<VALUE_TYPE>? builder;
  final PickerCallBack<VALUE_TYPE>? onSelect;

  /// When picker init, trigger this callback
  final PickerCallBack<VALUE_TYPE>? onPickerInit;

  /// Tap action is pop a buttonSheet picker
  /// Provide default widget as SelectableItem
  /// Use [builder] replace widget with customer
  const SelectableItemWidget({
    Key? key,
    required this.pickerData,
    this.title = '',
    this.initIndex = 0,
    this.hint = "",
    this.maxDialogRatio,
    this.maxPickerItems,
    this.pickerBackgroundColor,
    this.borderColor,
    this.builder,
    this.onPickerInit,
    this.onSelect,
  }) : super(key: key);

  @override
  State<SelectableItemWidget> createState() =>
      _SelectableItemWidgetState<VALUE_TYPE>();
}

class _SelectableItemWidgetState<VALUE_TYPE>
    extends State<SelectableItemWidget<VALUE_TYPE>>
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
            maxPickerItems: widget.maxPickerItems);
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
