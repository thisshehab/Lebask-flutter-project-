import 'package:country_picker/country_picker.dart';
import 'package:lebask/main.dart';
import 'package:lebask/others/provider1.dart';
import 'package:lebask/registration/verfication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../others/animated_navgation.dart';

import 'signup.dart';

class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var flagemo = "الدولة";
  var flagcode;
  var _name;
  var _phonenumber;
  bool ActiveConnection = true;
  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      ActiveConnection = status == InternetConnectionStatus.connected;
    });
  }

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
              Image.asset(
                'pictures/third.png',
                color: provider.blue.withOpacity(0.1),
                height: Get.height / 1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: formstate,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 12, bottom: Get.height / 10),
                            child: Text(
                              'تسجيل الدخول ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Get.height / 36,
                                  fontWeight: FontWeight.bold),
                            ),
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
                         const SizedBox(height: 40),
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(right: 20, left: 20),
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
                                backgroundColor:
                                    MaterialStateProperty.all(provider.orange),
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
                                "تسجيل الدخول",
                                style: TextStyle(
                                    fontSize: 19, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return signup();
                                })));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "لا تمتلك حساب؟ ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "أنشئ واحدًا",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 33, 61, 243),
                                        fontSize: 16),
                                  ),
                                ],
                              )),
                        ],
                      ))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void signup1() async {
// await FirebaseAuth.instance.verifyPhoneNumber(
//   phoneNumber: '+967770849252',
//   verificationCompleted: (PhoneAuthCredential credential) {},
//   verificationFailed: (FirebaseAuthException e) {},
//   codeSent: (String verificationId, int? resendToken) {},
//   codeAutoRetrievalTimeout: (String verificationId) {},
// );

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

  
  getuserinformation(){

  }
}
