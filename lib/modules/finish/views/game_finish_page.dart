import 'package:binary_quiz/ui/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../../game/game.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';

class FinishPage extends StatelessWidget {
  final Game game;
  final List<GameRoundContainer> containers;

  const FinishPage({super.key, required this.game, required this.containers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TitleText("결과"),
                ]),
                BorderContainer(
                title: "총 ${containers.length} 문제를 풀었어요",
                body: "${game.getEstimatedTime().inSeconds}.${(game.getEstimatedTime().inMilliseconds % 1000)}초 소요"),
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

abstract class GameRoundContainer extends StatelessWidget {
  const GameRoundContainer({super.key});
}
