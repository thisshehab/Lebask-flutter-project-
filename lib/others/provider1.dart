import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class Counterprovider with ChangeNotifier {
  bool showred = false;
  showredmethod({showred2}) {
    showred = showred2;
    notifyListeners();
  }

  int? thelevel;
  setthelevel(number) {
    thelevel = number;
    notifyListeners();
  }

  int currentdotindex = 0;
  setdotindex(index) {
    currentdotindex = index;
    notifyListeners();
  }

  String selectedcategory = "58PN1DHfKWw5WkfuZxzI";
  String selelctedcategoryname = "ولادي";
  List name = [];
  List pictures = [];

  categorys(String newone, String selelctedcategoryname) async {
    selectedcategory = newone;
    this.selelctedcategoryname = selelctedcategoryname;
    pictures.clear();
    name.clear();
    FirebaseFirestore.instance
        .collection("people")
        .doc(selectedcategory)
        .collection("category")
        .get()
        .then((value) {
      for (var element2 in value.docs) {
        name.add(element2.data()['name']);
        pictures.add(element2.data()['picture']);
        notifyListeners();
      }
    });
  }

  // List imageads = [];
  // ads(newone) {
  //   imageads.clear();
  //   FirebaseFirestore.instance
  //       .collection("people")
  //       .doc(selectedcategory)
  //       .collection("category")
  //       .get()
  //       .then((value) {
  //     for (var element2 in value.docs) {
  //       imageads.add(element2.data()['picture']);
  //       pictures.add(element2.data()['picture']);
  //       notifyListeners();
  //     }
  //   });
  // }

  List<String> locaiton = [];
  List<String> locaitonname = [];
  List<String> loctiondocid = [];
  int? selectedindex;
  setlocationindex(index) {
    selectedindex = index;
    notifyListeners();
  }

  updatelocation({selectedlongtude, selectedlatitude, locaitondocid}) {
    locaiton[loctiondocid.indexOf(locaitondocid)] =
        '$selectedlatitude-$selectedlongtude';
    notifyListeners();
  }

  getuserlocations() async {
    locaitonname.clear();
    locaiton.clear();
    loctiondocid.clear();
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');

    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('locations')
        .get()
        .then((value) {
      for (var element in value.docs) {
        locaiton.add(element.data()['location']);
        locaitonname.add(element.data()['name']);
        loctiondocid.add(element.data()['docid']);
        notifyListeners();
      }
    });
  }

  addlocation(location1, locationnme1, locationdocid1) {
    locaiton.add(location1);
    locaitonname.add(locationnme1);
    loctiondocid.add(locationdocid1);
    notifyListeners();
  }

  deletelocaion(location1, locationnme1, locationdocid1) async {
    locaiton.remove(location1);
    locaitonname.remove(locationnme1);
    loctiondocid.remove(locationdocid1);
    final prefs = await SharedPreferences.getInstance();
    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('locations')
        .doc(locationdocid1)
        .delete();
    notifyListeners();
  }

  int favnumber = 0;
  void plus() {
    favnumber++;
    notifyListeners();
  }

  void setfavnumber(int number) {
    favnumber = number;
  }

  void minus() {
    favnumber--;
    notifyListeners();
  }

  bool closeslider = false;
  bool connection = true;
  bool close2 = false;
  void closeit() {
    closeslider = true;
    notifyListeners();
  }

  void reversclose2() {
    close2 = false;
    notifyListeners();
  }

  timer() async {
    await Future.delayed(Duration(milliseconds: 4000));
    close2 != close2;
    notifyListeners();
  }

  void openit() {
    closeslider = true;
    notifyListeners();
  }

  int counter = 0;
  void increment() {
    counter++;
    notifyListeners();
  }

  // the price>>>>>>>>>>>>>>>
  int totalprice = 0;
  addthetotalprice(int price) {
    totalprice += price;
    notifyListeners();
  }

//-------------------------------------------------------------------

  //   gray2 = Color.fromARGB(255, 202, 205, 207);
  // white = Color.fromARGB(255, 83, 87, 83);
  // black = Color.fromARGB(255, 220, 220, 220);
  // colortheme = Color.fromARGB(255, 59, 62, 59);
  // continercolor = Color.fromARGB(255, 64, 66, 64);
  // lightblue2 = Color.fromARGB(255, 38, 39, 40);

  Color yellow = const Color.fromARGB(255, 255, 234, 0);
  Color background = const Color.fromARGB(255, 248, 250, 247);

  Color black = Colors.black;

  Color white = Color.fromARGB(255, 255, 252, 247);

  Color likewhite = Color.fromARGB(255, 60, 63, 60);

  Color theblue = Colors.blue;

  Color darckblue = const Color.fromARGB(255, 6, 40, 61);

  Color lightblue1 = const Color.fromARGB(255, 89, 161, 209);

  Color lightblue2 = const Color.fromARGB(255, 255, 242, 223);

  Color gray = const Color.fromARGB(255, 9, 49, 58);

  Color gray2 = const Color.fromARGB(255, 38, 39, 40);

  Color green = const Color.fromARGB(255, 194, 222, 209);

  Color darkgreen = const Color.fromARGB(255, 52, 98, 108);

  Color sillercolor = const Color.fromARGB(255, 237, 250, 255);

  Color orange2 = const Color.fromARGB(255, 255, 251, 248);
  Color colortheme = const Color.fromARGB(255, 255, 252, 244);
  Color continercolor = const Color.fromARGB(255, 6, 40, 61);
  Color blue = const Color.fromARGB(255, 12, 44, 82);
  var placeolderimage = const AssetImage('pictures/white.jpg');

  List<BoxShadow> containershadow = const [
    BoxShadow(
      color: Color.fromARGB(27, 0, 0, 0),
      offset: Offset(4, 4),
      blurRadius: 7,
      spreadRadius: 3.0,
    )
  ];

  Brightness bright = Brightness.light;

  Color orange = const Color.fromARGB(255, 255, 162, 0);

  setcolors({islight, isinitial}) async {
    if (await islight) {
      containershadow = const [
        BoxShadow(
          color: Color.fromARGB(27, 0, 0, 0),
          offset: Offset(4, 4),
          blurRadius: 7,
          spreadRadius: 3.0,
        )
      ];
      background = const Color.fromARGB(255, 248, 250, 247);
      placeolderimage = const AssetImage('pictures/white.jpg');

      blue = const Color.fromARGB(255, 12, 44, 82);
      bright = Brightness.light;

      yellow = const Color.fromARGB(255, 255, 234, 0);

      black = Colors.black;

      white = const Color.fromARGB(255, 255, 252, 247);

      likewhite = const Color.fromARGB(255, 60, 63, 60);

      theblue = Colors.blue;

      darckblue = const Color.fromARGB(255, 6, 40, 61);

      lightblue1 = const Color.fromARGB(255, 89, 161, 209);

      lightblue2 = const Color.fromARGB(255, 255, 254, 253);

      gray = const Color.fromARGB(255, 9, 49, 58);

      gray2 = const Color.fromARGB(255, 38, 39, 40);

      green = const Color.fromARGB(255, 194, 222, 209);

      darkgreen = const Color.fromARGB(255, 52, 98, 108);

      orange2 = const Color.fromARGB(255, 255, 251, 248);
      colortheme = const Color.fromARGB(255, 255, 252, 244);
      continercolor = const Color.fromARGB(255, 6, 40, 61);
      if (!isinitial) notifyListeners();
    } else {
      containershadow = [
        const BoxShadow(
          color: Color(0xff3e3e3e),
          offset: Offset(-6.2, 6.2),
          blurRadius: 16,
          spreadRadius: 0.0,
        ),
        const BoxShadow(
          color: Color(0xff282828),
          offset: Offset(6.2, -6.2),
          blurRadius: 16,
          spreadRadius: 0.0,
        ),
      ];
      gray2 = const Color.fromARGB(255, 202, 205, 207);
      white = const Color.fromARGB(255, 83, 87, 83);
      black = const Color.fromARGB(255, 220, 220, 220);
      colortheme = const Color.fromARGB(255, 59, 62, 59);
      continercolor = const Color.fromARGB(255, 64, 66, 64);
      lightblue2 = const Color.fromARGB(255, 38, 39, 40);
      background = const Color.fromARGB(255, 46, 49, 46);
      placeolderimage = const AssetImage('pictures/white4.jpg');

      bright = Brightness.dark;
      if (!isinitial) notifyListeners();
    }
  }
}
