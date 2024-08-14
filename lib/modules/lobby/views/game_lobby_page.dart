import 'package:binary_quiz/ui/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/exit_button.dart';
import '../../../ui/widgets/title_text.dart';
import '../controllers/game_lobby_controller.dart';

class GameLobbyPage extends GetView<GameLobbyController> {
  const GameLobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  TitleText("general.app_title".tr),
                  const Expanded(child: SizedBox()),
                  const ExitButton(),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                  child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    BorderContainer(
                        title: "📖 ${controller.getGame().getName()}",
                        body: controller.getGame().getDescription()),
                    SizedBox(height: 20.h)
                  ])),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        BorderContainer(
                            title: 'module.lobby.setting_desc.title'.tr,
                            body: 'module.lobby.setting_desc.content'.tr,
                            backgroundColor: AppColors.grey),
                        ...controller.getGame().getSettingWidgets()
                      ],
                    ),
                  ),
                ],
              )),
              SizedBox(height: 12.h),
              CustomButton(
                  text: 'module.lobby.start_quiz'.tr,
                  onClick: controller.startGame),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
