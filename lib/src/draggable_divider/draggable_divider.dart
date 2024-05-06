import 'package:flutter/material.dart';

typedef DividerBuilder = Widget Function(BuildContext context);

class DragResizableDivider extends StatelessWidget {
  final bool draggable;
  final Function(double delta) onResize;
  final Axis dividerDirection;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  /// Default color Theme.of(context).dividerTheme.color
  final Color? color;
  final DividerBuilder? dividerBuilder;
  final bool debug;

  const DragResizableDivider(
      {super.key,
      this.draggable = true,
      required this.onResize,
      this.dividerDirection = Axis.vertical,
      this.height = 0,
      this.thickness = 2,
      this.indent = 0,
      this.endIndent = 0,
      this.color,
      this.dividerBuilder,
      this.debug = false});

  @override
  Widget build(BuildContext context) {
    final dividerTheme = Theme.of(context).dividerTheme;
    if (dividerDirection == Axis.horizontal) {
      return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          onResize(details.delta.dy);
        },
        child: Container(
          color: debug ? Colors.red.withOpacity(0.4) : Colors.transparent,
          child: MouseRegion(
            cursor: draggable
                ? SystemMouseCursors.resizeRow
                : SystemMouseCursors.basic,
            child: dividerBuilder?.call(context) ??
                Divider(
                  height: height ?? dividerTheme.space,
                  thickness: thickness ?? dividerTheme.thickness,
                  indent: indent ?? dividerTheme.indent,
                  endIndent: endIndent ?? dividerTheme.indent,
                  color: color ?? dividerTheme.color,
                ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          onResize(details.delta.dx);
        },
        child: Container(
          color: debug ? Colors.red : Colors.transparent,
          child: MouseRegion(
            cursor: draggable
                ? SystemMouseCursors.resizeColumn
                : SystemMouseCursors.basic,
            child: dividerBuilder?.call(context) ??
                VerticalDivider(
                  thickness: thickness ?? dividerTheme.thickness,
                  indent: indent ?? dividerTheme.indent,
                  endIndent: endIndent ?? dividerTheme.indent,
                  color: color ?? dividerTheme.color,
                ),
          ),
        ),
      );
    }
  }
}

class DragResizableDividerRow extends StatefulWidget {
  final double defaultWidth;
  final List<double> widthRange;
  final bool draggable;
  final Widget child;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final DividerBuilder? dividerBuilder;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Decoration? decoration;
  final bool debug;

  /// Default color Theme.of(context).dividerTheme.color
  final Color? color;

  const DragResizableDividerRow({
    super.key,
    required this.child,
    required this.defaultWidth,
    this.widthRange = const [],
    this.draggable = true,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.dividerBuilder,
    this.padding,
    this.backgroundColor,
    this.decoration,
    this.debug = false,
  });

  @override
  State<DragResizableDividerRow> createState() =>
      _DragResizableDividerRowState();
}

class _DragResizableDividerRowState extends State<DragResizableDividerRow> {
  double _defaultWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _defaultWidth = widget.defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        children: [
          Container(
            color: widget.debug ? Colors.blue : widget.backgroundColor,
            decoration: widget.decoration,
            padding: widget.padding ?? EdgeInsets.zero,
            child: SizedBox(width: _defaultWidth, child: widget.child),
          ),
          DragResizableDivider(
            draggable: widget.draggable,
            height: widget.height,
            thickness: widget.thickness,
            indent: widget.indent,
            endIndent: widget.endIndent,
            color: widget.color,
            dividerBuilder: widget.dividerBuilder,
            debug: widget.debug,
            dividerDirection: Axis.vertical,
            onResize: (dx) {
              if (!widget.draggable) return;
              setState(() {
                if (widget.widthRange.isEmpty) {
                  _defaultWidth += dx;
                } else {
                  final minWidth = widget.widthRange.first;
                  final maxWidth = widget.widthRange.last;
                  if (_defaultWidth + dx >= minWidth &&
                      _defaultWidth + dx <= maxWidth) {
                    _defaultWidth += dx;
                  } else if (_defaultWidth + dx < minWidth) {
                    _defaultWidth = minWidth;
                  } else {
                    _defaultWidth = maxWidth;
                  }
                }
              });
            },
          )
        ],
      );
    });
  }
}

/// Make sure child is infinite height
/// If use column warp column with [SingleChildScrollView]
/// Or else use [ListView.builder]
class DragResizableDividerColumn extends StatefulWidget {
  final double defaultHeight;
  final List<double> heightRange;
  final bool draggable;
  final Widget child;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Decoration? decoration;

  /// Default color Theme.of(context).dividerTheme.color
  final Color? color;
  final DividerBuilder? dividerBuilder;

  final bool debug;

  const DragResizableDividerColumn({
    super.key,
    required this.child,
    required this.defaultHeight,
    this.heightRange = const [],
    this.draggable = true,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.dividerBuilder,
    this.padding,
    this.backgroundColor,
    this.decoration,
    this.debug = false,
  });

  @override
  State<DragResizableDividerColumn> createState() =>
      _DragResizableDividerColumnState();
}

class _DragResizableDividerColumnState
    extends State<DragResizableDividerColumn> {
  double _defaultHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _defaultHeight = widget.defaultHeight;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Container(
                color: widget.debug ? Colors.blue : widget.backgroundColor,
                decoration: widget.decoration,
                padding: widget.padding ?? EdgeInsets.zero,
                child: SizedBox(
                    height: _defaultHeight,
                    child: Expanded(child: widget.child))),
            DragResizableDivider(
              draggable: widget.draggable,
              height: widget.height,
              thickness: widget.thickness,
              indent: widget.indent,
              endIndent: widget.endIndent,
              color: widget.color,
              dividerBuilder: widget.dividerBuilder,
              debug: widget.debug,
              dividerDirection: Axis.horizontal,
              onResize: (dy) {
                if (!widget.draggable) return;
                setState(() {
                  if (widget.heightRange.isEmpty) {
                    _defaultHeight += dy;
                  } else {
                    final minHeight = widget.heightRange.first;
                    final maxHeight = widget.heightRange.last;
                    if (_defaultHeight + dy >= minHeight &&
                        _defaultHeight + dy <= maxHeight) {
                      _defaultHeight += dy;
                    } else if (_defaultHeight + dy < minHeight) {
                      _defaultHeight = minHeight;
                    } else {
                      _defaultHeight = maxHeight;
                    }
                  }
                });
              },
            )
          ],
        );
      },
    );
  }
}
