import 'package:flutter/material.dart';

class AutoSizeDraggleAbleWidget extends StatefulWidget {
  final Widget child;
  final ShapeBorder? shape;
  final Color? backgroundColor;

  const AutoSizeDraggleAbleWidget(
      {super.key, required this.child, this.shape, this.backgroundColor});

  @override
  State<AutoSizeDraggleAbleWidget> createState() =>
      _AutoSizeDraggleAbleWidgetState();
}

class _AutoSizeDraggleAbleWidgetState extends State<AutoSizeDraggleAbleWidget> {
  Size? childSize;
  Widget? autoSizeChild;
  bool isOverflow = false;
  bool isAutoSizeDone = false;
  late final double screenHeight;
  final key = UniqueKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.of(context).size;
      screenHeight = size.height;
      setState(() {
        autoSizeChild = CustomMultiChildLayout(
            delegate: _BottomSheetChildLayoutDelegate(
                availableSize: size,
                onChildLayout: (initChildSize) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    isOverflow = initChildSize.height >= screenHeight;
                    if (isOverflow) {
                      childSize = Size(initChildSize.width, screenHeight);
                    } else {
                      childSize = initChildSize;
                    }
                    isAutoSizeDone = true;
                    setState(() {});
                  });
                }),
            children: [LayoutId(id: "AutoSizeChild", child: widget.child)]);
      });
    });

    super.initState();
  }

  Widget _warpChild({required Widget? child}) => Container(
      decoration: ShapeDecoration(
          color: widget.backgroundColor,
          shape: widget.shape ??
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      child: child);

  Widget buildChild() {
    if (!isAutoSizeDone) {
      return SizedBox(height: 100, child: _warpChild(child: autoSizeChild));
    }
    final Size size = childSize!;
    if (isOverflow) {
      return DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.4,
        maxChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return _warpChild(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              child: widget.child,
            ),
          );
        },
      );
    }
    return SizedBox(
        height: size.height, child: _warpChild(child: autoSizeChild));
  }

  @override
  Widget build(BuildContext context) {
    return buildChild();
    GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pop(),
        child: buildChild());
    // AnimatedSize(
    //     duration: const Duration(milliseconds: 300),
    //     child: SizedBox(
    //         key: key,
    //         height: isAutoSizeDone ? double.infinity : 10,
    //         child: buildChild()));
  }
}

class _BottomSheetChildLayoutDelegate extends MultiChildLayoutDelegate {
  final Size availableSize;
  Size? childSize;
  final Function(Size childSize)? onChildLayout;
  _BottomSheetChildLayoutDelegate(
      {required this.availableSize, this.onChildLayout});

  @override
  void performLayout(Size size) {
    if (hasChild("AutoSizeChild")) {
      childSize = layoutChild(
          "AutoSizeChild",
          BoxConstraints(
              maxHeight: availableSize.height, maxWidth: availableSize.width));
      onChildLayout?.call(childSize!);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
