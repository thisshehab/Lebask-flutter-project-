import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lebask/admin/getthediffrence.dart';
import 'package:lebask/admin/orders.dart';
import 'package:lebask/admin/showlocations.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../others/provider1.dart';

class orderdetails extends StatefulWidget {
  final customername;
  final code;
  final customerphone;
  final customerdocid;
  final candriveorder;

  const orderdetails(
      {super.key,
      this.customername,
      this.customerphone,
      required this.customerdocid,
      required this.candriveorder,
      required this.code});
  @override
  State<orderdetails> createState() => _orderdetailsState();
}

class _orderdetailsState extends State<orderdetails> {
  List docid = [];
  List sillername = [];
  List sillernumber = [];

  List item = [];
  List itemid = [];
  List picture = [];
  List price = [];
  List quantity = [];
  List size = [];
  int total = 0;
  String location = "";
  getdata() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.customerdocid)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .where("confirmed", isEqualTo: true)
        .get()
        .then((value) async {
      for (var element1 in value.docs) {
        total = element1.data()['total'];
        latitude = element1.data()['location'].split('-')[0];
        longtude = element1.data()['location'].split('-')[1];
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.customerdocid)
            .collection('orders')
            .doc(element1.data()['docid'])
            .collection("products")
            .get()
            .then((value) {
          for (var element in value.docs) {
            // location = element1.data()['location'];
            item.add(element.data()['item']);
            itemid.add(element.data()['itemid']);
            picture.add(element.data()['picture']);
            price.add(element.data()['price']);
            quantity.add(element.data()['quantity']);
            size.add(element.data()['size']);

            // customerproducts.add({
            //   '${customersdocid[i]}': {
            //     // "customername": element0.data()['name'],
            //     // "customerphone": element0.data()['phone'],
            //     // "customerphone": element0.data()['phone'],
            //     'customerid': "${customersdocid[i]}",
            //     // 'location': element1.data()['location'],
            //     'docid': element.data()['docid'],
            //     'itemname': element.data()['item'],
            //     'itemid': element.data()['itemid'],
            //     'picture': element.data()['picture'],
            //     'price': element.data()['price'].toString(),
            //     "quantity": element.data()['quantity'].toString(),
            //     "size": element.data()['size'],
            //   }
            // });
          }
        });
      }
    });
    await getthesiller();
    setState(() {});
  }

  getthesiller() async {
    for (int i = 0; i < itemid.length; i++) {
      await FirebaseFirestore.instance
          .collection("products")
          .where("docid", isEqualTo: await itemid[i])
          .get()
          .then((value) {
        sillername.add(value.docs[0].data()['siller']);
        sillernumber.add(value.docs[0].data()['seller_number']);
      });
    }
    for (int i = 0; i < itemid.length; i++) {
      await FirebaseFirestore.instance
          .collection("sillers")
          .where("phone", isEqualTo: await sillernumber[i])
          .get()
          .then((value) {
        for (var element in value.docs) {
          if (!storephone.contains(element.data()['phone'])) {
            storephone.add(element.data()['phone']);
            storename.add(element.data()['name']);
            storelocation.add(element.data()['location']);
          }
        }
      });
    }
  }

  String latitude = "";
  String longtude = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getthestateoforder();
    getdata();
  }

  _launchCaller() async {
    Uri url = Uri.parse("tel:${widget.customerphone}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getthestateoforder() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.customerdocid)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .where("confirmed", isEqualTo: true)
        .get()
        .then((value) {
      onway = value.docs[0].data()['currentstep'] == 2;
    });
  }

  List storelocation = [];
  List storename = [];
  List storephone = [];
  var code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.customername),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Get.height / 50, bottom: Get.height / 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchCaller();
                    },
                    label: Text(
                      "اتصال",
                      style: TextStyle(fontSize: Get.height / 44),
                    ),
                    icon: Icon(
                      Icons.phone,
                      size: Get.height / 30,
                    ),
                  ),
                  ElevatedButton.icon(
                      icon: Icon(
                        FontAwesomeIcons.mapLocationDot,
                        size: Get.height / 33,
                      ),
                      onPressed: () {
                        //get the sotres locations without repeat
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return showdirections(
                            latitude: latitude,
                            longtude: longtude,
                            customername: widget.customername,
                            storeslocations: storelocation,
                            storesnames: storename,
                          );
                        })));
                      },
                      label: Text(
                        "عرض",
                        style: TextStyle(fontSize: Get.height / 44),
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "عدد المنتجات: ${itemid.length}",
                  style: TextStyle(fontSize: Get.height / 50),
                ),
                Text(
                  "الإجمالي : $total",
                  style: TextStyle(fontSize: Get.height / 50),
                )
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: Get.height / 120,
            ),
            item.isEmpty
                ? SizedBox(
                    height: Get.height / 2,
                    child: Center(
                      child: SpinKitCubeGrid(
                        color: provider.orange,
                        size: Get.height / 15,
                        duration: const Duration(milliseconds: 1000),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: itemid.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 10,
                            child: FadeInAnimation(
                              child: Container(
                                height: Get.height / 4.5,
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                  right: Get.width / 30,
                                  left: Get.width / 30,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     child: ItemDetails(
                                    //       mykey: widget.mykey,
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
                                      picture: picture[index],
                                      price: price[index],
                                      size: size[index],
                                      quantity: quantity[index],
                                      sillername: sillername[index],
                                      sillerphone: sillernumber[index],
                                      name: item[index]),
                                ),
                              ),
                              //child: Column(
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
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              height: Get.height / 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              onway ? Colors.red : provider.orange)),
                      onPressed: onway
                          ? () {
                              cencelorder();
                            }
                          : () {
                              if (widget.candriveorder) {
                                changethestateoforder();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.rightSlide,
                                  headerAnimationLoop: false,
                                  desc: "لديك طلب لم تقم بإكماله",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.orange,
                                ).show();
                              }
                            },
                      child: Text(
                        onway ? "إلغاء العملية" : "توصيل الطلب",
                        style: TextStyle(
                          fontSize: Get.height / 55,
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          useSafeArea: false,
                          barrierColor: Colors.black54,
                          useRootNavigator: false,
                          builder: (context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: provider.colortheme,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: Get.height / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Get.height / 30,
                                        ),
                                        Center(
                                          child: Text(
                                            "تأكيد التوصيل",
                                            style: TextStyle(
                                                fontSize: Get.height / 45),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Divider(thickness: 1),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: Get.width / 1.5,
                                              margin: EdgeInsets.only(right: 9),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: code,
                                                decoration:
                                                    const InputDecoration(
                                                        label: Text(
                                                            "كود التوصيل")),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    if (code.text ==
                                                        widget.code) {
                                                      finishedorder();
                                                    } else {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.error,
                                                        animType:
                                                            AnimType.rightSlide,
                                                        headerAnimationLoop:
                                                            false,
                                                        desc: '!كود خاطئ',
                                                        btnOkOnPress: () {},
                                                        btnOkIcon: Icons.cancel,
                                                        btnOkColor:
                                                            Color.fromARGB(255,
                                                                212, 31, 31),
                                                      ).show();
                                                    }
                                                  },
                                                  child: Text("تأكيد")),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                      // AwesomeDialog(
                      //   context: context,
                      //   dialogType: DialogType.info,
                      //   borderSide: const BorderSide(
                      //     color: Colors.green,
                      //     width: 2,
                      //   ),
                      //   width: Get.width,
                      //   buttonsBorderRadius: const BorderRadius.all(
                      //     Radius.circular(2),
                      //   ),
                      //   dismissOnTouchOutside: true,
                      //   dismissOnBackKeyPress: false,
                      //   onDismissCallback: (type) {
                      //     // ScaffoldMessenger.of(context).showSnackBar(
                      //     //   SnackBar(
                      //     //     content: Text('Dismissed by $type'),
                      //     //   ),
                      //     // );
                      //   },
                      //   headerAnimationLoop: false,
                      //   animType: AnimType.bottomSlide,
                      //   title: 'تم إيصال الطلب ؟',
                      //   showCloseIcon: true,
                      //   btnCancelOnPress: () {},
                      //   btnOkOnPress: () {
                      //   },
                      // ).show();
                    },
                    child: Text(
                      "تم الإيصال",
                      style: TextStyle(fontSize: Get.height / 55),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container the_items({
    name,
    price,
    size,
    quantity,
    picture,
    sillername,
    sillerphone,
  }) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
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
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: FittedBox(
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: Get.height / 55,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "الكمية: $quantity",
                          style: TextStyle(fontSize: Get.height / 55,
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
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "المقاس :$size",
                          style: TextStyle(fontSize: Get.height / 55,
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
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          Text(
                            "السعر: $price ريال",
                            style: TextStyle(
                                fontSize: Get.height / 66,
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
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "البائع: " + sillername,
                        style: TextStyle(
                            fontSize: Get.height / 66,
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
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "رقم البائع : $sillerphone",
                        style: TextStyle(
                            fontSize: Get.height / 66,
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
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 5, top: 10),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "الإجمالي: ${quantity * price} ريال",
                        style: TextStyle(
                            fontSize: Get.height / 55,
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
          InkWell(
            onTap: () {
              showImageViewer(
                context,
                NetworkImage(picture),
                useSafeArea: true,
                immersive: false,
              );
            },
            child: SizedBox(
              height: Get.height,
              width: Get.width / 2.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FadeInImage(
                  placeholder: const AssetImage('pictures/third2.png'),
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(picture),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _arrivedtime;
  bool onway = false;
  cencelorder() {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 201, 27, 27),
          width: 2,
        ),
        width: Get.width,
        buttonsBorderRadius: const BorderRadius.all(
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
        desc: 'إلغاء العملية؟',
        showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          final prefs = await SharedPreferences.getInstance();
          var driverdoc = nav2.userdoc ?? prefs.getString('driverid');
          await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.customerdocid)
              .collection('orders')
              .where("completed", isEqualTo: false)
              .where("confirmed", isEqualTo: true)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(widget.customerdocid)
                .collection('orders')
                .doc(value.docs[0].data()['docid'])
                .update({'currentstep': 1});
          });
          FirebaseFirestore.instance
              .collection("drivers")
              .doc(driverdoc)
              .collection("orders")
              .where("finished", isEqualTo: false)
              .get()
              .then((value) {
            FirebaseFirestore.instance
                .collection("drivers")
                .doc(driverdoc)
                .collection("orders")
                .doc(value.docs[0].data()["docid"])
                .set({"value?": "canceled"});
          });
          onway = false;
          ordersState.selectedorderid = null;
          setState(() {});
        }).show();
  }

  changethestateoforder() async {
    showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            confirmText: "تأكيد",
            cancelText: "إلغاء")
        .then((time) async {
      if (time != null) {
        _arrivedtime = time;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.customerdocid)
            .collection('orders')
            .where("completed", isEqualTo: false)
            .where("confirmed", isEqualTo: true)
            .get()
            .then((value) async {
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.customerdocid)
              .collection('orders')
              .doc(value.docs[0].data()['docid'])
              .update(
                  {'currentstep': 2, 'time': "${time.hour}:${time.minute}"});
          final prefs = await SharedPreferences.getInstance();

          var driverdoc = nav2.userdoc ?? prefs.getString('driverid');
          FirebaseFirestore.instance
              .collection("drivers")
              .doc(driverdoc)
              .collection("orders")
              .add({
            "date": DateTime.now().toString(),
            "orderid": widget.customerdocid,
            "finished": false,
          }).then((value) {
            FirebaseFirestore.instance
                .collection("drivers")
                .doc(driverdoc)
                .collection("orders")
                .doc(value.id)
                .update({"docid": value.id});
            ordersState.selectedorderid = "";
          });
          onway = true;
          setState(() {});
        });
        // print(time().hour(
        //     theend: "${value.hour}:${value.minute}",
        //     thestart: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}"));
        // print(value.hour);
        // print(value.format(context).toString());
        // print(TimeOfDay.now().format(context).toString());
      }
    });
  }

  finishedorder() async {
    final prefs = await SharedPreferences.getInstance();

    var driverdoc = nav2.userdoc ?? prefs.getString('driverid');
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(driverdoc)
        .collection("orders")
        .where("finished", isEqualTo: false)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverdoc)
          .collection("orders")
          .doc(value.docs[0].data()["docid"])
          .update({
        "finished": true,
        "total": total.toString(),
        "date": DateTime.now().toString()
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.customerdocid)
        .update({"hasorder": false, "shouldrefresh": true});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.customerdocid)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .where("confirmed", isEqualTo: true)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.customerdocid)
          .collection('orders')
          .doc(value.docs[0].data()['docid'])
          .update({'completed': true, 'currentstep': 4});
    });
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      desc: 'تمت  العملية بنجاح',
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        Navigator.of(context).pop();
      },
    ).show();
  }
}
