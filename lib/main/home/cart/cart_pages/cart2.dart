import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lebask/main/home/cart/cart_pages/confirm.dart';
import 'package:lebask/main/home/cart/cart_pages/get_location.dart';
import 'package:lebask/main/home/cart/cart_pages/onprocess.dart';
import 'package:lebask/main/home/cart/cart_pages/products.dart';
import 'package:lebask/main/other/item_details.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../others/provider1.dart';

class cart2 extends StatefulWidget {
  const cart2({Key? key}) : super(key: key);

  @override
  State<cart2> createState() => _cart2State();
}

class _cart2State extends State<cart2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettheorderstate();
  }

  int currentstep = 0;
  gettheorderstate() async {
    Counterprovider provider =
        Provider.of<Counterprovider>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        provider.setthelevel(0);
      }
      for (var element1 in value.docs) {
        provider.setthelevel(element1.data()['currentstep'] == null
            ? 0
            : element1.data()['currentstep']);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return
        //! you have to solve this later lazy
        provider.thelevel == null
            ? Scaffold(
                body: SizedBox(
                  child: Center(
                    child: SpinKitCubeGrid(
                      color: provider.orange,
                      size: Get.height / 12,
                      duration: const Duration(milliseconds: 1000),
                    ),
                  ),
                ),
              )
            : provider.thelevel! < 3 && provider.thelevel! > 0
                ? inprocess()
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Scaffold(
                        appBar: AppBar(
                          leading: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                currentstep = 0;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          centerTitle: true,
                          backgroundColor: provider.darckblue,
                          elevation: 0.0,
                          title: const Text(
                            "السلة",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        body: Container(
                          width: Get.width,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: provider.orange)),
                            child: Stepper(
                              onStepCancel: currentstep == 0
                                  ? null
                                  : () {
                                      currentstep--;
                                      setState(() {});
                                    },
                              controlsBuilder: (context, details) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: details.onStepContinue,
                                          child: Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(5, 5),
                                                  blurRadius: 18,
                                                  spreadRadius: 1.0,
                                                )
                                              ]),
                                              child: Text("التالي"))),
                                    ),
                                    SizedBox(
                                      width: Get.width / 5,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              foregroundColor: currentstep == 0
                                                  ? MaterialStateProperty.all(
                                                      provider.gray2)
                                                  : MaterialStateProperty.all(
                                                      provider.black),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent)),
                                          onPressed: details.onStepCancel,
                                          child: Text("عودة")),
                                    )
                                  ],
                                );
                              },
                              currentStep: currentstep,
                              type: StepperType.vertical,
                              steps: steps(),
                              onStepTapped: (value) {
                                currentstep = value;
                                setState(() {});
                              },
                              onStepContinue: () {
                                final lasstep =
                                    currentstep == steps().length - 1;
                                if (currentstep == 2) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    borderSide: const BorderSide(
                                      color: Colors.green,
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
                                    desc: 'تأكيد الطلب',
                                    showCloseIcon: true,
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      if (location.selectedlocation == "") {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          headerAnimationLoop: false,
                                          title: 'قُم باختيار موقع',
                                          btnOkOnPress: () {},
                                          btnOkIcon: Icons.cancel,
                                          btnOkColor: Colors.orange,
                                        ).show();
                                        return;
                                      } else if (ItemDetails
                                          .useritemname.isEmpty) {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          headerAnimationLoop: false,
                                          title: '! السلة فارغة',
                                          btnOkOnPress: () {},
                                          btnOkIcon: Icons.cancel,
                                          btnOkColor: Colors.orange,
                                        ).show();
                                        return;
                                      }
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      var userdoc = nav2.userdoc ??
                                          prefs.getString('userid');
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userdoc)
                                          .update({'hasorder': true});

                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userdoc)
                                          .collection('orders')
                                          .where("completed", isEqualTo: false)
                                          .where("confirmed", isEqualTo: false)
                                          .get()
                                          .then((value) async {
                                        var radnomvalue = Random();
                                        int id = radnomvalue.nextInt(100000);
                                        for (var element1 in value.docs) {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(userdoc)
                                              .collection('orders')
                                              .doc(element1.data()['docid'])
                                              .update({
                                            "id": id.toString(),
                                            'confirmed': true,
                                            'currentstep': 1,
                                            "date": DateTime.now(),
                                            'location':
                                                location.selectedlocation
                                          });
                                        }
                                      });
                                      provider.setthelevel(1);
                                      setState(() {});
                                    },
                                  ).show();
                                  return;
                                }
                                currentstep++;
                                // if (lasstep) {
                                //   Navigator.push(context,
                                //       MaterialPageRoute(builder: ((context) {
                                //     return const Confirm();
                                //   })));
                                // }
                                setState(() {});
                              },
                            ),
                          ),
                        )),
                  );
  }

  List<Step> steps() => [
        Step(
            state: currentstep > 0 ? StepState.complete : StepState.indexed,
            title: Text("سلة المشتريات"),
            content: Container(
              height: Get.height / 1.5,
              child: Products(),
            ),
            isActive: currentstep >= 0),
        Step(
            state: currentstep > 1 ? StepState.complete : StepState.indexed,
            title: Text("الموقع "),
            content: Container(height: Get.height / 1.5, child: location()),
            isActive: currentstep >= 1),
        Step(
            state: currentstep > 2 ? StepState.complete : StepState.indexed,
            title: Container(child: Text("تأكيد الطلب")),
            content: Container(height: Get.height / 1.5, child: Confirm()),
            isActive: currentstep >= 2),
      ];
}
