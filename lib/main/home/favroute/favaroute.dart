import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/search/goods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../others/provider1.dart';
import '../../other/item_details.dart';
import '../../other/likedbutton.dart';
import '../converter.dart';

class favorite extends StatefulWidget {
  const favorite({Key? key}) : super(key: key);

  @override
  State<favorite> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<favorite> {
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Colors.white),
              backgroundColor: provider.darckblue,
              title: Text(
                'المفضلة',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: Get.width / 22,
                    wordSpacing: 5,
                    color: Colors.white,
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
            body: goods2(
                mykey: '009',
                userref: FirebaseFirestore.instance
                    .collection('products')
                    .withConverter<Welcome>(
                        fromFirestore: (snapshot, _) =>
                            (Welcome.fromJson(snapshot.data()!)),
                        toFirestore: (user, _) => user.toJson()),
                confirm: true)));
  }
}
