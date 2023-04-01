import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:get/get.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/search/goods.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../others/provider1.dart';
import '../converter.dart';

// ignore: camel_case_types
class categorygoods extends StatefulWidget {
  final name;
  final picture;
  final index;
  const categorygoods({Key? key, this.name, this.picture, this.index})
      : super(key: key);

  @override
  State<categorygoods> createState() => _categorygoodsState();
}

// ignore: camel_case_types
class _categorygoodsState extends State<categorygoods> {
  String selectedtypesearch = 'الكل';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Color randomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
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
              leading: const BackButton(color: Colors.white),
              appBarColor: provider.darckblue,
              alwaysShowLeadingAndAction: true,
              title: Text(
                widget.name,
                style: const TextStyle(color: Colors.white),
              ),
              headerWidget: Hero(
                tag: 'picture ${widget.index}',
                child: Stack(
                  children: [
                    Container(
                      width: Get.width,
                      height: Get.height,
                      child: ImagePixels.container(
                          imageProvider: NetworkImage(widget.picture),
                          colorAlignment: Alignment.topLeft,
                          child: FadeInImage(
                              placeholder:
                                  const AssetImage('pictures/white.jpg'),
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(widget.picture))),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(144, 0, 0, 0),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: Get.height / 20, right: Get.width / 20),
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: Get.height / 37,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: [
                // selectedtypesearch != 'الكل'
                //     ? goods(
                //         mykey: '13',
                //         userref: FirebaseFirestore.instance
                //             .collection('products')
                //             .where('people', isEqualTo: selectedtypesearch)
                //             .where('type', isEqualTo: widget.name)
                //             .withConverter<Welcome>(
                //                 fromFirestore: (snapshot, _) =>
                //                     (Welcome.fromJson(snapshot.data()!)),
                //                 toFirestore: (user, _) => user.toJson()),
                //       )
                //     :
                goods(
                  mykey: '190',
                  userref: FirebaseFirestore.instance
                      .collection('products')
                      .where('type', isEqualTo: widget.name)
                      .where("people",
                          isEqualTo: provider.selelctedcategoryname)
                      .orderBy('number', descending: true)
                      .withConverter<Welcome>(
                          fromFirestore: (snapshot, _) =>
                              (Welcome.fromJson(snapshot.data()!)),
                          toFirestore: (user, _) => user.toJson()),
                )
              ]),
        ),
      ),
    );
  }

  // List<String> people = [];
  // void getdata() async {
  //   people.clear();
  //   people.add('الكل');
  //   await FirebaseFirestore.instance.collection("people").get().then((value) {
  //     for (var element in value.docs) {
  //       setState(() {
  //         people.add(element.data()['name']);
  //       });
  //     }
  //   });
  // }
}
