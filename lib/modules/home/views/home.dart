import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../routes/app_pages.dart';
import '../../../tools/my_tool.dart';
import '../../../ui/themes/app_colors.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/title_text.dart';
import '../controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleText('general.app_title'.tr),
              SizedBox(height: 12.h),
              BorderContainer(
                  title: 'module.home.app_desc.title'.tr,
                  body: 'module.home.app_desc.content'.tr),
              SizedBox(height: 20.h),
            BorderContainer(
                title: 'module.home.quiz_desc.title'.tr,
                body: 'module.home.quiz_desc.body'.tr,
                backgroundColor: AppColors.grey),
              Expanded(child: _GameListView(controller.getAvailableGames())),
              SizedBox(height: 12.h),
              CustomButton(text: 'general.selected'.tr, onClick: _onButtonClick),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonClick() {
    if (!controller.hasSelectedGame()) {
      MyTool.snackbar(title: 'module.home.select_quiz'.tr);
      return;
    }

    Get.toNamed(Routes.LOBBY);
  }
}

class _GameListView extends StatelessWidget {
  final List<Game> gameList;

  const _GameListView(this.gameList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: gameList.length,
        itemBuilder: (context, index) => _SelectableBorderContainer(gameList[index])
    );
  }

}

class _SelectableBorderContainer extends GetView<HomeController> {
  final Game game;
  final RxBool isSelected = RxBool(false);

  _SelectableBorderContainer(this.game) {
    isSelected.listen((p0) {
      if (p0 == false) {
        controller.unselectGameByGame(game);
      } else {
        controller.selectedGame(game);
      }
    });

    controller.selectedGame.listen((p0) {
      if (p0 != game) isSelected.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child:
          BorderContainer(
            title: game.getName(),
            body: game.getDescription(),
            checkBox: isSelected,
          ),
    );
  }

  void _onTap() {
    controller.setSelectedGame(game);
    isSelected.value = controller.isSelected(game);
  }
}