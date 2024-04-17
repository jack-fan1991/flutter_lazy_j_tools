import 'dart:async';

import 'package:flutter/material.dart';

class DeBounceTextFormField extends StatefulWidget {
  final Duration deBounceTime;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  const DeBounceTextFormField({
    super.key,
    required this.deBounceTime,
    required this.controller,
    this.decoration,
    this.onChanged,
  });

  @override
  State<DeBounceTextFormField> createState() => _DeBounceTextFormFieldState();
}

class _DeBounceTextFormFieldState extends State<DeBounceTextFormField> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextField(
        onChanged: (value) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          _debounce = Timer(widget.deBounceTime, () {
            widget.controller.text = value;
            widget.onChanged?.call(value);
          });
        },
        decoration: widget.decoration);
  }
}
