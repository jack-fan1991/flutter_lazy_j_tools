import 'dart:async';

import 'package:flutter/material.dart';

class DeBounceTextFormField extends StatefulWidget {
  final Duration deBounceTime;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final void Function(String value)? onChanged;
  final void Function(String value)? onDeBounceConfirm;
  final FocusNode? focusNode;

  const DeBounceTextFormField({
    super.key,
    this.deBounceTime = const Duration(milliseconds: 800),
    required this.controller,
    this.decoration,
    this.onChanged,
    this.onDeBounceConfirm,
    this.focusNode,
  });

  @override
  State<DeBounceTextFormField> createState() => _DeBounceTextFormFieldState();
}

class _DeBounceTextFormFieldState extends State<DeBounceTextFormField> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        focusNode: widget.focusNode,
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          _debounce = Timer(widget.deBounceTime, () {
            widget.controller.text = value;
            widget.onDeBounceConfirm?.call(value);
          });
        },
        decoration: widget.decoration);
  }
}
