import 'dart:math';

import 'package:binary_quiz/app_colors.dart';
import 'package:binary_quiz/controller/in_game_controller.dart';
import 'package:binary_quiz/game_settings.dart';
import 'package:binary_quiz/tool/my_tool.dart';
import 'package:binary_quiz/widget/border_container.dart';
import 'package:binary_quiz/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../tool/bin_tool.dart';
import '../../widget/CustomKeypad.dart';

class BinToDecController extends InGameController {
  final Map<int, _Stat> _statMap = {};
  int startTime = 0;

  @override
  void init() {
    setCurrentRounds(-1);
    setCurrentBinary("");
    setCurrentDecimal(0);
    textInputFormatter =
        FilteringTextInputFormatter.allow(RegExp(r'^[+-]?\d*\.?\d*'));

    nextGame();
  }

  @override
  bool? check() {
    double? input = double.tryParse(teController.text.trim());
    if (input == null) {
      return null;
    }

    bool isAnswer = input == getCurrentDecimal();
    return isAnswer;
  }

  @override
  void nextGame() {
    if (getCurrentRounds() >= getMaxRounds()) {
      endGame();
      return;
    }
    teController.text = "";

    int randomNumber = Random().nextInt(10);
    String bin = BinTool.int2bin(randomNumber);

    setCurrentDecimal(randomNumber.toDouble());
    setCurrentBinary(bin);
    increaseRounds();

    _Stat stat = _getCurrentStat();
    stat.totalTryCount++;
  }

  @override
  void onPass() {
    int endTime = DateTime.now().millisecondsSinceEpoch;

    _Stat stat = _getCurrentStat();
    stat.passCount++;
    if (startTime != 0) {
      stat.totalEstimatedTime = endTime - startTime;
    }

    nextGame();
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void handleKeypadInput(String str) {
    final String text = teController.text;

    if (str == CustomKeypad.deletionMagicKey) {
      if (text.isEmpty) return;
      teController.text =
          teController.text.substring(0, teController.text.length - 1);
    } else {
      String tmp = teController.text + str;

      TextEditingValue? tev = textInputFormatter?.formatEditUpdate(
          TextEditingValue(text: teController.text),
          TextEditingValue(text: tmp));
      if (tev != null) {
        teController.text = tev.text;
      }
    }
  }

  _Stat _getCurrentStat() {
    _Stat stat = _getStat(getCurrentDecimal().toInt());
    return stat;
  }

  _Stat _getStat(int num) {
    _Stat? stat = _statMap[num];
    stat ??= _Stat(num);

    _statMap[num] = stat;
    return stat;
  }

  @override
  void onNonPass() {
    _Stat stat = _getCurrentStat();
    stat.nonPassCount++;
  }

  @override
  void endGame() {
    Get.off(_FinishPage(statMap: _statMap));
  }
}

class _Stat {
  final int num;
  int passCount = 0;
  int nonPassCount = 0;
  int totalEstimatedTime = 0;
  int totalTryCount = 0;

  _Stat(this.num);

  String toBinary() {
    return BinTool.int2bin(num);
  }
}

class _FinishPage extends StatelessWidget {
  final Map<int, _Stat> statMap;
  late List<_Stat> passedList;
  late List<_Stat> nonPassedList;


  _FinishPage({super.key, required this.statMap}) {
    passedList = getPassedList();
    nonPassedList = getNonPassedList();

    sortStatList(passedList);
    sortStatList(nonPassedList);
  }

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
                          fontWeight: FontWeight.bold, fontSize: 25.sp)),
                ]),
                const BorderContainer(title: "✅맞은 문제"),
                Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _StatContainer(stat: passedList[index]),
                        itemCount: passedList.length)),
                SizedBox(height: 5.h),
                const Divider(),
                const BorderContainer(title: "❌틀린 문제", body: '"제출"버튼을 누른 경우에만 집계돼요'),
                Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _StatContainer(stat: nonPassedList[index]),
                        itemCount: nonPassedList.length)),
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

  List<_Stat> getPassedList() {
    List<_Stat> stats = [];
    for (_Stat stat in statMap.values) {
      if (stat.nonPassCount == 0) {
        stats.add(stat);
      }
    }

    return stats;
  }

  List<_Stat> getNonPassedList() {
    List<_Stat> stats = [];
    for (_Stat stat in statMap.values) {
      if (stat.nonPassCount > 0) {
        stats.add(stat);
      }
    }

    return stats;
  }

  void sortStatList(List<_Stat> list) {
    bool finish = true;
    for (int i = 0; i < list.length - 1; i++) {
      _Stat cst = list[i];
      _Stat nst = list[i + 1];
      if (cst.num > nst.num) {
        list[i] = nst;
        list[i + 1] = cst;
        finish = false;
      }
    }

    if (!finish) return sortStatList(list);
  }
}

class _StatContainer extends StatelessWidget {
  final _Stat stat;

  const _StatContainer({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: getBinary(),
      body: "십진수: ${stat.num}\n"
          "평균 ${stat.totalEstimatedTime / stat.totalTryCount / 1000}초 소요\n"
          "${stat.totalTryCount}번 풀었음",
    );
  }

  String getBinary() {
    String maxBin = BinTool.int2bin(GameSettings.instance.maxValue.value.toInt());
    String bin = stat.toBinary();
    bin = bin.padLeft(maxBin.length, '0');
    return bin;
  }
}
