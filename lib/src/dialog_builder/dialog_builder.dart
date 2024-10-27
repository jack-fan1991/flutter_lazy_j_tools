import 'dart:async';

import 'package:flutter/material.dart';
import 'auto_size_draggle_able_widget.dart';

Color dialogBackgroundColor = Colors.transparent;
Color bottomSheetBackgroundColor = Colors.transparent;
bool kDialogStyleBarrierDismissible = true;

enum DialogStyle {
  dialog,
  bottomSheet;

  const DialogStyle();
}

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

  buildDialog({
    bool showBackGroundClose = false,
    Function()? onClose,
  }) async {
    var result = await showDialog(
      barrierDismissible: kDialogStyleBarrierDismissible && barrierDismissible,
      context: context,
      builder: (BuildContext _context) {
        return Stack(
          children: [
            if (showBackGroundClose)
              Positioned(
                top: 8.0,
                right: 8.0,
                child: GestureDetector(
                  onTap: () {
                    onClose?.call();
                    Navigator.of(_context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.grey, size: 30),
                ),
              ),
            // 主对话框内容
            Center(
              child: UnconstrainedBox(
                constrainedAxis: Axis.vertical,
                child: Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: bgColor ?? dialogBackgroundColor,
                  shape: shape,
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(_context).size.width * maxRatio,
                          maxHeight:
                              MediaQuery.of(_context).size.height * maxRatio,
                        ),
                        width: childType == ChildType.fitChild
                            ? null
                            : dialogWidth,
                        height: childType == ChildType.fitChild
                            ? null
                            : dialogHeight,
                        child: child,
                      ),
                      if (!showBackGroundClose)
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              onClose?.call();
                              Navigator.of(_context).pop();
                            },
                            child: Icon(Icons.close, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    return result;
  }

  void buildOverlayDialog({
    required BuildContext context,
    bool showBackGroundClose = false,
    Function()? onClose,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            if (kDialogStyleBarrierDismissible && barrierDismissible) {
              overlayEntry.remove(); // 點擊背景時關閉對話框
            }
          },
          child: Container(
            color: Colors.black87,
            child: Stack(
              children: [
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Dialog(
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: bgColor ?? dialogBackgroundColor,
                      shape: shape,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * maxRatio,
                          maxHeight:
                              MediaQuery.of(context).size.height * maxRatio,
                        ),
                        width: childType == ChildType.fitChild
                            ? null
                            : dialogWidth,
                        height: childType == ChildType.fitChild
                            ? null
                            : dialogHeight,
                        child: child,
                      ),
                    ),
                  ),
                ),
                if (showBackGroundClose)
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white), // "X" 按鈕
                      onPressed: () {
                        overlayEntry.remove();
                        onClose?.call();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
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
            backgroundColor: bgColor ?? bottomSheetBackgroundColor,
            shape: shape,
            child: SingleChildScrollView(child: child));
      },
    );
  }

  Future<T?> show<T>({
    required BuildContext context,
    required DialogStyle dialogStyle,
    bool showBackGroundClose = false,
    bool topLevel = false,
    Function()? onClose,
  }) async {
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
        if (topLevel) {
          buildOverlayDialog(
            context: context,
            showBackGroundClose: showBackGroundClose,
            onClose: onClose,
          );
        } else {
          result = await buildDialog(
            showBackGroundClose: showBackGroundClose,
            onClose: onClose,
          );
        }

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
  /// If [key] !=null or [child] has a key,
  /// it will be cached, and the same key will not be displayed repeatedly
  Future<T?> show<T>({
    required context,
    required Widget child,
    Key? key,
    double? dialogHeight,
    double? dialogWidth,
    String? dialogTitle,
    Color? bgColor,
    ShapeBorder? shape,
    double? maxRatio,
    bool? enableDrag,
    bool? barrierDismissible,
    bool showBackGroundClose = false,
    Function()? onClose,
    bool topLevel = false,
  }) async {
    final builder = CommonDialogBuilder(
        context: context,
        key: key,
        dialogHeight: dialogHeight,
        dialogWidth: dialogWidth,
        child: child,
        dialogTitle: dialogTitle,
        bgColor: bgColor,
        enableDrag: enableDrag,
        barrierDismissible:
            (kDialogStyleBarrierDismissible && (barrierDismissible ?? false)))
      ..setMaxRatio(maxRatio ?? 0.8)
      ..setShape(shape);
    return await builder.show<T>(
      context: context,
      dialogStyle: this,
      showBackGroundClose: showBackGroundClose,
      onClose: onClose,
      topLevel: topLevel,
    );
  }

  /// If [key] !=null or [child] has a key,
  /// it will be cached, and the same key will not be displayed repeatedly
  Future<T?> showAsSingleton<T>({
    required context,
    required Widget child,
    required Key? key,
    double? dialogHeight,
    double? dialogWidth,
    String? dialogTitle,
    Color? bgColor,
    ShapeBorder? shape,
    double? maxRatio,
    bool? enableDrag,
    bool? barrierDismissible,
    bool showBackGroundClose = false,
    Function()? onClose,
    bool topLevel = false,
  }) async {
    return await show<T>(
      context: context,
      child: child,
      key: key,
      dialogHeight: dialogHeight,
      dialogWidth: dialogWidth,
      dialogTitle: dialogTitle,
      bgColor: bgColor,
      shape: shape,
      maxRatio: maxRatio,
      enableDrag: enableDrag,
      barrierDismissible: barrierDismissible,
      showBackGroundClose: showBackGroundClose,
      onClose: onClose,
      topLevel: topLevel,
    );
  }

  bool isShow(Key key) => keyCache.contains(key);

  void setBgColor(Color bgColor) {
    if (this == DialogStyle.dialog) {
      dialogBackgroundColor = bgColor;
    } else {
      bottomSheetBackgroundColor = bgColor;
    }
  }
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
