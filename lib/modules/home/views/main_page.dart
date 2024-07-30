import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../tools/my_tool.dart';
import '../../../ui/themes/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/title_text.dart';

class MainPage extends GetView<HomeController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText("Binary Quiz"),
              SizedBox(height: 12.h),
              const BorderContainer(
                  title: "📖 앱 설명",
                  body:
                  "Binary Quiz는 이진수 계산 능력을 향상시킬 수 있는 앱입니다.\n반복 연습을 통해 당신의 계산 속도를 향상시켜보세요!"),
              SizedBox(height: 20.h),
            const BorderContainer(
                title: "🕹️ 퀴즈",
                body: "즐기고 싶은 퀴즈를 선택하세요",
                backgroundColor: AppColors.grey),
              Expanded(child: _GameListView(controller.getAvailableGames())),
              SizedBox(height: 12.h),
              CustomButton(text: "선택했어요", onClick: _onButtonClick),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonClick() {
    if (!controller.hasSelectedGame()) {
      MyTool.snackbar(title: "게임을 선택해주세요");
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