import 'dart:math';

class BinTool {
  static String int2bin(int num) {
    if (num == 0) return "0";

    String str = "";

    while (num != 0) {
      str = "${num % 2}$str";
      num = num ~/ 2;
    }

    return str;
  }

  static int? bin2int(String bin) {
    int length = bin.length;
    int ret = 0;

    for (int i = 0; i < length; i++) {
      String char = bin[i];
      if (char != '0' && char != '1') return null;

      num value = int.parse(char) * pow(2, length - i - 1);
      ret += value.toInt();
    }

    return ret;
  }
}
