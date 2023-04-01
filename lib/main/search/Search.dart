import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lebask/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lebask/main/home/Home.dart';
import 'package:lebask/main/search/goods.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../others/provider1.dart';
import '../home/converter.dart';
import '../other/item_details.dart';
import '../../sillers/silleritems.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  State<Searchpage> createState() => _SearchpageState();
}

bool focus = false;
String text = '';
List<String> typeofsearch = [
  'بائع',
  'مُنتج',
  'ماركة',
];
String? selected = 'مُنتج';
String selectedtypesearch = 'مُنتج';
String searchholder = 'أختر نوع البحث !';

class _SearchpageState extends State<Searchpage> {
  late FocusNode myFocusNode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    selectedtypesearch = 'الكل';
  }

  updatestate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Get.height / 19),
              child: AppBar(
                leading: null,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        // ignore: deprecated_member_use
                        FontAwesomeIcons.search,
                        size: Get.height / 38,
                        color: Colors.black,
                      )),
                  const SizedBox(width: 20),
                ],
                backgroundColor: provider.orange.withOpacity(0.8),
                title: ClipRRect(
                  child: Stack(
                    children: [
                      TextField(
                        focusNode: myFocusNode,
                        style: TextStyle(color: provider.black, fontSize: 18),
                        autofocus: false,
                        onTap: () {},
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                          fillColor: provider.orange.withOpacity(0),
                          filled: true,
                          hintText: selectedtypesearch == 'الكل'
                              ? searchholder
                              : "البحث عن $selectedtypesearch",
                          hintStyle: TextStyle(
                              height: 1, color: provider.black, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //! fix this later babe
                    // Container(
                    //   height: Get.height / 10,
                    //   padding: EdgeInsets.only(right: 20, bottom: 7, top: 7),
                    //   decoration: BoxDecoration(
                    //       color: provider.lightblue2,
                    //       borderRadius: BorderRadius.circular(7),
                    //       boxShadow: const [
                    //         BoxShadow(
                    //           color: Color.fromARGB(13, 0, 0, 0),
                    //           offset: Offset(4, 4),
                    //           blurRadius: 7,
                    //           spreadRadius: 3.0,
                    //         )
                    //       ]),
                    //   width: double.infinity,
                    //   margin:
                    //       const EdgeInsets.only(top: 0, left: 20, right: 20),
                    //   child: TextField(
                    //     focusNode: myFocusNode,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         text = value;
                    //       });
                    //     },
                    //     decoration: InputDecoration(
                    //       hintText: selectedtypesearch == 'الكل'
                    //           ? searchholder
                    //           : "البحث عن $selectedtypesearch",
                    //       border: InputBorder.none,
                    //       labelStyle: TextStyle(height: 1.2),
                    //     ),
                    //     keyboardType: TextInputType.name,
                    //     style: const TextStyle(fontSize: 15, height: 2),
                    //   ),
                    // ),
                    searcktype(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin:
                            EdgeInsets.only(top: Get.height / 65, right: 13),
                        child: Text(
                          selectedtypesearch == 'الكل'
                              ? 'الأكثر مبيعًا'
                              : (selectedtypesearch != 'بائع'
                                  ? "تم إيجاد"
                                  : 'الباعة'),
                          style: TextStyle(fontSize: Get.height / 48),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: Get.height / 50,
                    ),
                    if (selectedtypesearch == 'الكل') mostsells(),
                    selectedtypesearch != 'بائع' && selectedtypesearch != 'الكل'
                        ? goods2(
                            mykey: '889',
                            userref: FirebaseFirestore.instance
                                .collection('products')
                                .orderBy('number')
                                .withConverter<Welcome>(
                                    fromFirestore: (snapshot, _) =>
                                        (Welcome.fromJson(snapshot.data()!)),
                                    toFirestore: (user, _) => user.toJson()),
                            confirm: false,
                            searchtext: text,
                            isnamesarch:
                                selectedtypesearch == 'ماركة' ? false : true,
                          )
                        : selectedtypesearch != 'الكل'
                            ? sillers()
                            : Container()
                  ],
                ))));
  }

  mostsells() {
    Query<Welcome> userref = FirebaseFirestore.instance
        .collection('products')
        .limit(3)
        .orderBy('silled', descending: true)
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return FirestoreQueryBuilder(
        pageSize: 30,
        query: userref,
        builder: (context1, snapshot, _) {
          return Container(
            height: Get.height / 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return snapshot.isFetching
                    ? homeState().shimmer()
                    : AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 200),
                        delay: const Duration(milliseconds: 220),
                        child: SlideAnimation(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 2500),
                          verticalOffset: 10,
                          child: FadeInAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: Duration(milliseconds: 2000),
                            child: Container(
                              width: Get.width / 2.8,
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ItemDetails(
                                        mykey: '12',
                                        brand: snapshot.docs[index]['brand'],
                                        discription: snapshot.docs[index]
                                            ['discription'],
                                        sillername: snapshot.docs[index]
                                            ['siller'],
                                        name: snapshot.docs[index]['name'],
                                        price: snapshot.docs[index]['price'],
                                        size: snapshot.docs[index]['size'],
                                        type: snapshot.docs[index]['type'],
                                        quantity: snapshot.docs[index]
                                            ['quantity'],
                                        people: snapshot.docs[index]['people'],
                                        pictures: snapshot.docs[index]
                                            ['pictures'],
                                        docid: snapshot.docs[index]['docid'],
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
                                child: goodsState.the_items(
                                    provider: provider,
                                    mykey: '12',
                                    name: snapshot.docs[index]['name'],
                                    sillername: snapshot.docs[index]['siller'],
                                    price: snapshot.docs[index]['price'],
                                    size: snapshot.docs[index]['size'],
                                    type: snapshot.docs[index]['type'],
                                    quantity: snapshot.docs[index]['quantity'],
                                    people: snapshot.docs[index]['people'],
                                    pictures: snapshot.docs[index]['pictures'],
                                    docid: snapshot.docs[index]['docid']),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          );
        });
  }

  int selectedpage = 5;

  searcktype() {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.only(top: 13, right: 13),
            child: Text(
              'بحث عن',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const Divider(
            thickness: 1.5,
          ),
          SizedBox(
            height: 70,
            width: Get.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: typeofsearch.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 130),
                        child: SlideAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 2500),
                            verticalOffset: 10,
                            child: FadeInAnimation(
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: Duration(milliseconds: 2000),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 6, left: 4, right: index != 0 ? 0 : 7),
                                child: Center(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          selectedpage = index;
                                          setState(() {
                                            selectedtypesearch =
                                                typeofsearch[index];
                                            myFocusNode.requestFocus();
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            right: Get.height / 41,
                                            left: Get.height / 41,
                                            top: Get.height / 92,
                                            bottom: Get.height / 92,
                                          ),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: selectedpage == index
                                                    ? provider.orange
                                                    : Colors.grey,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            typeofsearch[index],
                                            style: TextStyle(
                                                fontWeight:
                                                    selectedpage == index
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                fontSize: Get.height / 56,
                                                color: selectedpage != index
                                                    ? const Color.fromARGB(
                                                        221, 158, 158, 158)
                                                    : provider.orange),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  sillers() {
    Query<Welcome> userref = FirebaseFirestore.instance
        .collection('sillers')
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());

    return FirestoreQueryBuilder(
        pageSize: 1000,
        query: userref,
        builder: (context1, snapshot, _) {
          Counterprovider provider = Provider.of<Counterprovider>(context);

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 2500),
                  verticalOffset: 10,
                  child: FadeInAnimation(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(milliseconds: 2000),
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: Get.height / 80),
                      alignment: Alignment.topCenter,
                      height: Get.height / 13,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                  child: silleritems(
                                    sillerlogo: snapshot.docs[index]['logo'],
                                    sillerdiscription: '',
                                    silleraddress: snapshot.docs[index]
                                        ['address'],
                                    sillername: snapshot.docs[index]['name'],
                                    sillerphone: snapshot.docs[index]['phone'],
                                  ),
                                  alignment: Alignment.topCenter,
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 280),
                                ));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage('pictures/white3.jpg'),
                                    fit: BoxFit.fitWidth,
                                    height: Get.height / 10,
                                    image: NetworkImage(
                                        snapshot.docs[index]['logo']),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width / 6),
                                  child: Text(
                                    snapshot.docs[index]['name'],
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: provider.black,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        shadows: [
                                          const BoxShadow(
                                            color: Color.fromARGB(77, 0, 0, 0),
                                            offset: Offset(4, 4),
                                            blurRadius: 10,
                                            spreadRadius: 3.0,
                                          )
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                    size: Get.width / 20,
                                  ),
                                )
                              ])),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}





/*

    setState(() {
                          selectedtypesearch = e;
                          myFocusNode.requestFocus();
                        });
                        
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 120),
                            duration: const Duration(milliseconds: 130),
                            child: SlideAnimation(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration:const Duration(milliseconds: 2500),
                                verticalOffset: 10,
                                child: FadeInAnimation(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  duration: Duration(milliseconds: 2000),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 6,
                                        left: 4,
                                        right: index != 0 ? 0 : 7),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              selectedpage = index;
                                              selectedcategory =
                                                  snapshot.docs[index]['name'];
                                              provider.categorys(
                                                  snapshot.docs[index]['docid'],
                                                  snapshot.docs[index]['name']);
                                              print(snapshot.docs[index]
                                                  ['docid']);
                                              setState(() {
                                                change();
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                right: Get.height / 41,
                                                left: Get.height / 41,
                                                top: Get.height / 92,
                                                bottom: Get.height / 92,
                                              ),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: selectedpage == index
                                                        ? provider.orange
                                                        : Colors.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                snapshot.docs[index]['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        selectedpage == index
                                                            ? FontWeight.w600
                                                            : FontWeight.w500,
                                                    fontSize: Get.height / 56,
                                                    color: selectedpage != index
                                                        ? const Color.fromARGB(
                                                            221, 158, 158, 158)
                                                        : provider.orange),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))),
                      ],
                    );
                  },
                ),
                */