import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';
import '../../../../others/provider1.dart';
import '../../../other/item_details.dart';
import '../../converter.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => ProductsState();
}

class ProductsState extends State<Products> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatetotal();
    settotal();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  static int total = 0;

  settotal() {
    int total1 = 0;
    for (int i = 0; i < ItemDetails.userprice.length; i++) {
      total1 += int.parse(ItemDetails.userprice[i].toString()) *
          int.parse(ItemDetails.userquantity[i].toString());
    }
    total = total1;
    setState(() {});
  }

  updatetotal() async {
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
            .update({'total': total + MyApp.dilivreyprice});
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "عدد المنتجات: ${ItemDetails.usercartitem.length}",
                  style: TextStyle(
                      fontSize: Get.height / 55,
                      fontFamily: 'Roboto',
                      color: provider.black),
                ),
                Text(
                  "الإجمالي: ${total} ريال",
                  style: TextStyle(
                      fontSize: Get.height / 55,
                      fontFamily: 'Roboto',
                      color: provider.black),
                ),
              ],
            ),
            const Divider(
              thickness: 1.2,
            ),
            Expanded(
                child: ItemDetails.userprice.isNotEmpty
                    ? goods(provider)
                    : cartempty(context)),
            SizedBox(
              height: 55,
            )
          ],
        ),
        Container(
            margin: EdgeInsets.only(left: 8, bottom: Get.height / 50),
            alignment: Alignment.bottomCenter,
            height: double.infinity,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(provider.darckblue)),
                onPressed: () async {
                  // Color randomColor() => Color.fromRGBO(Random().nextInt(256),
                  //     Random().nextInt(256), Random().nextInt(256), 1);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        child: SpinKitRipple(
                          color: provider.orange,
                          size: Get.width / 3.2,
                          duration: const Duration(milliseconds: 1100),
                        ),
                      );
                    },
                  );

                  // SmartDialog.showLoading(
                  //     clickMaskDismiss: false,
                  //     animationTime: Duration(milliseconds: 300),
                  //     animationType: SmartAnimationType.centerFade_otherSlide,
                  //     msg: '...جارٍ التحديث',
                  //     maskColor: Colors.black.withOpacity(0.4));

                  // SmartDialog.showLoading(
                  //   animationType: SmartAnimationType.scale,
                  //   builder: (_) => CircularProgressIndicator(),
                  // );
                  await Future.delayed(Duration(milliseconds: 1100));
                  updatecart();
                  settotal();
                  updatetotal();

                  //  SmartDialog.dismiss();
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(5, 5),
                      blurRadius: 18,
                      spreadRadius: 1.0,
                    )
                  ]),
                  padding: EdgeInsets.all(Get.height / 120),
                  child: Text(
                    "تحديث السلة",
                    style: TextStyle(
                        fontSize: Get.height / 60, color: Colors.white),
                  ),
                ))),
      ],
    );
  }

  Center cartempty(context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_sharp,
              size: Get.height / 17,
            ),
            Row(
              children: [
                SizedBox(
                  width: 9,
                ),
                Text(
                  'السلة فارغة!،',
                  style: TextStyle(fontSize: Get.height / 49),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => nav2()));
                  },
                  child: Text(
                    ' املأها الآن',
                    style: TextStyle(
                        color: Color.fromARGB(255, 50, 77, 255),
                        fontSize: Get.height / 49),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget goods(provider) {
    Query<Welcome> userref = FirebaseFirestore.instance
        .collection('products')
        .orderBy('number', descending: true)
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());
    return FirestoreQueryBuilder(
        pageSize: 1000,
        query: userref,
        builder: (context1, snapshot, _) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              bool incart = ItemDetails.usercartitem
                  .contains(snapshot.docs[index]['docid']);
              // int quantity =   selectedquantity(snapshot.docs[index]['docid']);
              //  String picture =  selectedpicture();
              return !incart
                  ? Container()
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 250),
                      child: SlideAnimation(
                        verticalOffset: 8,
                        child: FadeInAnimation(
                          child: Column(
                            children: [
                              Container(
                                height: Get.height / 5,
                                child:
                                    //  !likebutton.userfa
                                    //         .contains(snapshot.docs[index]['docid'])
                                    //     ? null
                                    //     :
                                    InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: ItemDetails(
                                          mykey: '20',
                                          calledfromcart: true,
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
                                          people: snapshot.docs[index]
                                              ['people'],
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
                                  child: the_items(
                                    docid: snapshot.docs[index]['docid'],
                                    name: snapshot.docs[index]['name'],
                                    sillername: snapshot.docs[index]['siller'],
                                    price: snapshot.docs[index]['price'],
                                    size: ItemDetails.usersize[
                                        ItemDetails.usercartitem.indexOf(
                                            snapshot.docs[index]['docid'])],
                                    type: snapshot.docs[index]['type'],
                                    realquantity: snapshot.docs[index]
                                        ['quantity'],
                                    quantity: ItemDetails.userquantity[
                                        ItemDetails.usercartitem.indexOf(
                                            snapshot.docs[index]['docid'])],
                                    people: snapshot.docs[index]['people'],
                                    pictures: snapshot.docs[index]['pictures'],
                                    brand: snapshot.docs[index]['brand'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          );
        });
  }

  Container the_items({
    name,
    price,
    size,
    type,
    quantity,
    people,
    pictures,
    sillername,
    docid,
    brand,
    realquantity,
  }) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    //provider.addthetotalprice(int.parse(price));
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: provider.colortheme,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(13, 0, 0, 0),
              offset: Offset(6, 5),
              blurRadius: 7,
              spreadRadius: 3.0,
            )
          ]),
      margin: EdgeInsets.only(
        top: Get.height / 150,
        bottom: Get.height / 40,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            transitionOnUserGestures: true,
            tag: docid + '20',
            child: SizedBox(
              width: Get.width / 3,
              height: Get.height / 3.9,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage(
                    placeholder: const AssetImage('pictures/third2.png'),
                    fit: BoxFit.cover,
                    image: NetworkImage(ItemDetails
                        .userphoto[ItemDetails.usercartitem.indexOf(docid)]),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            width: Get.width / 2.48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: Get.height / 54),
                    ),
                    InkWell(
                      onTap: () {
                        removeitem(docid: docid);
                      },
                      child: Icon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.red,
                        size: Get.width / 18.5,
                      ),
                    )
                  ],
                ),
                Text(
                  "البائع:  $sillername",
                  style: TextStyle(
                      fontSize: Get.height / 64, color: provider.gray2),
                ),
                Text(
                  "المقاس: ${size == "0" ? "غير مُحدد" : size}",
                  style: TextStyle(
                      fontSize: Get.height / 64, color: provider.gray2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: Get.height / 28,
                          width: Get.height / 28,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [provider.orange, provider.yellow]),
                              borderRadius: BorderRadius.circular(70)),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                quantity = quantity > 1
                                    ? --ItemDetails.userquantity[
                                        ItemDetails.usercartitem.indexOf(docid)]
                                    : 1;
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              size: Get.height / 66,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          child: Text(
                            "$quantity",
                            style: TextStyle(
                                fontSize: Get.height / 50,
                                fontFamily: "Tajawal",
                                color: provider.black),
                          ),
                        ),
                        Container(
                          height: Get.height / 28,
                          width: Get.height / 28,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [provider.orange, provider.yellow]),
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (realquantity - 1 <
                                      ItemDetails.userquantity[ItemDetails
                                          .usercartitem
                                          .indexOf(docid)]) {
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
                                    ItemDetails.userquantity[ItemDetails
                                        .usercartitem
                                        .indexOf(docid)]++;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                size: Get.height / 66,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        "${int.parse(price) * quantity} ريال",
                        style: TextStyle(fontSize: Get.height / 53),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  removeitem({docid}) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 239, 92),
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
      desc: 'إزالة المنتج ؟',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
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
            .get()
            .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userdoc)
                .collection('orders')
                .doc(element.data()['docid'])
                .collection('products')
                .doc(ItemDetails
                    .usercartdoc[ItemDetails.usercartitem.indexOf(docid)])
                .delete();

            ItemDetails.useritemname
                .removeAt(ItemDetails.usercartitem.indexOf(docid));
            ItemDetails.usercartdoc
                .removeAt(ItemDetails.usercartitem.indexOf(docid));
            ItemDetails.userphoto
                .removeAt(ItemDetails.usercartitem.indexOf(docid));
            ItemDetails.usersize
                .removeAt(ItemDetails.usercartitem.indexOf(docid));
            ItemDetails.userquantity
                .removeAt(ItemDetails.usercartitem.indexOf(docid));
            ItemDetails.userprice
                .removeAt(ItemDetails.usercartitem.indexOf(docid));

            ItemDetails.usercartitem.remove(docid);
            settotal();
            updatetotal();
          }
        });
      },
    ).show();
  }

  updatecart() async {
    for (int i = 0; i < ItemDetails.usercartdoc.length; i++) {
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
              .doc(ItemDetails.usercartdoc[i])
              .update({
            'picture': ItemDetails.userphoto[i],
            'quantity': ItemDetails.userquantity[i],
            'size': ItemDetails.usersize[i]
          });
        }
      });
    }
    setState(() {});
  }
}
