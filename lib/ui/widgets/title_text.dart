import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_colors.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "title",
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontSize: 22.spMin,
              fontWeight: FontWeight.bold,
              color: AppColors.black),
        ));
  }
}
