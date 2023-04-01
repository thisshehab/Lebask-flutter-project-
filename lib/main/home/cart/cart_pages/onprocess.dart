import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lebask/admin/getthediffrence.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../others/provider1.dart';

class inprocess extends StatefulWidget {
  const inprocess({super.key});

  @override
  State<inprocess> createState() => _inprocessState();
}

class _inprocessState extends State<inprocess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbasedata();
  }

  int currentstep = 0;
  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("حالة الطلب"),
          leading: BackButton(color: Colors.white),
        ),
        body: stage == null
            ? Container()
            : Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: provider.orange)),
                child: Stepper(
                  onStepCancel: currentstep == 0
                      ? null
                      : () {
                          currentstep--;
                          setState(() {});
                        },
                  controlsBuilder: (context, details) {
                    return Container();
                  },
                  currentStep: currentstep,
                  type: StepperType.vertical,
                  steps: steps(),
                ),
              ),
      ),
    );
  }

  List<Step> steps() => [
        Step(
            state: currentstep > 0 ? StepState.complete : StepState.indexed,
            title: Text(
              "قيد المراجعة",
              style: TextStyle(fontSize: Get.height / 50),
            ),
            content: Container(
              height: Get.height / 1.5,
              child: onprocess(),
            ),
            isActive: currentstep >= 0),
        Step(
            state: currentstep > 1 ? StepState.complete : StepState.indexed,
            title: Text(
              "في الطريق",
              style: TextStyle(fontSize: Get.height / 50),
            ),
            content: Container(height: Get.height / 1.5, child: onway()),
            isActive: currentstep >= 1),
      ];

  onprocess() {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Lottie.network(
            "https://assets7.lottiefiles.com/private_files/lf30_f0fhps6k.json",
          ),
        ),
        SizedBox(
          height: Get.height / 8,
        ),
        Text("طلبك قيد المراجعة...",
            style: TextStyle(
              fontSize: Get.height / 36,
            )),
        SizedBox(
          height: Get.height / 12,
        ),
        ElevatedButton(
            onPressed: () {
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
                title: 'إلغاء الطلب ؟',
                showCloseIcon: true,
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  final prefs = await SharedPreferences.getInstance();
                  var userdoc = nav2.userdoc ?? prefs.getString('userid');
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userdoc)
                      .update({"hasorder": false});
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userdoc)
                      .collection('orders')
                      .where("completed", isEqualTo: false)
                      .where("confirmed", isEqualTo: true)
                      .get()
                      .then(
                    (value) async {
                      for (var element1 in value.docs) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(userdoc)
                            .collection('orders')
                            .doc(element1.data()['docid'])
                            .update({"currentstep": 0, 'confirmed': false});
                        provider.thelevel = element1.data()['currentstep'];
                      }
                    },
                  );

                  provider.setthelevel(0);
                },
              ).show();
            },
            child: Container(
              child: Container(
                  padding: EdgeInsets.all(8), child: Text("الغاء الطلب")),
            )),
        SizedBox(
          height: Get.height / 20,
        )
      ],
    );
  }

  onway() {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Lottie.network(
            "https://assets7.lottiefiles.com/packages/lf20_7kjflsve.json",
          ),
        ),
        Text("طلبك على بُعد",
            style: TextStyle(
              fontSize: Get.height / 40,
            )),
        SizedBox(
          height: Get.height / 30,
        ),
        SlideCountdown(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: provider.containershadow,
              color: provider.orange.withOpacity(0.8)),
          padding: EdgeInsets.all(9),
          duration: Duration(minutes: minute, hours: hour),
          textDirection: TextDirection.rtl,
          durationTitle: DurationTitle(
              minutes: "دقائق", days: "يوم", hours: "ساعات", seconds: "ثواني"),
          slideDirection: SlideDirection.up,
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          alignment: Alignment.topRight,
          child: Text(
            "كود التوصيل :" + "$code",
            style: TextStyle(fontSize: Get.height / 47),
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  int? stage;
  String? code;
  getbasedata() async {
    final prefs = await SharedPreferences.getInstance();
    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    String time1 = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('orders')
        .where("completed", isEqualTo: false)
        .where("confirmed", isEqualTo: true)
        .get()
        .then((value) {
      stage = value.docs[0].data()['currentstep'];
      currentstep = stage! - 1;
      code = value.docs[0].data()['id'];

      time1 = value.docs[0].data()['time'] ?? "";
      setState(() {});
    });
    try {
      hour = int.parse(time()
          .hour(
              theend: "${time1.split(':')[0]}:${time1.split(':')[1]}",
              thestart: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}")
          .split(':')[0]);

      minute = int.parse(time()
          .hour(
              theend: "${time1.split(':')[0]}:${time1.split(':')[1]}",
              thestart: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}")
          .split(':')[1]);
    } catch (e) {}
    setState(() {});
  }

  int hour = 0;
  int minute = 0;
}
