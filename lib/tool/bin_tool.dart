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
}
