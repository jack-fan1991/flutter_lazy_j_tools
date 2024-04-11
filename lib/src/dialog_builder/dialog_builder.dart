import 'dart:async';

import 'package:flutter/material.dart';
import 'auto_size_draggle_able_widget.dart';

enum DialogStyle { dialog, bottomSheet }

enum ChildType {
  none,
  fitChild,
}

abstract class BaseDialogBuilder {
  final Key? key;
  Color? bgColor;
  Color? strColor;
  DialogStyle dialogStyle;
  BuildContext context;
  double? dialogHeight;
  double? dialogWidth;
  Widget child;
  String? dialogTitle;
  ChildType childType;
  double maxRatio;
  late bool enableDrag;
  late bool barrierDismissible;
  ShapeBorder? shape =
      const RoundedRectangleBorder(borderRadius: BorderRadius.zero);

  BaseDialogBuilder({
    required this.context,
    this.key,
    double? dialogHeight,
    double? dialogWidth,
    Color? bgColor,
    Color? strColor,
    bool? enableDrag,
    bool? barrierDismissible,
    this.child =
        const SizedBox(width: 100, height: 100, child: Text("no Child")),
    this.dialogTitle = "",
    this.childType = ChildType.fitChild,
    this.dialogStyle = DialogStyle.bottomSheet,
    this.maxRatio = 0.9,
  }) {
    this.strColor = strColor ?? Theme.of(context).primaryColor;
    childType = dialogHeight == null && dialogWidth == null
        ? ChildType.fitChild
        : ChildType.none;
    this.dialogHeight = dialogHeight ?? 0.0;
    this.dialogWidth = dialogWidth ?? 0.0;
    this.barrierDismissible = barrierDismissible ?? true;
    this.enableDrag = enableDrag ?? true;
  }

  setBgColor(Color bgColor) {
    this.bgColor = bgColor;
  }

  setDialogTitle(String dialogTitle) {
    this.dialogTitle = dialogTitle;
  }

  setStrColor(Color strColor) {
    this.strColor = strColor;
  }

  setChild(Widget child) {
    this.child = child;
  }

  setShape(ShapeBorder? shape) {
    this.shape = shape ??
        const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ));
  }

  setMaxRatio(double maxRatio) {
    this.maxRatio = maxRatio;
  }

  buildDialog() async {
    var result = await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext _context) {
          return UnconstrainedBox(
              constrainedAxis: Axis.vertical,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: bgColor,
                shape: shape,
                child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(_context).size.width * maxRatio,
                        maxHeight:
                            MediaQuery.of(_context).size.height * maxRatio),
                    width: childType == ChildType.fitChild ? null : dialogWidth,
                    height:
                        childType == ChildType.fitChild ? null : dialogHeight,
                    child: child),
              ));
        });
    return result;
  }

  buildBottomSheet() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: shape,
      isDismissible: barrierDismissible,
      enableDrag: enableDrag,
      context: context,
      builder: (_context) {
        return AutoSizeDraggleAbleWidget(
            backgroundColor: bgColor ?? Theme.of(context).backgroundColor,
            shape: shape,
            child: SingleChildScrollView(child: child));
      },
    );
  }

  Future<T?> show<T>({required DialogStyle dialogStyle}) async {
    T? result;
    final k = key ?? child.key;
    if (keyCache.contains(key)) {
      return null;
    }
    if (k != null && !keyCache.contains(k)) {
      keyCache.add(k);
    }
    switch (dialogStyle) {
      case DialogStyle.dialog:
        result = await buildDialog();
        break;
      case DialogStyle.bottomSheet:
        result = await buildBottomSheet();
        break;
    }
    keyCache.remove(k);
    return result;
  }
}

final keyCache = <Key>{};

extension CustomersDialog on DialogStyle {
  /// If [key] !=null or [child] has a key, it will be cached, and the same key will not be displayed repeatedly
  Future<T?> show<T>(
      {required context,
      required Widget child,
      Key? key,
      double? dialogHeight,
      double? dialogWidth,
      String? dialogTitle,
      Color? bgColor,
      ShapeBorder? shape,
      double? maxRatio,
      bool? enableDrag,
      bool? barrierDismissible}) async {
    final builder = CommonDialogBuilder(
        context: context,
        key: key,
        dialogHeight: dialogHeight,
        dialogWidth: dialogWidth,
        child: child,
        dialogTitle: dialogTitle,
        bgColor: bgColor,
        enableDrag: enableDrag,
        barrierDismissible: barrierDismissible)
      ..setMaxRatio(maxRatio ?? 0.8)
      ..setShape(shape);
    return await builder.show<T>(dialogStyle: this);
  }

  bool isShow(Key key) => keyCache.contains(key);
}

class CommonDialogBuilder extends BaseDialogBuilder {
  CommonDialogBuilder(
      {required context,
      required Widget child,
      Key? key,
      double? dialogHeight,
      double? dialogWidth,
      String? dialogTitle,
      Color? bgColor,
      bool? enableDrag,
      bool? barrierDismissible})
      : super(
            key: key ?? child.key,
            context: context,
            dialogHeight: dialogHeight,
            dialogWidth: dialogWidth,
            child: child,
            dialogTitle: dialogTitle,
            bgColor: bgColor,
            enableDrag: enableDrag,
            barrierDismissible: barrierDismissible);
}
