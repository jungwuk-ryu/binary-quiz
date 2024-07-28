import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../widget/border_container.dart';
import '../widget/custom_button.dart';

class FinishPage extends StatelessWidget {
  final List<GameRoundContainer> containers;

  const FinishPage({super.key, required this.containers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("결과",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.spMin)),
                ]),
                BorderContainer(title: "총 ${containers.length} 문제를 풀었어요"),
                Expanded(
                    child: DynMouseScroll(
                      builder: (context, controller, physics) => ListView.builder(
                      physics: physics,
                      controller: controller,
                        itemBuilder: (context, index) =>
                        containers[index],
                        itemCount: containers.length),)),
                SizedBox(height: 5.h),
                CustomButton(
                    text: "나가기",
                    onClick: () {
                      Get.back();
                    }),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ));
  }
}

abstract class GameRoundContainer extends StatelessWidget {}
