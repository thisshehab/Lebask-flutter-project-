import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebask/main/home/cart/cart_pages/cart2.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:lebask/main/search/Search.dart';
import 'package:lebask/sillers/sillerslist.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../others/provider1.dart';
import 'home/Home.dart';
import 'home/cart/cart.dart';

// ignore: camel_case_types
class mainpage extends StatefulWidget {
  const mainpage({Key? key}) : super(key: key);
  @override
  State<mainpage> createState() => _mainpageState();
}

// ignore: camel_case_types
class _mainpageState extends State<mainpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final navkey = GlobalKey<CurvedNavigationBarState>();
  final items = <Widget>[
    Container(
      padding: EdgeInsets.all(Get.width / 70),
      child: FaIcon(
        FontAwesomeIcons.houseChimneyUser,
        size: Get.width / 17,
      ),
    ),
    Container(
        padding: EdgeInsets.all(Get.width / 70),
        // ignore: deprecated_member_use
        child: FaIcon(FontAwesomeIcons.search, size: Get.width / 17)),
    Container(
        padding: EdgeInsets.all(Get.width / 70),
        child: FaIcon(FontAwesomeIcons.shop, size: Get.width / 17)),
    Container(
        padding: EdgeInsets.all(Get.width / 70),
        child: FaIcon(FontAwesomeIcons.heart, size: Get.width / 17)),
  ];
  bool visalble = true;
  int index = 0;
  var text = TextEditingController();
  List<Widget> screens = [home(), const Searchpage(), const sillerslist()];
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          backgroundColor: provider.colortheme,
          iconSize: Get.height / 44,
          selectedFontSize: Get.height / 59,
          unselectedFontSize: Get.height / 65,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.houseChimneyUser),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.search),
              label: 'بحث',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shop),
              label: 'المتاجر',
            ),
          ],
          currentIndex: index,
          selectedItemColor: Colors.amber[800],
          onTap: (index1) {
            setState(() {
              index = index1;
            });
          },
        ),
        appBar: AppBar(
          actions: [
            Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(left: Get.width / 25),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: provider.black,
                      ),
                      onPressed: () async {
                        await shouldrefresh();
                        if (refresh) nav2State.getusercart2();
                        provider.getuserlocations();
                        Navigator.push(
                          context,
                          PageTransition(
                            child: cart2(),
                            type: PageTransitionType.leftToRight,
                            duration: const Duration(milliseconds: 260),
                            reverseDuration: const Duration(milliseconds: 260),
                          ),
                        );
                      },
                    )),
                // Container(
                //   alignment: Alignment.centerRight,
                //   width: Get.height / 60,
                //   height: Get.height / 60,
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(50),
                //         color: Colors.red),
                //   ),
                // )
              ],
            )
          ],
          leading: IconButton(
              icon:
                  FaIcon(FontAwesomeIcons.barsStaggered, color: provider.black),
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              }),
          title: Text(
            'لِباسك',
            style: TextStyle(letterSpacing: 1.7, color: provider.black),
          ),
          backgroundColor: provider.colortheme,
        ),
        // bottomNavigationBar: Theme(
        //   data: Theme.of(context).copyWith(
        //     iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        //   ),
        //   child: Container(
        //     decoration: const BoxDecoration(boxShadow: [
        //       BoxShadow(
        //         color: Color.fromARGB(64, 0, 0, 0),
        //         offset: Offset(-3, 3),
        //         blurRadius: 30,
        //         spreadRadius: 5.0,
        //       )
        //     ]),
        //     child: CurvedNavigationBar(

        //       index: index,
        //       onTap: (index) => setState(() {
        //         this.index = index;
        //       }),
        //       color: provider.orange,
        //       buttonBackgroundColor: provider.gray2,

        //       backgroundColor: Colors.transparent,
        //       animationCurve: Curves.fastLinearToSlowEaseIn,
        //       //easeInOutBack,
        //       // this is use to make the same color of background !
        //       items: items,
        //       height: 57,
        //       animationDuration: const Duration(milliseconds: 1400),
        //       //this is use to control the time when changed
        //       //the tabs
        //     ),
        //   ),
        // ),
        body: screens[index],
      ),
    );
  }

  bool refresh = false;
  shouldrefresh() async {
    final prefs = await SharedPreferences.getInstance();
    var userdoc = prefs.getString('userid') ?? nav2.userdoc;
    await FirebaseFirestore.instance
        .collection("users")
        .where("docid", isEqualTo: userdoc)
        .get()
        .then((value) {
      refresh = value.docs[0].data()['shouldrefresh'] ?? false;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .update({"shouldrefresh": false});
  }
}

//this is another painter for bottom bar
// ignore: camel_case_types
class custompainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * .60, 0, size.width * .65, 0);
    path.quadraticBezierTo(size.width * .80, 0, size.width, 20);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black38, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
