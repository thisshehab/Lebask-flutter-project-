import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lebask/main.dart';
import 'package:lebask/main/home/locations/editlocations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../others/provider1.dart';
import 'locations/addlocation2.dart';


class mylocations extends StatefulWidget {
  const mylocations({Key? key}) : super(key: key);

  @override
  State<mylocations> createState() => _mylocationsState();
}

class _mylocationsState extends State<mylocations> {
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: provider.darckblue,
              title: const Text(
                'مواقعي',
                style: TextStyle(color: Colors.white),
              ),
              leading: BackButton(color: Colors.white),
            ),
            body: Stack(
              children: [
                Container(height: double.infinity),
                Container(
                  margin: EdgeInsets.only(
                    right: Get.width / 20,
                    top: Get.height / 66,
                    left: Get.width / 20,
                  ),
                  child: provider.locaiton.isEmpty
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: Get.height / 20,
                              ),
                              Text(
                                "  لم يتم إضافة مواقع !",
                                style: TextStyle(fontSize: Get.height / 50),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مواقع نستخدمها لنتمكن من الوصول إليك',
                              style: TextStyle(fontSize: Get.width / 30),
                            ),
                            const Divider(
                              thickness: 1.2,
                              height: 22,
                            ),
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.locaiton.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 250),
                                  child: SlideAnimation(
                                    verticalOffset: 8,
                                    child: FadeInAnimation(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 26),
                                        decoration: BoxDecoration(
                                            boxShadow: provider.containershadow,
                                            color: provider.colortheme,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10, top: 7),
                                                child: Text(
                                                  provider.locaitonname[index],
                                                  style: TextStyle(
                                                      fontSize: Get.width / 22),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      ((context) {
                                                            return editlocaitno(
                                                              latitude: provider
                                                                  .locaiton[
                                                                      index]
                                                                  .split(
                                                                      '-')[0],
                                                              longtude: provider
                                                                  .locaiton[
                                                                      index]
                                                                  .split(
                                                                      '-')[1],
                                                              locaitondocid:
                                                                  provider.loctiondocid[
                                                                      index],
                                                              locationname:
                                                                  provider.locaitonname[
                                                                      index],
                                                            );
                                                          })));
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .locationDot,
                                                          size: 22,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType.info,
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 2,
                                                            ),
                                                            width: Get.width,
                                                            buttonsBorderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  2),
                                                            ),
                                                            dismissOnTouchOutside:
                                                                true,
                                                            dismissOnBackKeyPress:
                                                                false,
                                                            onDismissCallback:
                                                                (type) {
                                                              // ScaffoldMessenger.of(context).showSnackBar(
                                                              //   SnackBar(
                                                              //     content: Text('Dismissed by $type'),
                                                              //   ),
                                                              // );
                                                            },
                                                            headerAnimationLoop:
                                                                false,
                                                            animType: AnimType
                                                                .bottomSlide,
                                                            desc:
                                                                'إزالة الموقع ؟',
                                                            showCloseIcon: true,
                                                            btnCancelOnPress:
                                                                () {},
                                                            btnOkOnPress: () {
                                                              provider.deletelocaion(
                                                                  provider.locaiton[
                                                                      index],
                                                                  provider.locaitonname[
                                                                      index],
                                                                  provider.loctiondocid[
                                                                      index]);
                                                            },
                                                          ).show();
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .trash,
                                                          size: 22,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                ),
                Container(
                    width: Get.width,
                    margin: EdgeInsets.only(left: 8, bottom: Get.height / 50),
                    alignment: Alignment.bottomCenter,
                    height: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(provider.orange)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return const addlocation2();
                        })));
                      },
                      child: Container(
                        width: Get.width / 3.5,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.add_location_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              'إضافة موقع',
                              style: TextStyle(
                                  fontSize: Get.height / 55,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            )));
  }
}
