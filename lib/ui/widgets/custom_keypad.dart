import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';

class CustomKeypad extends StatelessWidget {
  static const String deletionMagicKey = "-1";

  final List<int> numbers; // 0은 제외
  final bool sign;
  final bool dot;
  final Function(String char) onPressed;

  const CustomKeypad(
      {super.key,
      required this.numbers,
      required this.sign,
      required this.dot,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: _Button(
                  character: 'keypad.remove'.tr,
                  onPressed: (c) => onPressed(deletionMagicKey))),
          Flexible(
              flex: (numbers.length / 3).ceil() + 4,
              child: Row(
                children: [
                  Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                              flex: (numbers.length / 3).ceil() + 1,
                              child: _CustomGridView(
                                  children: List.generate(
                                      numbers.length,
                                      (index) => _Button(
                                            character:
                                                numbers[index].toString(),
                                            onPressed: onPressed,
                                          )))),
                          Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 2,
                                      child: _Button(
                                          character: "0",
                                          onPressed: onPressed)),
                                  if (dot)
                                    Flexible(
                                        flex: 1,
                                        child: _Button(
                                            character: ".",
                                            onPressed: onPressed))
                                ],
                              ))
                        ],
                      )),
                  if (sign)
                    Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                                child: _Button(
                                    character: "-", onPressed: onPressed)),
                            Expanded(
                                child: _Button(
                                    character: "+", onPressed: onPressed)),
                          ],
                        ))
                ],
              ))
        ],
      ),
    );
  }
}

class _Button extends StatefulWidget {
  final String character;
  final Function(String char) onPressed;

  const _Button({super.key, required this.character, required this.onPressed});

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  double _padding = 0;
  Timer? _longPressTimer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _updatePadding(3),
      onTapUp: (details) => Future.delayed(
        const Duration(milliseconds: 50),
        () => _updatePadding(0),
      ),
      onTapCancel: () => _setPadding(0),
      onTap: () => widget.onPressed(widget.character),
      onLongPressStart: (d) => _startTimer(),
      onLongPressCancel: () => _cancelTimer(),
      onLongPressEnd: (d) => _cancelTimer(),
      child: AnimatedContainer(
        padding: EdgeInsets.all(_padding.r),
        duration: const Duration(milliseconds: 50),
        curve: Curves.bounceInOut,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Text(
              widget.character,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlueGrey,
                  fontSize: 20.spMin),
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    if (_longPressTimer != null) _longPressTimer!.cancel();
    _longPressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      _haptic();
      widget.onPressed(widget.character);
    });
  }

  void _cancelTimer() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  void _setPadding(double v) {
    setState(() {
      _padding = v;
    });
  }

  void _haptic() {
    HapticFeedback.selectionClick();
  }

  void _updatePadding(double v) {
    _setPadding(v);
    _haptic();
  }
}

class _CustomGridView extends StatefulWidget {
  final List<Widget> children;

  const _CustomGridView({super.key, required this.children});

  @override
  State<_CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<_CustomGridView> {
  final List<Widget> _rows = [];

  @override
  void initState() {
    super.initState();

    int idx = 0;
    List<Widget> rowChildren = [];
    for (Widget child in widget.children) {
      rowChildren.add(Expanded(child: child));

      idx++;
      if (idx % 3 == 0) {
        _rows.add(Expanded(child: Row(children: List.from(rowChildren))));
        rowChildren.clear();
      }
    }

    if (rowChildren.isNotEmpty) {
      _rows.add(Expanded(child: Row(children: rowChildren)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _rows);
  }
}
