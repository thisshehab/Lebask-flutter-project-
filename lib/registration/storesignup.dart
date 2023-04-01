import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lebask/others/animated_navgation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../main/home/locations/addlocation2.dart';
import '../others/provider1.dart';
import 'signin.dart';
import 'package:path/path.dart';

import 'verfication.dart';

// ignore: camel_case_types, must_be_immutable
class storesignup extends StatefulWidget {
  var smsid;
  storesignup({Key? key}) : super(key: key);

  @override
  State<storesignup> createState() => _signupState();
}

class _signupState extends State<storesignup> {
  bool ActiveConnection = true;

  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      ActiveConnection = status == InternetConnectionStatus.connected;
    });
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var flagemo = "الدولة";
  var flagcode;
  var _name;
  var _address;
  var _phonenumber;
  @override
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return SafeArea(
      child: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Image.asset(
                'pictures/third.png',
                color: provider.lightblue2.withOpacity(0.5),
                height: Get.height / 1,
              ),
              SizedBox(
                height: Get.height / 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 1,
                    ),
                    Form(
                        key: formstate,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 12),
                              child: Text(
                                "أسم المتجر",
                                style: TextStyle(
                                    fontSize: 16, color: provider.black),
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
                              child: TextFormField(
                                onSaved: (value) {
                                  _name = value;
                                },
                                validator: (value) {
                                  if (value != null) {
                                    if (value.length <= 0) {
                                      return "أدخل أسم المتجر!";
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(height: 1.2),
                                  icon: Icon(FontAwesomeIcons.shop),
                                ),
                                keyboardType: TextInputType.name,
                                style: const TextStyle(fontSize: 15, height: 2),
                              ),
                            ),
                            SizedBox(
                              height: Get.height / 40,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 12),
                              child: Text(
                                "عنوان المتجر",
                                style: TextStyle(
                                    fontSize: 16, color: provider.black),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: Get.width / 1.16,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 20, bottom: 7, top: 7),
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
                                    margin: const EdgeInsets.only(
                                        top: 0, left: 20, right: 20),
                                    child: TextFormField(
                                      onSaved: (value) {
                                        _address = value;
                                      },
                                      validator: (value) {
                                        if (value != null) {
                                          if (value.length < 10) {
                                            return "أدخل عنوان المتجر";
                                          } else {
                                            return null;
                                          }
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(height: 1.2),
                                        icon: Icon(Icons.location_on_sharp),
                                      ),
                                      keyboardType: TextInputType.name,
                                      style: const TextStyle(
                                          fontSize: 15, height: 2),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    AnimatedOpacity(
                                      duration: Duration(milliseconds: 280),
                                      opacity: provider.showred ? 1 : 0,
                                      child: Container(
                                        height: Get.height / 60,
                                        width: Get.height / 60,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Get.to(addlocation2(
                                            isstore: true,
                                          ));
                                        },
                                        icon: Icon(Icons.add)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: Get.height / 40,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 20, bottom: 12),
                              child: Text(
                                "رقم الجوال",
                                style: TextStyle(
                                    fontSize: 16, color: provider.black),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 20, bottom: 7, top: 7),
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
                              // margin: EdgeInsets.only(top: 150),
                              child: SizedBox(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextFormField(
                                      textDirection: TextDirection.ltr,
                                      onSaved: (value) {
                                        _phonenumber = value;
                                      },
                                      validator: (value) {
                                        if (value != null) {
                                          if (value.length < 9 ||
                                              value.length > 9) {
                                            return "ادخل رقم صحيح";
                                          } else if (flagcode == null) {
                                            return "قم بإختيار دولة ";
                                          } else if (value.length == 9) {
                                            return null;
                                          }
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        suffix: Text('                     '),
                                        icon: Icon(Icons.phone_enabled_rounded),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                          fontSize: 15, height: 2),
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 5),
                                        child: Text(
                                          flagcode != null
                                              ? "$flagemo+$flagcode"
                                              : flagemo,
                                          style: const TextStyle(
                                              fontSize: 15, height: 2),
                                        ),
                                      ),
                                      onTap: () {
                                        showCountryPicker(
                                          countryFilter: <String>[
                                            'YE',
                                            'SA',
                                            'KW',
                                          ], //It takes a list of country code(iso2).
                                          context: context,
                                          showPhoneCode:
                                              true, // optional. Shows phone code before the country name.
                                          onSelect: (Country country) {
                                            setState(() {
                                              flagemo = country.flagEmoji;
                                              flagcode = country.phoneCode;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            SizedBox(
                              child: theimage != null
                                  ? SizedBox(
                                      height: Get.height / 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(theimage!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              child: TextButton(
                                child: const Text(
                                  '  الهوية البصرية ',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                ),
                                onPressed: () {
                                  pickiamge();
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            Stack(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    ActiveConnection == false
                                        ? showToast('تأكد من إتصالك بالانترنت',
                                            context: context,
                                            animation: StyledToastAnimation
                                                .slideFromBottomFade,
                                            reverseAnimation:
                                                StyledToastAnimation
                                                    .slideFromBottomFade,
                                            position: const StyledToastPosition(
                                                align: Alignment.topCenter,
                                                offset: 20.0),
                                            startOffset:
                                                const Offset(0.0, -3.0),
                                            reverseEndOffset:
                                                const Offset(0.0, -3.0),
                                            duration:
                                                const Duration(seconds: 3),
                                            //Animation duration   animDuration * 2 <= duration
                                            animDuration: const Duration(
                                                milliseconds: 280),
                                            curve: Curves.easeOutSine,
                                            reverseCurve: Curves.fastOutSlowIn)
                                        : signup(context, provider);
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => const nav2()));
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                    backgroundColor: MaterialStateProperty.all(
                                        provider.orange),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.height *
                                                .05,
                                            MediaQuery.of(context).size.height *
                                                .010,
                                            MediaQuery.of(context).size.height *
                                                .05,
                                            MediaQuery.of(context).size.height *
                                                .010)),
                                  ),
                                  child: const Text(
                                    "إنشاء حساب",
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: const signin(),
                                        alignment: Alignment.topCenter,
                                        type: PageTransitionType.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 280),
                                      ));
                                },
                                child: const Text(
                                  "تسجيل دخول",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                )),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void signup(BuildContext context, provider) async {
    var formdata = formstate.currentState;
    formdata!.save();
    if (addlocation2State.selectedlatitude == "") {
      provider.showredmethod(showred2: true);
      return;
    }
    if (formdata.validate() && theimage != null) {
      Navigator.push(
          context,
          pageroute(
              widget: verfication(
            flagcode: flagcode,
            name: _name,
            address: _address,
            picture: theimage,
            imagename: imagename,
            phonenumber: _phonenumber,
          )));
    }
  }

  var imagepicker = ImagePicker();
  File? theimage;
  String? imagename;
  pickiamge() async {
    var imagepicked = await imagepicker.pickImage(
        source: ImageSource.gallery, imageQuality: 14);
    if (imagepicked != null) {
      theimage = File(imagepicked.path);
      imagename = basename(imagepicked.path);
      setState(() {});
    }
  }
}
