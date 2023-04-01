import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lebask/sillers/silleritems.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../others/provider1.dart';
import '../main/home/converter.dart';

class sillerslist extends StatefulWidget {
  const sillerslist({Key? key}) : super(key: key);

  @override
  State<sillerslist> createState() => sillerslistState();
}

class sillerslistState extends State<sillerslist> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, top: 24),
              child: const Text(
                'قائمة المتاجر',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Divider(height: 15, thickness: 1.2),
            Container(width: Get.width, child: sillers())
          ],
        ));
  }

  sillers() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    Query<Welcome> userref = FirebaseFirestore.instance
        .collection('sillers')
        .withConverter<Welcome>(
            fromFirestore: (snapshot, _) =>
                (Welcome.fromJson(snapshot.data()!)),
            toFirestore: (user, _) => user.toJson());

    return FirestoreQueryBuilder(
        pageSize: 700,
        query: userref,
        builder: (context1, snapshot, _) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // physics: const BouncingScrollPhysics(),
            itemCount: snapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 280),
                child: SlideAnimation(
                  verticalOffset: 7,
                  child: FadeInAnimation(
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.only(
                          top: Get.height / 80, right: 15, left: 15),
                      alignment: Alignment.topCenter,
                      height: Get.height / 4.4,
                      decoration:
                          BoxDecoration(boxShadow: provider.containershadow),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(13, 0, 0, 0),
                                offset: Offset(4, 4),
                                blurRadius: 7,
                                spreadRadius: 3.0,
                              )
                            ]),
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
                                      sillerphone: snapshot.docs[index]
                                          ['phone'],
                                    ),
                                    alignment: Alignment.topCenter,
                                    type: PageTransitionType.leftToRight,
                                    duration: const Duration(milliseconds: 280),
                                  ));
                            },
                            child: Container(
                              child: Stack(children: [
                                Center(
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage('pictures/third2.png'),
                                    fit: BoxFit.fitWidth,
                                    height: Get.height / 3.4,
                                    image: NetworkImage(
                                        snapshot.docs[index]['logo']),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        right: Get.width / 20,
                                        bottom: Get.height / 60),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      snapshot.docs[index]['name'],
                                      style: TextStyle(
                                          fontSize: Get.height / 35,
                                          color: Colors.white),
                                    ))
                              ]),
                            )
                            //  Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //     children: [
                            //       ClipRRect(
                            //         borderRadius: BorderRadius.circular(10),
                            //         child: FadeInImage(
                            //           placeholder: const AssetImage(
                            //               'pictures/placeholder.gif'),
                            //           fit: BoxFit.fitWidth,
                            //           height: Get.height / 10,
                            //           image: NetworkImage(
                            //               snapshot.docs[index]['logo']),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsets.only(left: Get.width / 6),
                            //         child: Text(
                            //           snapshot.docs[index]['name'],
                            //           style: TextStyle(
                            //               fontFamily: 'Abd-ElRady-Regular-1',
                            //               fontSize: Get.width / 16,
                            //               color:
                            //                   const Color.fromARGB(195, 0, 0, 0),
                            //               // ignore: prefer_const_literals_to_create_immutables
                            //               shadows: [
                            //                 const BoxShadow(
                            //                   color: Color.fromARGB(77, 0, 0, 0),
                            //                   offset: Offset(4, 4),
                            //                   blurRadius: 10,
                            //                   spreadRadius: 3.0,
                            //                 )
                            //               ]),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 0),
                            //         child: FaIcon(
                            //           FontAwesomeIcons.arrowLeft,
                            //           size: Get.width / 20,
                            //         ),
                            //       )
                            //     ])

                            ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
