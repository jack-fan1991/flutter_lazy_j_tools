import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lazy_j_tools/src/debouncer/debouncer.dart';

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
  late final Debouncer _debounce;

  @override
  void initState() {
    _debounce = Debouncer(delay: widget.deBounceTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          widget.onChanged?.call(value);
          _debounce.run(() {
            // widget.controller.text = value;
            widget.onDeBounceConfirm?.call(value);
          });
        },
        decoration: widget.decoration);
  }
}
