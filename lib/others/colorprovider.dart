import 'package:flutter/material.dart';

class colorprovider with ChangeNotifier {
  Color yellow = const Color.fromARGB(255, 255, 234, 0);

  Color black = Colors.black;

  Color white = Color.fromARGB(255, 255, 252, 247);

  Color likewhite = Color.fromARGB(255, 60, 63, 60);

  Color theblue = Colors.blue;

  Color darckblue = const Color.fromARGB(255, 6, 40, 61);

  Color lightblue1 = const Color.fromARGB(255, 89, 161, 209);

  Color lightblue2 = const Color.fromARGB(255, 255, 242, 223);

  Color gray = const Color.fromARGB(255, 9, 49, 58);

  Color gray2 = Color.fromARGB(255, 38, 39, 40);

  Color green = const Color.fromARGB(255, 194, 222, 209);

  Color darkgreen = const Color.fromARGB(255, 52, 98, 108);

  Color orange2 = const Color.fromARGB(255, 255, 251, 248);
  Color colortheme = Color.fromARGB(255, 245, 245, 245);
  Color continercolor = const Color.fromARGB(255, 6, 40, 61);
  Color blue = const Color.fromARGB(255, 12, 44, 82);

  Brightness bright = Brightness.light;

  Color orange = const Color.fromARGB(255, 255, 162, 0);

  setcolors({islight, isinitial}) async {
    if (await islight) {
      blue = const Color.fromARGB(255, 12, 44, 82);
      bright = Brightness.light;

      yellow = const Color.fromARGB(255, 255, 234, 0);

      black = Colors.black;

      white = Color.fromARGB(255, 255, 252, 247);

      likewhite = Color.fromARGB(255, 60, 63, 60);

      theblue = Colors.blue;

      darckblue = const Color.fromARGB(255, 6, 40, 61);

      lightblue1 = const Color.fromARGB(255, 89, 161, 209);

      lightblue2 = Color.fromARGB(255, 255, 254, 253);

      gray = const Color.fromARGB(255, 9, 49, 58);

      gray2 = Color.fromARGB(255, 38, 39, 40);

      green = const Color.fromARGB(255, 194, 222, 209);

      darkgreen = const Color.fromARGB(255, 52, 98, 108);

      orange2 = Color.fromARGB(255, 255, 251, 248);
      colortheme = Color.fromARGB(255, 245, 245, 245);
      continercolor = const Color.fromARGB(255, 6, 40, 61);
      if (!isinitial) notifyListeners();
    } else {
      gray2 = Color.fromARGB(255, 202, 205, 207);
      white = Color.fromARGB(255, 83, 87, 83);
      black = Color.fromARGB(255, 220, 220, 220);
      colortheme = Color.fromARGB(255, 59, 62, 59);
      continercolor = Color.fromARGB(255, 64, 66, 64);
      lightblue2 = Color.fromARGB(255, 38, 39, 40);

      bright = Brightness.dark;
      if (!isinitial) notifyListeners();
    }
  }
}
