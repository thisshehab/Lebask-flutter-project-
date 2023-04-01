import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../main/home/converter.dart';
import '../../main/other/item_details.dart';
import '../../others/provider1.dart';

class sillerproducts extends StatefulWidget {
  const sillerproducts({super.key});

  @override
  State<sillerproducts> createState() => _sillerproductsState();
}

class _sillerproductsState extends State<sillerproducts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.currentUser;

    print(user!.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    var user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("منتجاتي"),
          leading: BackButton(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 100,
              ),
              Container(
                padding: EdgeInsets.only(right: 20, bottom: 4, top: 4),
                decoration: BoxDecoration(
                    color: provider.lightblue2,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(13, 0, 0, 0),
                        offset: Offset(4, 4),
                        blurRadius: 7,
                        spreadRadius: 3.0,
                      )
                    ]),
                width: double.infinity,
                margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                child: TextField(
                  controller: search,
                  onChanged: (text) {
                    setState(() {
                      search.text = text;
                      setState(() {});
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'البحث عن متنج',
                    labelStyle: TextStyle(height: 1.2),
                    icon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.name,
                  style: const TextStyle(fontSize: 15, height: 2),
                ),
              ),
              SizedBox(
                height: Get.height / 40,
              ),
              Expanded(
                  child:
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

                      goods2(
                mykey: '190',
                userref: FirebaseFirestore.instance
                    .collection('products')
                    .where('seller_number', isEqualTo: "772905140")
                    .orderBy('number', descending: true)
                    .withConverter<Welcome>(
                        fromFirestore: (snapshot, _) =>
                            (Welcome.fromJson(snapshot.data()!)),
                        toFirestore: (user, _) => user.toJson()),
                issearch: true,
                searchtext: search.text,
                confirm: false,
              )),
            ],
          ),
        ),
      ),
    );
  }

  var search = TextEditingController();
}

//!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.

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
  setthestate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return FirestoreQueryBuilder(
        pageSize: 3000,
        query: widget.userref,
        builder: (context1, snapshot, _) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 200),
                child: SlideAnimation(
                  verticalOffset: 8,
                  child: FadeInAnimation(
                    child: snapshot.isFetching
                        ? shammer()
                        : Container(
                            height: widget.issearch
                                ? widget.confirm
                                    ? (Get.height / 6)
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
                                ? EdgeInsets.only(right: 8, left: 8, top: 8)
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
                            child: widget.confirm
                                ? null
                                : InkWell(
                                    onTap: () {
                                      showdialog(
                                          provider,
                                          snapshot.docs[index]['size'],
                                          snapshot.docs[index]['quantity'],
                                          setthestate(),
                                          snapshot.docs[index]['docid'],
                                          snapshot.docs[index]['pictures']);
                                      // Navigator.push(
                                      //   context,
                                      //   PageTransition(
                                      //     child: ItemDetails(
                                      //       mykey: '10',
                                      //       brand: snapshot.docs[index]
                                      //           ['brand'],
                                      //       discription: snapshot.docs[index]
                                      //           ['discription'],
                                      //       sillername: snapshot.docs[index]
                                      //           ['siller'],
                                      //       name: snapshot.docs[index]['name'],
                                      //       price: snapshot.docs[index]
                                      //           ['price'],
                                      //       size: snapshot.docs[index]['size'],
                                      //       type: snapshot.docs[index]['type'],
                                      //       quantity: snapshot.docs[index]
                                      //           ['quantity'],
                                      //       people: snapshot.docs[index]
                                      //           ['people'],
                                      //       pictures: snapshot.docs[index]
                                      //           ['pictures'],
                                      //       docid: snapshot.docs[index]
                                      //           ['docid'],
                                      //     ),
                                      //     type: PageTransitionType.fade,
                                      //     duration:
                                      //         const Duration(milliseconds: 280),
                                      //     reverseDuration:
                                      //         const Duration(milliseconds: 280),
                                      //   ),
                                      // );
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
                        "الكمية : " + quantity.toString(),
                        style: TextStyle(
                            fontSize: Get.height / 50,
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

  showdialog(provider, size, quantity1, setthestate, docid, pictures) {
    int myindex = 0;

    var _size = TextEditingController();
    _size.text = size;
    int quantity = 0;
    quantity = quantity1;
    return showDialog(
      useSafeArea: false,
      barrierColor: Colors.black54,
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.only(
                      top: Get.height / 7,
                      bottom: Get.width / 7,
                      right: Get.width / 30,
                      left: Get.width / 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: provider.colortheme,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            Align(
                                child: Container(
                              height: Get.height / 3.5,
                              width: Get.width / 6.5,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: pictures.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        myindex = index;
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
                                              color:
                                                  Color.fromARGB(64, 0, 0, 0),
                                              offset: Offset(5, 3),
                                              blurRadius: 3,
                                              spreadRadius: 1.0,
                                            )
                                          ]),
                                      margin: EdgeInsets.only(
                                          top: 12, right: Get.width / 60),
                                      height: Get.width / 8,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              'pictures/third2.png'),
                                          fit: BoxFit.cover,
                                          image: NetworkImage(pictures[index]),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                            Expanded(child: Container()),
                            Stack(
                              children: [
                                FittedBox(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: Get.height / 44),
                                    height: Get.height / 3.4,
                                    width: Get.width / 1.5,
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(31, 255, 255, 255),
                                        offset: Offset(10, 10),
                                        blurRadius: 15,
                                        spreadRadius: 3.0,
                                      )
                                    ]),
                                    child: InkWell(
                                      onTap: () {},
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(17)),
                                        child: FadeInImage(
                                          placeholder: provider.placeolderimage,
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(pictures[myindex]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 14, right: 3),
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    onPressed: pictures.length == 1
                                        ? null
                                        : () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.info,
                                              borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 2,
                                              ),
                                              width: Get.width,
                                              buttonsBorderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(2),
                                              ),
                                              dismissOnTouchOutside: true,
                                              dismissOnBackKeyPress: false,
                                              onDismissCallback: (type) {},
                                              headerAnimationLoop: false,
                                              animType: AnimType.bottomSlide,
                                              desc: "حذف هذه الصورة؟",
                                              showCloseIcon: true,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                Reference photoRef =
                                                    await FirebaseStorage
                                                        .instance
                                                        .refFromURL(
                                                            pictures[myindex]);
                                                await photoRef.delete();
                                                myindex--;
                                                pictures
                                                    .remove(pictures[myindex]);
                                                FirebaseFirestore.instance
                                                    .collection('products')
                                                    .doc("$docid")
                                                    .update(
                                                        {"pictures": pictures});
                                                setState(() {});
                                              },
                                            ).show();
                                          },
                                    icon: Icon(
                                      EvaIcons.trash2,
                                      size: Get.height / 25,
                                    ),
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                        SizedBox(
                          height: Get.height / 40,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: Get.width / 18,
                            ),
                            Text(
                              'الكمية :',
                              style: TextStyle(
                                fontSize: Get.height / 40,
                                shadows: provider.containershadow,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(right: Get.width / 55),
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity =
                                              quantity > 1 ? --quantity : 1;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 23,
                                      ),
                                    ),
                                    Text(
                                      "$quantity",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Tajawal",
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          size: 23,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(right: 20, bottom: 0),
                          child: Text(
                            "",
                            style:
                                TextStyle(fontSize: 16, color: provider.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              right: Get.width / 20, bottom: Get.height / 50),
                          child: Text(
                            'المقاسات :',
                            style: TextStyle(
                              fontSize: Get.height / 40,
                              shadows: provider.containershadow,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(right: 20, bottom: 7, top: 7),
                          decoration: BoxDecoration(
                              color: provider.lightblue2,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(13, 0, 0, 0),
                                  offset: Offset(4, 4),
                                  blurRadius: 7,
                                  spreadRadius: 3.0,
                                )
                              ]),
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              top: 0, left: 20, right: 20),
                          child: TextField(
                            controller: _size,
                            decoration: const InputDecoration(
                              hintText: '20 - 30 أو XL - XXL - S',
                              border: InputBorder.none,
                              labelStyle: TextStyle(height: 1.2),
                            ),
                            keyboardType: TextInputType.name,
                            style: const TextStyle(fontSize: 15, height: 2),
                          ),
                        ),
                        SizedBox(
                          height: Get.height / 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                update(docid, quantity, _size.text);
                                setthestate;
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange)),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                child: Text(
                                  "تعديل",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.height / 48),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                delete(docid);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                child: Text(
                                  "حذف",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.height / 48),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: Get.height / 20)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  update(docid, quantity, size) {
    FirebaseFirestore.instance
        .collection("products")
        .doc(docid)
        .update({'quantity': quantity, 'size': size});
  }

  delete(docid) {
    FirebaseFirestore.instance.collection("products").doc(docid).delete();
  }
}
