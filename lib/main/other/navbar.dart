import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/other/item_details.dart';
import 'package:lebask/registration/signup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../admin/orders.dart';
import '../../others/provider1.dart';
import '../../sillers/Shop/shop_products.dart';
import '../add_itmes/add_items.dart';
import '../home/favroute/favaroute.dart';
import '../home/my_locations.dart';
import '../mainpage.dart';
import '../other/likedbutton.dart';
import '../../admin/addcategory.dart';

class nav2 extends StatefulWidget {
  final String? username;
  final String? phonenumber;
  static String? userdoc;
  nav2({this.username, this.phonenumber, userdoc});

  @override
  State<nav2> createState() => nav2State();
}

class nav2State extends State<nav2> {
  String? username;
  String? userphonenumber;
  @override
  void initState() {
    super.initState();
    initalize();
    gettheuserInfo();
    getuserfav();
    getusercart2();
    getthemode();
  }

  static getusercart2() async {
    final prefs = await SharedPreferences.getInstance();
    var userdoc = prefs.getString('userid') ?? nav2.userdoc;
    ItemDetails.usercartitem.clear();
    ItemDetails.usercartdoc.clear();
    ItemDetails.userphoto.clear();
    ItemDetails.useritemname.clear();
    ItemDetails.usersize.clear();
    ItemDetails.userquantity.clear();
    ItemDetails.userprice.clear();

    //get the user cart doc>>>>>>>>>
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where('completed', isEqualTo: false)
        .limit(1)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userdoc)
            .collection('orders')
            .doc(element.data()['docid'])
            .collection('products')
            .get()
            .then((value) {
          for (var element in value.docs) {
            ItemDetails.usercartitem.add(element.data()['itemid']);
            ItemDetails.usercartdoc.add(element.data()['docid']);
            ItemDetails.userquantity.add(element.data()['quantity']);
            ItemDetails.usersize.add(element.data()['size']);
            ItemDetails.userphoto.add(element.data()['picture']);
            ItemDetails.useritemname.add(element.data()['item']);
            ItemDetails.userprice.add(element.data()['price']);
          }
        });
      }
    });
    // get the user cart products>>>>>>>>>
  }

  initalize() async {
    final prefs = await SharedPreferences.getInstance();

    MyApp.likenumber =
        prefs.getInt('favnumber') != null ? prefs.getInt('favnumber')! : 0;
    // getthemode();
  }

  bool? islight;
  getthemode() async {
    Counterprovider provider =
        Provider.of<Counterprovider>(context, listen: false);
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    final prefs = await SharedPreferences.getInstance();
    islight = prefs.getBool('isdark') != null
        ? !prefs.getBool('isdark')!
        : brightness == Brightness.dark;
    setState(() {});
  }
  // getthemode() async {
  //   Counterprovider provider =
  //       Provider.of<Counterprovider>(context, listen: false);
  //   var brightness = SchedulerBinding.instance.window.platformBrightness;
  //   final prefs = await SharedPreferences.getInstance();

  //   isdark = prefs.getBool('isdark') ?? brightness == Brightness.dark;
  //   provider.setcolors(isinitial: true, islight: isdark);
  // }

  getuserfav() async {
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');

    if (prefs.getString('userid') != null) {
      nav2.userdoc = prefs.getString('userid');
    }
    likebutton.userfa.clear();
    likebutton.userfadoc.clear();
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('fav')
        .get()
        .then((value) {
      for (var element in value.docs) {
        likebutton.userfa.add(element.data()['itemid']);
        likebutton.userfadoc.add(element.data()['docid']);
      }
    });
  }

  gettheuserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    userphonenumber = prefs.getString('userphone');
    setState(() {});
  }

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return islight == null
        ? Scaffold(
            body: Center(
              child: Container(
                color: provider.colortheme,
                child: SpinKitRipple(
                  color: provider.orange,
                  size: Get.width / 2.5,
                  duration: const Duration(milliseconds: 1500),
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              provider.darckblue,
              const Color.fromARGB(255, 14, 67, 126)
            ])),
            child: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ZoomDrawer(
                  //  overlayBlend :BlendMode.colorBurn,
                  style: DrawerStyle.defaultStyle,
                  isRtl: true,
                  menuBackgroundColor: provider.colortheme,
                  menuScreen: Container(
                    color: provider.colortheme,
                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 48,
                          color: provider.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: Get.height / 23,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 7),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: provider.orange,
                                        size: Get.height / 27,
                                      ),
                                      Text(
                                        username != null
                                            ? 'shehab mohammed'
                                            : ' ${widget.username}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 13),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: provider.orange,
                                        size: Get.height / 27,
                                      ),
                                      Text(
                                        " ${widget.phonenumber != null ? widget.phonenumber : userphonenumber}",
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 0.8,
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              menuitem(
                                  FontAwesomeIcons.houseChimneyUser,
                                  "الرئيسية",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => nav2()));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              // menuitem(
                              //     FontAwesomeIcons.heartCircleCheck,
                              //     "المفضلة",
                              //     provider.favnumber > 0 || MyApp.likenumber > 0
                              //         ? Stack(
                              //             children: [
                              //               Icon(
                              //                 Icons.notifications_none,
                              //                 size: MediaQuery.of(context)
                              //                         .size
                              //                         .width /
                              //                     14,
                              //                 color: Colors.black,
                              //               ),
                              //               Container(
                              //                 alignment: Alignment.topLeft,
                              //                 width: Get.height / 60,
                              //                 height: Get.height / 60,
                              //                 child: Align(
                              //                     alignment: Alignment.topLeft,
                              //                     child: Container(
                              //                       decoration: BoxDecoration(
                              //                           borderRadius:
                              //                               BorderRadius
                              //                                   .circular(50),
                              //                           color: Colors.red),
                              //                     )),
                              //               )
                              //             ],
                              //           )
                              //         : FaIcon(
                              //             FontAwesomeIcons.arrowLeft,
                              //             color: provider.black,
                              //             size: MediaQuery.of(context)
                              //                     .size
                              //                     .width /
                              //                 20,
                              //           ), () async {
                              //   final prefs =
                              //       await SharedPreferences.getInstance();
                              //   prefs.setInt('favnumber', 0);
                              //   provider.setfavnumber(0);

                              //   // ignore: use_build_context_synchronously
                              //   Navigator.push(
                              //       context,
                              //       PageTransition(
                              //         child: const favorite(),
                              //         alignment: Alignment.topCenter,
                              //         type: PageTransitionType.rightToLeft,
                              //         duration:
                              //             const Duration(milliseconds: 280),
                              //       ));
                              // }),
                              const Divider(
                                height: 1,
                              ),
                              menuitem(
                                  FontAwesomeIcons.plus,
                                  "إضافة منتج",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const add_items(),
                                      alignment: Alignment.topCenter,
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 280),
                                    ));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              menuitem(
                                  FontAwesomeIcons.locationDot,
                                  "مواقعي",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                provider.getuserlocations();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const mylocations(),
                                      alignment: Alignment.topCenter,
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 280),
                                    ));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              menuitem(
                                  FontAwesomeIcons.add,
                                  "إضافة تصنيف",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: addcategory(),
                                      alignment: Alignment.topCenter,
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 280),
                                    ));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              menuitem(
                                  EvaIcons.archive,
                                  "منتجاتي",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: sillerproducts(),
                                      alignment: Alignment.topCenter,
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 280),
                                    ));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              menuitem(
                                  FontAwesomeIcons.cartArrowDown,
                                  "الطلبات",
                                  FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: provider.black,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ), () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: orders(),
                                      alignment: Alignment.topCenter,
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 280),
                                    ));
                              }),
                              const Divider(
                                height: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 0.2,
                                  ),
                                  Icon(
                                    Ionicons.moon,
                                    size: Get.height / 34,
                                  ),
                                  Text(
                                    "الوضع المظلم",
                                  ),
                                  Switch.adaptive(
                                      activeTrackColor: provider.orange,
                                      activeColor: provider.orange,
                                      focusColor: provider.orange,
                                      value: islight!,
                                      onChanged: (value) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        setState(() {
                                          provider.setcolors(
                                              islight: islight,
                                              isinitial: false);
                                          islight = value;
                                          prefs.setBool('isdark', !islight!);
                                        });
                                      }),
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: Get.height / 66),
                                width: Get.width / 2.8,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(23, 0, 0, 0),
                                      offset: Offset(7, 19.0),
                                      blurRadius: 14.0,
                                      spreadRadius: .3,
                                    )
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                      width: Get.width,
                                      buttonsBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(2),
                                      ),
                                      dismissOnTouchOutside: true,
                                      dismissOnBackKeyPress: false,
                                      onDismissCallback: (type) {
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   SnackBar(
                                        //     content: Text('Dismissed by $type'),
                                        //   ),
                                        // );
                                      },
                                      headerAnimationLoop: false,
                                      animType: AnimType.bottomSlide,
                                      desc:
                                          'تسجيل الخروج من حساب ${widget.username ?? username}',
                                      showCloseIcon: true,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await FirebaseAuth.instance.signOut();
                                        prefs.remove("userid");
                                        prefs.remove("username");
                                        prefs.remove("userphone");
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              child: signup(),
                                              alignment: Alignment.topCenter,
                                              type: PageTransitionType.fade,
                                              duration: const Duration(
                                                  milliseconds: 280),
                                            ));
                                      },
                                    ).show();
                                  },
                                  label: Text(
                                    "تسجيل خروج",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              27,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Ionicons.log_out_outline,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height / 33,
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        primary:
                                            Color.fromARGB(255, 33, 81, 238))),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: Get.height / 55,
                                      color: provider.black),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 17),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "برمجة وتصميم",
                                        ),
                                        TextButton.icon(
                                            style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent)),
                                            onPressed: () {
                                              lunchwhatsapp(
                                                  "+967772905140", "Hi Shehab");
                                            },
                                            icon: const Icon(
                                                EvaIcons.facebookOutline),
                                            label: const Text(
                                              "شهاب الحيي",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w600),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  mainScreen: const mainpage(),
                  borderRadius: 10.0,
                  showShadow: true,
                  angle: 0,
                  drawerShadowsBackgroundColor: provider.orange,
                  shadowLayer2Color: provider.darckblue.withOpacity(0.9),
                  slideWidth: MediaQuery.of(context).size.width * 0.70,
                ),
              ),
            ),
          );
  }

  lunchwhatsapp(String phonenumber, String message) async {
    Uri url = Uri.parse("whatsapp://send?phone=$phonenumber&text=$message");
    await canLaunchUrl(url) ? launchUrl(url) : print("cantlunch");
  }
}

// ignore: camel_case_types
class menuitem extends StatelessWidget {
  final icon;
  final title;
  final traling;
  final Function() fun;
  const menuitem(this.icon, this.title, this.traling, this.fun);
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return ListTile(
      selected: true,
      leading: FaIcon(icon, color: provider.black, size: Get.height / 40),
      title: title != 'الوضع المظلم'
          ? Text(
              title,
              style: TextStyle(
                color: provider.black,
                fontSize: 16,
              ),
            )
          : FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  color: provider.black,
                ),
              ),
            ),
      trailing: traling,
      onTap: fun,
    );
  }
}
