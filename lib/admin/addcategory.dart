import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lebask/others/animated_navgation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import '../others/provider1.dart';

// ignore: camel_case_types, must_be_immutable
class addcategory extends StatefulWidget {
  var smsid;
  addcategory({Key? key}) : super(key: key);

  @override
  State<addcategory> createState() => _signupState();
}

class _signupState extends State<addcategory> {
  bool ActiveConnection = true;
  var people = [" "];
  String? selectedpeople;
  void getdata() {
    people.clear();
    FirebaseFirestore.instance.collection("people").get().then((value) {
      for (var element in value.docs) {
        setState(() {
          people.add(element.data()['name']);
        });
      }
    });
  }

  void initState() {
    super.initState();
    getdata();
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var flagemo = "الدولة";
  var flagcode;
  var _name;
  var _address;
  var categoryname;
  @override
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinKitCubeGrid(
                            color: provider.orange,
                            size: 100.0,
                            duration: const Duration(milliseconds: 1000),
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          const Text(
                            "جارٍ الرفع...",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
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

                                // child: FadeInImage(
                                //   placeholder: AssetImage('asset/image_large.png'),
                                //   fadeInCurve: Curves.easeInOut,
                                //   image: NetworkImage(
                                //       "https://firebasestorage.googleapis.com/v0/b/fashion-88ba6.appspot.com/o/clip-man-logging-into-his-account-on-phone.png?alt=media&token=e7d51c32-e6dc-4221-800a-89054e539cd5"),
                                // ),
                                Form(
                                    key: formstate,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topRight,
                                          margin: EdgeInsets.only(
                                              right: 20, bottom: 12),
                                          child: Text(
                                            "أسم التصنيف",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: provider.black),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              right: 20, bottom: 7, top: 7),
                                          decoration: BoxDecoration(
                                              color: provider.lightblue2,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      13, 0, 0, 0),
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
                                            child: TextFormField(
                                              textDirection: TextDirection.rtl,
                                              onSaved: (value) {
                                                categoryname = value;
                                                setState(() {});
                                              },
                                              validator: (value) {
                                                if (value != null) {
                                                  if (value.isEmpty) {
                                                    return "أدخل التصنيف";
                                                  }
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                suffix: Text(
                                                    '                     '),
                                                icon: Icon(
                                                    Icons.addchart_rounded),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: const TextStyle(
                                                  fontSize: 15, height: 2),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height / 35,
                                              right: Get.width / 15),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'الفئة الموجهة للتصنيف :',
                                                style: TextStyle(fontSize: 19),
                                              ),
                                              SizedBox(
                                                width: Get.width / 30,
                                              ),
                                              DropdownButton<String>(
                                                  value: selectedpeople,
                                                  items: people
                                                      .map(buildmenuitem)
                                                      .toList(),
                                                  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                                                  onChanged: (Value) =>
                                                      setState(() {
                                                        selectedpeople = Value!;
                                                      })),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        SizedBox(
                                          height: Get.height / 5,
                                          child: theimage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  child: Image.file(
                                                    File(theimage!.path),
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: TextButton(
                                            child: const Text(
                                              'صورة للتصنيف',
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
                                                uploaddata();
                                              },
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        provider.orange),
                                                padding: MaterialStateProperty
                                                    .all(EdgeInsets.fromLTRB(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .05,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .010,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .05,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .010)),
                                              ),
                                              child: const Text(
                                                "رفع التصنيف",
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            )),
      ),
    );
  }

  var imagepicker = ImagePicker();
  File? theimage;
  String? imagename2;
  pickiamge() async {
    var imagepicked = await imagepicker.pickImage(
        source: ImageSource.gallery, imageQuality: 14);
    if (imagepicked != null) {
      theimage = File(imagepicked.path);
      imagename2 = basename(imagepicked.path);
      setState(() {});
    }
  }

  bool loading = false;
  void uploaddata() async {
    var formdata = formstate.currentState;
    formdata!.save();
    setState(() {
      loading = true;
    });

    Reference refstore =
        FirebaseStorage.instance.ref('/categorys/${imagename2}');
    await refstore.putFile(theimage!);
    String imagename = await refstore.getDownloadURL();

    FirebaseFirestore.instance
        .collection("people")
        .where("name", isEqualTo: selectedpeople)
        .limit(1)
        .get()
        .then((value) {
      FirebaseFirestore.instance
          .collection("people")
          .doc(value.docs[0].data()['docid'])
          .collection("category")
          .add({"name": categoryname, "picture": imagename}).then((thevalue) {
        FirebaseFirestore.instance
            .collection("people")
            .where("name", isEqualTo: selectedpeople)
            .limit(1)
            .get()
            .then((value) {
          FirebaseFirestore.instance
              .collection("people")
              .doc(value.docs[0].data()['docid'])
              .collection("category")
              .doc(thevalue.id)
              .update({'docid': thevalue.id});
        });
      });
    });
    setState(() {
      loading = false;
    });
  }

  DropdownMenuItem<String> buildmenuitem(String item) {
    return DropdownMenuItem(
      alignment: AlignmentDirectional.centerEnd,
      value: item,
      child: Text(
        item,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
