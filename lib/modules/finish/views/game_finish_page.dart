import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../../game/game.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/title_text.dart';
import '../models/finish_page_arguments.dart';

class FinishPage extends StatelessWidget {
  late Game game;
  late List<GameRoundContainer> containers;

  FinishPage({super.key}) {
    FinishPageArguments args = Get.arguments;

    game = args.game;
    containers = args.containers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TitleText("module.finish.title".tr),
                  ]),
                  BorderContainer(
                      title: 'module.finish.solved'
                          .trParams({'solvedCount': "${containers.length}"}),
                      body: "module.finish.solved_time".trParams({
                        '1':
                            "${game.getEstimatedTime().inSeconds}.${(game.getEstimatedTime().inMilliseconds % 1000)}"
                      })),
                  Expanded(
                      child: DynMouseScroll(
                    builder: (context, controller, physics) => ListView.builder(
                        physics: physics,
                        controller: controller,
                        itemBuilder: (context, index) => containers[index],
                        itemCount: containers.length),
                  )),
                  SizedBox(height: 5.h),
                  CustomButton(
                      text: 'general.exit'.tr,
                      onClick: () {
                        Get.back();
                      }),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class GameRoundContainer extends StatelessWidget {
  const GameRoundContainer({super.key});
}
