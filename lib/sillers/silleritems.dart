import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/home/Home.dart';
import 'package:lebask/main/home/locations/editlocations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../others/provider1.dart';
import '../main/home/converter.dart';
import '../main/other/item_details.dart';
import '../main/other/likedbutton.dart';
import '../main/search/goods.dart';

// ignore: camel_case_types
class silleritems extends StatefulWidget {
  final sillerphone;
  final sillername;
  final silleraddress;
  final sillerdiscription;
  final sillerlogo;
  const silleritems(
      {Key? key,
      required this.sillerphone,
      required this.sillername,
      required this.silleraddress,
      required this.sillerdiscription,
      required this.sillerlogo})
      : super(key: key);
  @override
  State<silleritems> createState() => _silleritemsState();
}

class _silleritemsState extends State<silleritems> {
  ScrollController controller = ScrollController();
  BitmapDescriptor image = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "pictures/third.png",
    ).then((value) => image = value);

    FirebaseFirestore.instance
        .collection("sillers")
        .where("phone", isEqualTo: widget.sillerphone)
        .get()
        .then((value) {
      for (var element in value.docs) {
        latitude = element.data()['location'].split('-')[0];
        longtude = element.data()['location'].split('-')[1];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        provider.darckblue,
        const Color.fromARGB(255, 14, 67, 126)
      ])),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableHome(
            headerExpandedHeight: 0.33,
            bottomSheet: people.length <= 1
                ? Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < 4; i++)
                            Shimmer(
                              period: const Duration(milliseconds: 700),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(0, 125, 125, 125),
                                Colors.white
                              ]),
                              loop: 100,
                              child: Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(7)),
                                height: 40,
                                width: Get.width / 7,
                              ),
                            )
                        ]),
                  )
                : SizedBox(
                    height: 70,
                    width: Get.width,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...people.map((e) {
                          return Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  selectedtypesearch = e;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    right: Get.height / 57,
                                    left: Get.height / 57,
                                    top: 5,
                                    bottom: 5),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: selectedtypesearch == e
                                        ? provider.orange
                                        : provider.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromARGB(24, 0, 0, 0),
                                          offset: Offset(3, 5),
                                          spreadRadius: 2,
                                          blurRadius: 6)
                                    ]),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: Get.width / 33,
                                    color: selectedtypesearch == e
                                        ? Colors.black
                                        : provider.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
            leading: const BackButton(color: Colors.white),
            appBarColor: provider.darckblue,
            alwaysShowLeadingAndAction: true,
            title: Text(
              widget.sillername,
              style: TextStyle(color: Colors.white),
            ),
            headerWidget: Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 228, 237, 255),
                  width: Get.width,
                  height: Get.height,
                  child: ImagePixels.container(
                      imageProvider: NetworkImage(widget.sillerlogo),
                      colorAlignment: Alignment.center,
                      child: Image.network(
                        widget.sillerlogo,
                        fit: BoxFit.fitWidth,
                      )),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(206, 0, 0, 0),
                      Colors.transparent
                    ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: Get.height / 20, right: Get.width / 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.sillername,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Get.height / 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.silleraddress,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: Get.height / 50,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return editlocaitno(
                                      latitude: latitude,
                                      longtude: longtude,
                                      locationname: widget.sillername,
                                      isupdate: false,
                                    );
                                  })));
                                },
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  size: Get.height / 30,
                                  color: provider.orange,
                                )),
                          ],
                        ),
                        FittedBox(
                          child: Text(
                            widget.sillerdiscription + "متجر الكتروني",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.height / 67,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: [
              selectedtypesearch != 'الكل'
                  ? goods(
                      mykey: '180',
                      userref: FirebaseFirestore.instance
                          .collection('products')
                          .where('seller_number', isEqualTo: widget.sillerphone)
                          .where('type', isEqualTo: selectedtypesearch)
                          .withConverter<Welcome>(
                              fromFirestore: (snapshot, _) =>
                                  (Welcome.fromJson(snapshot.data()!)),
                              toFirestore: (user, _) => user.toJson()),
                    )
                  : goods(
                      mykey: '200',
                      userref: FirebaseFirestore.instance
                          .collection('products')
                          .where('seller_number', isEqualTo: widget.sillerphone)
                          .orderBy('number', descending: true)
                          .withConverter<Welcome>(
                              fromFirestore: (snapshot, _) =>
                                  (Welcome.fromJson(snapshot.data()!)),
                              toFirestore: (user, _) => user.toJson()),
                    ),
              const SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
    );
  }

  String doc = '';
  String selectedtypesearch = 'الكل';
  List<String> people = [];
  void getdata() async {
    people.clear();
    people.add('الكل');
    await FirebaseFirestore.instance
        .collection("categorys")
        .get()
        .then((value) {
      for (var element in value.docs) {
        setState(() {
          people.add(element.data()['name']);
        });
      }
    });
  }

  String latitude = "";
  String longtude = "";

  showstorelocation() {}
}

// ignore: camel_case_types
