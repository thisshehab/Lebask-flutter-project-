import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lebask/others/animated_navgation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../others/provider1.dart';
import 'driverver_fication.dart';

// ignore: camel_case_types, must_be_immutable
class driversignup extends StatefulWidget {
  var smsid;
  driversignup({Key? key}) : super(key: key);

  @override
  State<driversignup> createState() => _signupState();
}

class _signupState extends State<driversignup> {
  bool ActiveConnection = true;

  @override
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
  var _phonenumber;

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        provider.darckblue,
        const Color.fromARGB(255, 14, 67, 126)
      ])),
      child: SafeArea(
        child: Scaffold(
            body: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                width: Get.width / 1.5,
                height: Get.height / 4,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(220),
                    ),
                    gradient: LinearGradient(
                        colors: [provider.blue, provider.lightblue1],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft)),
              ),
              Container(
                margin: EdgeInsets.only(left: Get.width / 4),
                width: Get.width,
                child: Container(
                  alignment: Alignment.topLeft,
                  height: Get.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(170),
                        topLeft: Radius.circular(170),
                      ),
                      gradient: LinearGradient(
                          colors: [provider.orange, provider.yellow],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft)),
                ),
              ),
              Container(
                height: Get.height / 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // child: FadeInImage(
                    //   placeholder: AssetImage('asset/image_large.png'),
                    //   fadeInCurve: Curves.easeInOut,
                    //   image: NetworkImage(
                    //       "https://firebasestorage.googleapis.com/v0/b/fashion-88ba6.appspot.com/o/clip-man-logging-into-his-account-on-phone.png?alt=media&token=e7d51c32-e6dc-4221-800a-89054e539cd5"),
                    // ),

                    Form(
                        key: formstate,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 14, bottom: 14),
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "إنشاء حساب كابتن",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 12),
                              child: Text(
                                "الأسم الثلاثي",
                                style: TextStyle(
                                    fontSize: 16, color: provider.black),
                              ),
                            ),
                            Container(
                              padding:
                                 const EdgeInsets.only(right: 20, bottom: 7, top: 7),
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
                                    if (value.length < 10) {
                                      return "قم بإدخال أسمك الثلاثي";
                                    } else {
                                      return null;
                                    }
                                  } else {
                                    return "أدخل أسمك الثلاثي";
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(height: 1.2),
                                  icon: Icon(Icons.person),
                                ),
                                keyboardType: TextInputType.name,
                                style: const TextStyle(fontSize: 15, height: 2),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
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
                                        return null;
                                        // if (value != null) {
                                        //   if (value.length < 9 ||
                                        //       value.length > 9) {
                                        //     return "ادخل رقم صحيح";
                                        //   } else if (flagcode == null) {
                                        //     return "قم بإختيار دولة ";
                                        //   } else if (value.length == 9) {
                                        //     return null;
                                        //   }
                                        // }
                                        // return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        suffix: Text('                     '),
                                        icon: Icon(Icons.phone),
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
                                          // countryFilter: <String>[
                                          //   'YE',
                                          //   'SA',
                                          //   'KW',
                                          // ], //It takes a list of country code(iso2).
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
                              height: 40,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 0, left: 20, right: 20),
                              width: Get.width,
                              height: 63,
                              child: ElevatedButton(
                                onPressed: () async {
                                  ActiveConnection == false
                                      ? showToast('تأكد من إتصالك بالانترنت',
                                          context: context,
                                          animation: StyledToastAnimation
                                              .slideFromBottomFade,
                                          reverseAnimation: StyledToastAnimation
                                              .slideFromBottomFade,
                                          position: const StyledToastPosition(
                                              align: Alignment.topCenter,
                                              offset: 20.0),
                                          startOffset: const Offset(0.0, -3.0),
                                          reverseEndOffset:
                                              const Offset(0.0, -3.0),
                                          duration: const Duration(seconds: 3),
                                          //Animation duration   animDuration * 2 <= duration
                                          animDuration:
                                              const Duration(milliseconds: 280),
                                          curve: Curves.easeOutSine,
                                          reverseCurve: Curves.fastOutSlowIn)
                                      : signup();
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
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void signup() async {
    var formdata = formstate.currentState;
    formdata!.save();
    if (formdata.validate()) {
      Navigator.push(
          context,
          pageroute(
              widget: verfication(
            flagcode: flagcode,
            name: _name,
            phonenumber: _phonenumber,
          )));
    }
  }
}
