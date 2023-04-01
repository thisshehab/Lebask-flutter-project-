import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/search/goods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../others/provider1.dart';
import '../home/Home.dart';
import '../home/converter.dart';
import 'likedbutton.dart';
import 'navbar.dart';

// ignore: must_be_immutable
class ItemDetails extends StatefulWidget {
  static var usercartitem = [];
  static var useritemname = [];
  static var usercartdoc = [];
  static var userphoto = [];
  static var userquantity = [];
  static var usersize = [];
  static var userprice = [];

  static String orderdoc = '';
  // ignore: prefer_typing_uninitialized_variables
  final name;
  final pictures;
  final calledfromcart;
  final price;
  final people;
  final type;
  String? type2;
  final size;
  final quantity;
  final docid;
  final sillername;
  final brand;
  final discription;
  final updatehome;
  final mykey;
  bool issug;

  ItemDetails(
      {Key? key,
      required this.name,
      required this.pictures,
      required this.price,
      required this.people,
      required this.type,
      required this.size,
      required this.quantity,
      required this.docid,
      required this.sillername,
      required this.brand,
      required this.discription,
      this.issug = false,
      type2,
      this.updatehome,
      this.calledfromcart = false,
      required this.mykey})
      : super(key: key);
  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  List<dynamic> pictur = [];
  int? firstsize;
  int? secondsize;
  List arrayofsize = [];
  String selectedsize = '0';
  int quantity = 1;
  bool buy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pictur.addAll(widget.pictures);
    getsize();
    getthemaxvalue();
    widget.calledfromcart
        ? selectedsize =
            ItemDetails.usersize[ItemDetails.usercartitem.indexOf(widget.docid)]
        : '0';
    gettheorderstate();
  }

  getsize() {
    final splitted = widget.size.split('-');
    try {
      if (splitted.length == 2) {
        firstsize = int.parse(splitted[0]);
        secondsize = int.parse(splitted[1]);
        for (int i = firstsize!; i <= secondsize!; i++) {
          arrayofsize.add(i.toString());
        }
      } else {
        arrayofsize.addAll(splitted);
      }
    } catch (e) {
      arrayofsize.addAll(splitted);
    }
  }

  int myindex = 0;
  bool myval = false;

  final controller = ScrollController();

  scrolldown() {
    final double end = controller.position.maxScrollExtent;
    controller.animateTo(end,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    //Color randomColor() => Color.fromRGBO(140, 220, Random().nextInt(255), 1);
    // Color randomColor() => Color.fromRGBO(
    //     Random().nextInt(256 - 240 + 1), Random().nextInt(256 - 240 + 1), Random().nextInt(256 - 200 + 1), 1);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: SizedBox(
                height: Get.height / 15,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(bottom: 0),
                    height: Get.height / 16.5,
                    width: !buy ? Get.width / 2.5 : Get.height / 16.5,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          if (buy) {
                            int random = Random().nextInt(randomnumber);
                            FirebaseFirestore.instance
                                .collection('products')
                                .where('number', isEqualTo: random)
                                .limit(1)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: ItemDetails(
                                      issug: true,
                                      mykey: '1',
                                      brand: element.data()['brand'],
                                      discription:
                                          element.data()['discription'],
                                      sillername: element.data()['siller'],
                                      name: element.data()['name'],
                                      price: element.data()['price'],
                                      size: element.data()['size'],
                                      type: element.data()['type'],
                                      quantity: element.data()['quantity'],
                                      people: element.data()['people'],
                                      pictures: element.data()['pictures'],
                                      docid: element.data()['docid'],
                                    ),
                                    type: PageTransitionType.leftToRight,
                                    duration: const Duration(milliseconds: 280),
                                    reverseDuration:
                                        const Duration(milliseconds: 280),
                                  ),
                                );
                              }
                            });
                          }
                          // ignore: empty_catches
                        } catch (e) {}
                        if (!buy) {
                          addtocart();
                        }
                        setState(() {
                          buy = true;

                          //  scrolldown();
                        });
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            provider.yellow.withAlpha(100)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: !buy
                              ? BorderRadius.circular(10.0)
                              : BorderRadius.circular(50),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(provider.orange),
                      ),
                      child: !buy
                          ? Text("إضافة للسلة",
                              style: TextStyle(
                                  fontSize: Get.height / 50,
                                  color: Colors.black))
                          : const Icon(Icons.arrow_forward),
                    ),
                  ),
                )),
            body: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: Get.height / 2.6,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(33, 0, 0, 0),
                                offset: Offset(5, 20),
                                blurRadius: 20,
                                spreadRadius: 3.0,
                              )
                            ],
                            color: provider.continercolor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(Get.width / 9),
                                bottomLeft: Radius.circular(Get.width / 9))),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height / 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: Get.height / 17,
                                      width: Get.height / 17,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            provider.orange,
                                            provider.yellow
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.black,
                                          size: Get.height / 33,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      height: Get.height / 4,
                                      width: Get.width / 6.5,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: pictur.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                                myindex = index;
                                                if (ItemDetails.usercartitem
                                                    .contains(widget.docid)) {
                                                  updateimage();
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  border: Border.all(
                                                    width: Get.height / 320,
                                                    color: index == myindex
                                                        ? provider.orange
                                                        : provider.darckblue,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          64, 0, 0, 0),
                                                      offset: Offset(5, 3),
                                                      blurRadius: 3,
                                                      spreadRadius: 1.0,
                                                    )
                                                  ]),
                                              margin: EdgeInsets.only(
                                                  top: 12,
                                                  right: Get.width / 60),
                                              height: Get.width / 8,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: FadeInImage(
                                                  placeholder: const AssetImage(
                                                      'pictures/third2.png'),
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      pictur[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  !widget.issug
                                      ? Hero(
                                          tag: widget.docid + widget.mykey,
                                          child: FittedBox(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: Get.height / 44),
                                              height: Get.height / 3.4,
                                              width: Get.width / 1.5,
                                              decoration: const BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          31, 255, 255, 255),
                                                      offset: Offset(10, 10),
                                                      blurRadius: 15,
                                                      spreadRadius: 3.0,
                                                    )
                                                  ]),
                                              child: InkWell(
                                                onTap: () {
                                                  MultiImageProvider
                                                      multiImageProvider =
                                                      MultiImageProvider([
                                                    ...pictur.map((e) =>
                                                        Image.network(e).image)
                                                  ], initialIndex: myindex);

                                                  showImageViewerPager(
                                                      useSafeArea: true,
                                                      immersive: false,
                                                      context,
                                                      multiImageProvider,
                                                      onPageChanged: (page) {},
                                                      onViewerDismissed:
                                                          (page) {});
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(17)),
                                                  child: FadeInImage(
                                                    placeholder: provider
                                                        .placeolderimage,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        pictur[myindex]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : FittedBox(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Get.height / 44),
                                            height: Get.height / 3.4,
                                            width: Get.width / 1.5,
                                            decoration:
                                                const BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    31, 255, 255, 255),
                                                offset: Offset(10, 10),
                                                blurRadius: 15,
                                                spreadRadius: 3.0,
                                              )
                                            ]),
                                            child: InkWell(
                                              onTap: () {
                                                MultiImageProvider
                                                    multiImageProvider =
                                                    MultiImageProvider([
                                                  ...pictur.map((e) =>
                                                      Image.network(e).image)
                                                ], initialIndex: myindex);
                                                showImageViewerPager(
                                                    useSafeArea: true,
                                                    immersive: false,
                                                    context,
                                                    multiImageProvider,
                                                    onPageChanged: (page) {},
                                                    onViewerDismissed:
                                                        (page) {});
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(17)),
                                                child: FadeInImage(
                                                  placeholder:
                                                      provider.placeolderimage,
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      pictur[myindex]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${myindex + 1}/${pictur.length}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 8),
                                    child: likebutton(
                                      docid: widget.docid,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height / 300,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height / 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: Get.width / 15),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: Get.height / 38,
                                fontWeight: FontWeight.w400,

                                // ignore: prefer_const_literals_to_create_immutables
                                shadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(36, 0, 0, 0),
                                    offset: Offset(-4, 4),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width / 15, top: 5),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${widget.price} ريال',
                            style: TextStyle(
                                fontSize: Get.height / 46,
                                fontWeight: FontWeight.w400,
                                // ignore: prefer_const_literals_to_create_immutables
                                shadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(37, 0, 0, 0),
                                    offset: Offset(-4, 4),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: Get.width / 15, top: 2),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            'الفئة: ' + widget.people,
                            style: TextStyle(
                                fontSize: Get.height / 70,
                                color: provider.gray2,
                                // ignore: prefer_const_literals_to_create_immutables
                                shadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(57, 0, 0, 0),
                                    offset: Offset(-4, 4),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width / 15, top: 2),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'البائع: ' + widget.sillername,
                            style: TextStyle(
                                fontSize: Get.height / 70,
                                color: provider.gray2,
                                // ignore: prefer_const_literals_to_create_immutables
                                shadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(37, 0, 0, 0),
                                    offset: Offset(-4, 4),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider(
                  //   thickness: 1.2,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(right: Get.width / 15, top: 3),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'الماركة: ' + widget.brand,
                        style: TextStyle(
                            fontSize: Get.height / 63,
                            color: const Color.fromARGB(255, 187, 112, 0),
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(37, 0, 0, 0),
                                offset: Offset(-4, 4),
                                blurRadius: 10,
                                spreadRadius: 1.0,
                              )
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    height: 50,
                    padding: EdgeInsets.only(right: Get.width / 15, top: 3),
                    child: FittedBox(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          'الوصف: ' + widget.discription,
                          style: TextStyle(
                              fontSize: Get.height / 63,
                              color: const Color.fromARGB(255, 187, 112, 0),
                              // ignore: prefer_const_literals_to_create_immutables
                              shadows: [
                                const BoxShadow(
                                  color: Color.fromARGB(37, 0, 0, 0),
                                  offset: Offset(-4, 4),
                                  blurRadius: 10,
                                  spreadRadius: 1.0,
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: Get.width / 30),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'المقاسات المتوفرة :',
                        style: TextStyle(
                            fontSize: Get.width / 27,
                            color: provider.gray2,
                            // ignore: prefer_const_literals_to_create_immutables
                            shadows: [
                              const BoxShadow(
                                color: Color.fromARGB(37, 0, 0, 0),
                                offset: Offset(-4, 4),
                                blurRadius: 10,
                                spreadRadius: 1.0,
                              )
                            ]),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (arrayofsize[0] == '')
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 18, bottom: 18),
                                child: const Text('لم يتم ادخال مقاسات')),
                          ...arrayofsize
                              .map(
                                (value) => InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      selectedsize = value;
                                      if (ItemDetails.usercartitem
                                          .contains(widget.docid)) {
                                        updatesize();
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 12, bottom: 8),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(24, 0, 0, 0),
                                              offset: Offset(3, 5),
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: value == selectedsize ||
                                                (widget.calledfromcart
                                                    ? ItemDetails.usersize[
                                                            ItemDetails
                                                                .usercartitem
                                                                .indexOf(widget
                                                                    .docid)] ==
                                                        value
                                                    : 0 > 1)
                                            ? provider.orange
                                            : provider.white),
                                    padding:
                                        EdgeInsets.all(value != '' ? 10 : 0),
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(
                                          fontSize: Get.height / 55,
                                          color: value == selectedsize ||
                                                  (widget.calledfromcart
                                                      ? ItemDetails.usersize[
                                                              ItemDetails
                                                                  .usercartitem
                                                                  .indexOf(widget
                                                                      .docid)] ==
                                                          value
                                                      : 0 > 1)
                                              ? provider.white
                                              : provider.black),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: Get.width / 30, top: 10, bottom: 14),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                widget.quantity > 0
                                    ? 'الكمية المتوفرة: ${widget.quantity}'
                                    : 'نفذت الكمية !',
                                style: TextStyle(
                                    fontSize: Get.width / 30,
                                    color: provider.gray2,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    shadows: [
                                      const BoxShadow(
                                        color: Color.fromARGB(37, 0, 0, 0),
                                        offset: Offset(-4, 4),
                                        blurRadius: 10,
                                        spreadRadius: 1.0,
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 4, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: Get.height / 30,
                                  width: Get.height / 30,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        provider.orange,
                                        provider.yellow
                                      ]),
                                      borderRadius: BorderRadius.circular(70)),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity =
                                            quantity > 1 ? --quantity : 1;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: Get.height / 60,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontFamily: "Tajawal",
                                  ),
                                ),
                                Container(
                                  height: Get.height / 22,
                                  width: Get.height / 22,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        provider.orange,
                                        provider.yellow
                                      ]),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (widget.quantity - 1 < quantity) {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.rightSlide,
                                              headerAnimationLoop: false,
                                              title: 'Error',
                                              desc:
                                                  'الكمية المطلوبة أكبر من الموجودة في المخزون',
                                              btnOkOnPress: () {},
                                              btnOkIcon: Icons.cancel,
                                              btnOkColor: Colors.red,
                                            ).show();
                                          } else {
                                            quantity++;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: Get.height / 40,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    "${int.parse(widget.price) * quantity} ريال",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width / 15),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            selectedsize == '0'
                                ? "أختر مقاس !"
                                : 'المقاس المُختار : $selectedsize',
                            style: TextStyle(
                                fontSize: Get.height / 65,
                                color: provider.gray2,
                                // ignore: prefer_const_literals_to_create_immutables
                                shadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(37, 0, 0, 0),
                                    offset: Offset(-4, 4),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Get.width / 50),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'مُنتجات مُشابهة',
                        style: TextStyle(
                            fontSize: Get.height / 50,
                            color: provider.gray2,
                            // ignore: prefer_const_literalto_create_immutables
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(37, 0, 0, 0),
                                offset: Offset(-4, 4),
                                blurRadius: 10,
                                spreadRadius: 1.0,
                              )
                            ]),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1.5,
                  ),

                  sug(),
                ],
              ),
            )),
      ),
    );
  }

  // isempty() {
  //   String? hasdata;
  //   var m = FirebaseFirestore.instance
  //       .collection('products')
  //       .where('type', isEqualTo: widget.type)
  //       .where('people', isEqualTo: widget.people)
  //       .get()
  //       .then((value) {
  //     hasdata = value.docs[0].data()['people'];
  //   });
  //   if (hasdata != null) return false;
  //   else return true;
  // }

  sug() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    Query<Welcome> userref = FirebaseFirestore.instance
        .collection('products')
        .where('type', isEqualTo: widget.type)
        .where('people', isEqualTo: widget.people)
        .orderBy('silled', descending: true)
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());

    return FirestoreQueryBuilder(
        pageSize: 200,
        query: userref,
        builder: (context1, snapshot, _) {
          return SizedBox(
            height: Get.height / 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              // physics: const BouncingScrollPhysics(),
              itemCount: snapshot.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.docid == snapshot.docs[index]['docid']
                    ? Container(child: null)
                    : AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 200),
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          verticalOffset: 7,
                          child: FadeInAnimation(
                            child: Container(
                              width: Get.width / 2.8,
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return ItemDetails(
                                      mykey: 'eee',
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
                                    );
                                  })));
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: goodsState.the_items(
                                    provider: provider,
                                    issug: true,
                                    mykey: 'eee',
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

  int randomnumber = 0;
  getthemaxvalue() async {
    await FirebaseFirestore.instance
        .collection("products")
        .orderBy('number', descending: true)
        .limit(1)
        .get()
        .then((value) {
      randomnumber = value.docs[0].data()['number'];
      // return value.docs[0].data()['number'] != null
      //     ? value.docs[0].data()['number']
      //     : 0;
    });
  }

  updateimage() async {
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    if (userdoc == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        desc: " !قُم بتسجيل الدخول ",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orange,
      ).show();
      return;
    }
    //get the user cart doc>>>>>>>>>
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where('completed', isEqualTo: false)
        .where('confirmed', isEqualTo: false)
        .limit(1)
        .get()
        .then((value) {
      for (var element1 in value.docs) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userdoc)
            .collection('orders')
            .doc(element1.data()['docid'])
            .collection('products')
            .where('itemid', isEqualTo: widget.docid)
            .get()
            .then((value) {
          for (var element2 in value.docs) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userdoc)
                .collection('orders')
                .doc(element1.data()['docid'])
                .collection('products')
                .doc(element2.data()['docid'])
                .update({'picture': widget.pictures[myindex]});
          }
        });
      }
    });
    ItemDetails.userphoto[ItemDetails.usercartitem.indexOf(widget.docid)] =
        widget.pictures[myindex];
  }

  updatesize() async {
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    if (userdoc == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        desc: " !قُم بتسجيل الدخول ",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orange,
      ).show();
      return;
    }
    //get the user cart doc>>>>>>>>>
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where('completed', isEqualTo: false)
        .where('confirmed', isEqualTo: false)
        .limit(1)
        .get()
        .then((value) {
      for (var element1 in value.docs) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userdoc)
            .collection('orders')
            .doc(element1.data()['docid'])
            .collection('products')
            .where('itemid', isEqualTo: widget.docid)
            .get()
            .then((value) {
          for (var element2 in value.docs) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userdoc)
                .collection('orders')
                .doc(element1.data()['docid'])
                .collection('products')
                .doc(element2.data()['docid'])
                .update({'size': selectedsize});
          }
        });
      }
    });
    ItemDetails.usersize[ItemDetails.usercartitem.indexOf(widget.docid)] =
        selectedsize;
  }

  addtocart() async {
    if (!ItemDetails.usercartitem.contains(widget.docid)) {
      final prefs = await SharedPreferences.getInstance();

      var userdoc = nav2.userdoc ?? prefs.getString('userid');
      if (userdoc == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          headerAnimationLoop: false,
          desc: " !قُم بتسجيل الدخول ",
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.orange,
        ).show();
        return;
      }
      bool? create;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userdoc)
          .collection('orders')
          .where('completed', isEqualTo: false)
          .where('confirmed', isEqualTo: false)
          .limit(1)
          .get()
          .then((value) {
        create = value.docs.isEmpty;
      });
      //this is use if there is another order
      if (thelelvel != null && thelelvel! > 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          headerAnimationLoop: false,
          desc: "عذرا لديك طلب قيد المعالجة، قم بإلغاءه",
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.orange,
        ).show();
        return;
      }
      if (create! || create == null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userdoc)
            .collection('orders')
            .add({
          'completed': false,
          'confirmed': false,
          'currentstep': 0
        }).then((value) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(userdoc)
              .collection('orders')
              .doc(value.id)
              .update({"docid": value.id}).then((value) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userdoc)
                .collection('orders')
                .where('completed', isEqualTo: false)
                .where('confirmed', isEqualTo: false)
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
                    .add({'itemid': widget.docid}).then((value2) {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userdoc)
                      .collection('orders')
                      .doc(element.data()['docid'])
                      .collection('products')
                      .doc(value2.id)
                      .update({
                    'docid': value2.id,
                    'size': selectedsize.toString(),
                    'picture': widget.pictures[myindex],
                    'quantity': quantity,
                    'price': int.parse(widget.price),
                    'item': widget.name
                  });
                  ItemDetails.usercartdoc.add(value2.id);
                  ItemDetails.usercartitem.add(widget.docid);
                  ItemDetails.useritemname.add(widget.name);
                  ItemDetails.userphoto.add(widget.pictures[myindex]);
                  ItemDetails.userquantity.add(quantity);
                  ItemDetails.userprice.add(int.parse(widget.price));
                  ItemDetails.usersize.add(selectedsize);
                });
              }
            });
          });
        });
      }
      //get the user cart doc>>>>>>>>>
      else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userdoc)
            .collection('orders')
            .where('completed', isEqualTo: false)
            .where('confirmed', isEqualTo: false)
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
                .add({'itemid': widget.docid}).then((value2) {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(userdoc)
                  .collection('orders')
                  .doc(element.data()['docid'])
                  .collection('products')
                  .doc(value2.id)
                  .update({
                'docid': value2.id,
                'size': selectedsize.toString(),
                'picture': widget.pictures[myindex],
                'quantity': quantity,
                'price': int.parse(widget.price),
                'item': widget.name
              });
              ItemDetails.usercartdoc.add(value2.id);
              ItemDetails.usercartitem.add(widget.docid);
              ItemDetails.useritemname.add(widget.name);
              ItemDetails.userphoto.add(widget.pictures[myindex]);
              ItemDetails.userquantity.add(quantity);
              ItemDetails.userprice.add(int.parse(widget.price));
              ItemDetails.usersize.add(selectedsize);
            });
          }
        });
      }
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        desc: 'تمت الإضافة للسلة',
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: '! المنتج في السلة ',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orange,
      ).show();
    }
  }

  int? thelelvel;
  gettheorderstate() async {
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .get()
        .then((value) {
      for (var element1 in value.docs) {
        thelelvel = element1.data()['currentstep'];
      }
    });
    print(thelelvel);
    setState(() {});
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return NetworkImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}
