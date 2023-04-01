// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../others/provider1.dart';
import '../home/converter.dart';
import '../other/item_details.dart';
import '../other/likedbutton.dart';

class goods extends StatefulWidget {
  final Query<Welcome> userref;
  final mykey;
  const goods({Key? key, required this.userref, required this.mykey})
      : super(key: key);

  @override
  State<goods> createState() => goodsState();
}

class goodsState extends State<goods> {
  static shammer() {
    return Container(
        margin: const EdgeInsets.only(bottom: 12, right: 10, left: 10),
        width: Get.width / 2,
        height: 320,
        child: Shimmer(
          period: const Duration(milliseconds: 1200),
          gradient: const LinearGradient(
              colors: [Color.fromARGB(0, 125, 125, 125), Colors.white]),
          loop: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                height: 150,
                width: Get.width,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  height: 20,
                  width: Get.width / 2.5,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  height: 20,
                  width: Get.width / 3.5,
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Goods(provider: provider);
  }

  Goods({provider}) {
    return FirestoreQueryBuilder(
        pageSize: 3000,
        query: widget.userref,
        builder: (context1, snapshot, _) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: Get.width / 1.9,
                mainAxisExtent: Get.height / 3.5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return !snapshot.hasData
                  ? Container()
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 1500),
                        verticalOffset: 6,
                        child: FadeInAnimation(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 1500),
                          child: snapshot.isFetching
                              ? shammer()
                              : Container(
                                  height: Get.height / 10,
                                  margin: EdgeInsets.only(
                                    right: Get.width / 17,
                                    left: Get.width / 17,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ItemDetails(
                                            mykey: widget.mykey,
                                            brand: snapshot.docs[index]
                                                ['brand'],
                                            discription: snapshot.docs[index]
                                                ['discription'],
                                            sillername: snapshot.docs[index]
                                                ['siller'],
                                            name: snapshot.docs[index]['name'],
                                            price: snapshot.docs[index]
                                                ['price'],
                                            size: snapshot.docs[index]['size'],
                                            type: snapshot.docs[index]['type'],
                                            quantity: snapshot.docs[index]
                                                ['quantity'],
                                            people: snapshot.docs[index]
                                                ['people'],
                                            pictures: snapshot.docs[index]
                                                ['pictures'],
                                            docid: snapshot.docs[index]
                                                ['docid'],
                                          ),
                                          type: PageTransitionType.fade,
                                          duration:
                                              const Duration(milliseconds: 280),
                                          reverseDuration:
                                              const Duration(milliseconds: 280),
                                        ),
                                      );
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: the_items(
                                        provider: provider,
                                        mykey: widget.mykey,
                                        docid: snapshot.docs[index]['docid'],
                                        name: snapshot.docs[index]['name'],
                                        sillername: snapshot.docs[index]
                                            ['siller'],
                                        price: snapshot.docs[index]['price'],
                                        size: snapshot.docs[index]['size'],
                                        type: snapshot.docs[index]['type'],
                                        quantity: snapshot.docs[index]
                                            ['quantity'],
                                        people: snapshot.docs[index]['people'],
                                        pictures: snapshot.docs[index]
                                            ['pictures']),
                                  ),
                                ),
                          // child: Column(
                          //   children: [
                          //     for (int i = 0;
                          //         i < snapshot.docs[index]['pictures'].length;
                          //         i++)
                          //       Text('${snapshot.docs[index]['pictures'][i]}')
                          //   ],
                          // ),
                        ),
                      ),
                    );
            },
          );
        });
  }

  static the_items(
      {name,
      price,
      issug = false,
      required mykey,
      required provider,
      size,
      type,
      quantity,
      people,
      pictures,
      sillername,
      docid}) {
    return Column(
      children: [
        Container(
          height: Get.height / 3.8,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: provider.colortheme,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(13, 0, 0, 0),
                  offset: Offset(4, 4),
                  blurRadius: 7,
                  spreadRadius: 3.0,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 3, top: 3),
                      child: likebutton(
                        docid: docid,
                      )),
                  //  deleteitem(docid: docid,)
                  Container(
                    height: Get.height / 36,
                    width: Get.width / 5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'نفذت الكمية !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Get.height / 80,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              !issug
                  ? Expanded(
                      child: Hero(
                      tag: docid + mykey,
                      child: SizedBox(
                        width: Get.width,
                        child: FadeInImage(
                          placeholder: const AssetImage('pictures/third2.png'),
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(pictures[0]),
                        ),
                      ),
                    ))
                  : Expanded(
                      child: SizedBox(
                      width: Get.width,
                      child: FadeInImage(
                        placeholder: const AssetImage('pictures/third2.png'),
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(pictures[0]),
                      ),
                    )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: Get.height / 64,
                              wordSpacing: 2,
                              color: provider.black,
                              // ignore: prefer_const_literals_to_create_immutables
                              shadows: [
                                const BoxShadow(
                                  color: Color.fromARGB(27, 120, 120, 120),
                                  offset: Offset(4, 4),
                                  blurRadius: 7,
                                  spreadRadius: 3.0,
                                )
                              ]),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "$price ريال",
                        style: TextStyle(
                            fontSize: Get.height / 68,
                            color: const Color.fromARGB(195, 255, 123, 0),
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(56, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 3.0,
                              )
                            ]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2, right: 5),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "البائع: " + sillername,
                        style: TextStyle(
                            fontSize: Get.height / 68,
                            color: provider.black,
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(56, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 3.0,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class goods2 extends StatefulWidget {
  final Query<Welcome> userref;
  // ignore: prefer_typing_uninitialized_variables
  final confirm;
  String? searchtext;
  bool isnamesarch;
  bool issearch;
  final mykey;
  goods2(
      {Key? key,
      required this.userref,
      required this.confirm,
      this.searchtext,
      this.isnamesarch = true,
      this.issearch = true,
      required this.mykey})
      : super(key: key);
  @override
  State<goods2> createState() => goods2State();
}

class goods2State extends State<goods2> {
  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
        pageSize: 3000,
        query: widget.userref,
        builder: (context1, snapshot, _) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              bool isfav =
                  likebutton.userfa.contains(snapshot.docs[index]['docid']);
              return AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 120),
                duration: const Duration(milliseconds: 130),
                child: SlideAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 2200),
                  verticalOffset: 10,
                  child: FadeInAnimation(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 2000),
                    child: snapshot.isFetching
                        ? shammer()
                        : Container(
                            height: widget.issearch
                                ? widget.confirm
                                    ? (!likebutton.userfa.contains(
                                            snapshot.docs[index]['docid'])
                                        ? 0
                                        : Get.height / 6)
                                    : widget.isnamesarch
                                        ? snapshot.docs[index]['name']
                                                .contains(widget.searchtext)
                                            ? Get.height / 6
                                            : 0
                                        : snapshot.docs[index]['brand']
                                                .contains(widget.searchtext)
                                            ? Get.height / 6
                                            : 0
                                : Get.height / 6,
                            width: Get.width,
                            margin: widget.confirm
                                ? EdgeInsets.only(
                                    right: isfav ? 8 : 0,
                                    left: isfav ? 8 : 0,
                                    top: isfav ? 10 : 0)
                                : EdgeInsets.only(
                                    bottom: snapshot.docs[index]['name']
                                            .contains(widget.searchtext)
                                        ? 12
                                        : 0,
                                    right: 10,
                                    left: 10),
                            // decoration: const BoxDecoration(
                            //     borderRadius:  BorderRadius.only(
                            //         bottomRight: Radius.circular(17),
                            //         bottomLeft: Radius.circular(17),
                            //         topRight: Radius.circular(17),
                            //         topLeft: Radius.circular(17)),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.black12,
                            //         offset: Offset(0, 0),
                            //         blurRadius: 6,
                            //         spreadRadius: 1.0,
                            //       )
                            //     ]),
                            child: !likebutton.userfa.contains(
                                        snapshot.docs[index]['docid']) &&
                                    widget.confirm
                                ? null
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ItemDetails(
                                            mykey: '10',
                                            brand: snapshot.docs[index]
                                                ['brand'],
                                            discription: snapshot.docs[index]
                                                ['discription'],
                                            sillername: snapshot.docs[index]
                                                ['siller'],
                                            name: snapshot.docs[index]['name'],
                                            price: snapshot.docs[index]
                                                ['price'],
                                            size: snapshot.docs[index]['size'],
                                            type: snapshot.docs[index]['type'],
                                            quantity: snapshot.docs[index]
                                                ['quantity'],
                                            people: snapshot.docs[index]
                                                ['people'],
                                            pictures: snapshot.docs[index]
                                                ['pictures'],
                                            docid: snapshot.docs[index]
                                                ['docid'],
                                          ),
                                          type: PageTransitionType.fade,
                                          duration:
                                              const Duration(milliseconds: 280),
                                          reverseDuration:
                                              const Duration(milliseconds: 280),
                                        ),
                                      );
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: the_items(
                                        mykey: '10',
                                        docid: snapshot.docs[index]['docid'],
                                        name: snapshot.docs[index]['name'],
                                        sillername: snapshot.docs[index]
                                            ['siller'],
                                        price: snapshot.docs[index]['price'],
                                        size: snapshot.docs[index]['size'],
                                        type: snapshot.docs[index]['type'],
                                        quantity: snapshot.docs[index]
                                            ['quantity'],
                                        people: snapshot.docs[index]['people'],
                                        pictures: snapshot.docs[index]
                                            ['pictures'],
                                        brand: snapshot.docs[index]['brand']),
                                  ),
                          ),
                  ),
                ),
              );
            },
          );
        });
  }

  static shammer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, right: 10, left: 10),
      width: Get.width / 1.1,
      height: Get.height / 6,
      child: Shimmer(
          period: const Duration(milliseconds: 700),
          gradient: const LinearGradient(
              colors: [Color.fromARGB(0, 125, 125, 125), Colors.white]),
          loop: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Get.height / 40,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: Get.height / 35,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: Get.height / 35,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                height: Get.height,
                width: Get.width / 3,
              )
            ],
          )),
    );
  }

  Container the_items(
      {name,
      required mykey,
      price,
      size,
      type,
      quantity,
      people,
      pictures,
      sillername,
      docid,
      brand}) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: provider.colortheme,
        boxShadow: provider.containershadow,
        border: Border.all(
          color: provider.white,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  likebutton(docid: docid),
                  Container(
                    margin: const EdgeInsets.only(right: 13),
                    height: Get.height / 36,
                    width: Get.width / 5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 0.8)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'نفذت الكمية !',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Get.height / 77),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: Get.height / 50,
                            wordSpacing: 5,
                            color: provider.black,
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(27, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 7,
                                spreadRadius: 3.0,
                              )
                            ]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "$price ريال",
                        style: TextStyle(
                            fontSize: Get.height / 55,
                            color: const Color.fromARGB(195, 255, 123, 0),
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(56, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 3.0,
                              )
                            ]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "البائع : " + sillername,
                        style: TextStyle(
                            fontSize: Get.height / 60,
                            color: provider.black,
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(56, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 10,
                                spreadRadius: 3.0,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Hero(
            tag: docid + mykey,
            child: SizedBox(
              height: Get.height,
              width: Get.width / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FadeInImage(
                  placeholder: const AssetImage('pictures/third2.png'),
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(pictures[0]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
