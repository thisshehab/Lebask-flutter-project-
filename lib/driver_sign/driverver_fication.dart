import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lebask/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:lebask/main/home/Category.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main/other/navbar.dart';
import '../others/animated_navgation.dart';
import '../others/provider1.dart';

class verfication extends StatefulWidget {
  final flagcode;
  final name;
  final phonenumber;
  String? address;
  File? picture;
  String? imagename;
  verfication({
    required this.flagcode,
    this.name,
    required this.phonenumber,
  });

  @override
  State<verfication> createState() => _verficationState();
}

class _verficationState extends State<verfication> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verfication();
  }

  void verfication() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+${widget.flagcode}${widget.phonenumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            addtheuser();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                pageroute(
                    widget: nav2(
                  username: widget.name,
                  phonenumber: widget.phonenumber,
                )));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verficationcode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _onEditing = true;
  String _code = '';
  var _verficationcode;
  bool correctverfication = true;
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'التحقق',
            style: TextStyle(color: Colors.white),
          ),
          leading: const BackButton(color: Colors.white),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Text(
              'سيتم ارسال رسالة نصية لـ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '+${widget.flagcode}${widget.phonenumber}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'أدخل رمز التحقق',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: VerificationCode(
                keyboardType: TextInputType.number,
                underlineColor: Colors
                    .amber, // If this is null it will use primaryColor: Colors.red from Theme
                length: 6,
                cursorColor: const Color.fromARGB(255, 11, 70,
                    117), // If this is null it will default to the ambient
                // clearAll is NOT required, you can delete it
                // takes any widget, so you can implement your design

                onCompleted: (String value) async {
                  setState(() {
                    _code = value;
                  });
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            smsCode: _code, verificationId: _verficationcode))
                        .then((value) {
                      if (value.user != null) {
                        setState(() {
                          correctverfication = true;
                        });
                        addtheuser();
                        Navigator.pushReplacement(
                            context,
                            pageroute(
                                widget: nav2(
                              username: widget.name,
                              phonenumber: widget.phonenumber,
                            )));
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      correctverfication = false;
                    });
                  }
                },
                onEditing: (bool value) {
                  setState(() {
                    _onEditing = value;
                  });
                  if (!_onEditing) FocusScope.of(context).unfocus();
                },
              ),
            ),
            Container(
                child: _onEditing
                    ? Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: const Text('أدخل الكود كاملًا'))
                    : correctverfication
                        ? Container(
                            margin: EdgeInsets.only(top: Get.height / 6),
                            child: SpinKitFadingCube(
                              color: provider.orange,
                              size: 50.0,
                              duration: const Duration(milliseconds: 1500),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: Get.height / 6),
                            child: const Text("تأكد من صحة رمز التحقق"),
                          ))
          ],
        ),
      ),
    );
  }

  String userid = "";
  addtheuser() async {
    final prefs = await SharedPreferences.getInstance();

    CollectionReference userref =
        FirebaseFirestore.instance.collection("drivers");
    userref.add({
      'name': widget.name,
      'phone': widget.phonenumber,
    }).then((value) {
      FirebaseFirestore.instance.doc(value.path).update({"docid": value.id});
      //save the information local
      prefs.setString("driverid", value.id);
      prefs.setString("drivername", widget.name);
      prefs.setString("driverphone", widget.phonenumber);
      //save the information in cloud
    });
  }
}
