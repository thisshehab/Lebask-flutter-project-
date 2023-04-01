import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lebask/registration/signup.dart';
import 'package:lebask/registration/storesignup.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_sign/driver_signin.dart';
import 'main/other/navbar.dart';
import 'others/provider1.dart';
import 'registration/signin.dart';

void main() async {
  /* const app = initializeApp(firebaseConfig);
const db = initializeFirestore(app, {
  experimentalForceLongPolling: true,
});
*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(raelone());
}

class raelone extends StatelessWidget {
  DateTime temp = DateTime.now().toUtc();
  DateTime d1 = DateTime.now().toUtc();
  var d2 = DateTime.utc(2022, 10, 20);

  raelone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    d1 = DateTime.utc(temp.year, temp.month, temp.day);
    return d1.isBefore(d2)
        ? Container()
        : ChangeNotifierProvider(
            create: (context) => Counterprovider(), child: MyApp());
  }
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  static const int dilivreyprice = 1000;
  static int likenumber = 0;

  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isbright = false;
  bool activeConnection = true;

  @override
  void initState() {
    super.initState();
    Counterprovider provider =
        Provider.of<Counterprovider>(context, listen: false);
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    getthemode();
    provider.setcolors(islight: getthemode(), isinitial: false);
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        activeConnection = status == InternetConnectionStatus.connected;

        if (activeConnection == false) {}
      });
    });
  }

  Future<bool> getthemode() async {
    Counterprovider provider =
        Provider.of<Counterprovider>(context, listen: false);
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    final prefs = await SharedPreferences.getInstance();
    isbright = prefs.getBool('isdark') != null
        ? prefs.getBool('isdark')!
        : brightness == Brightness.light;

    return prefs.getBool('isdark') != null
        ? prefs.getBool('isdark')!
        : brightness == Brightness.light;
  }
  //here the colors ======================

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetMaterialApp(
        // locale: Locale("en"),
        // supportedLocales: [
        //   const Locale('en', ''),
        //   const Locale('fr', ''),
        // ],
        debugShowCheckedModeBanner: false,
        title: 'لباسك',
        theme: ThemeData(
          brightness: provider.bright,
          inputDecorationTheme: const InputDecorationTheme(),
          primarySwatch: Colors.orange,
          primaryColor: Colors.orange,
          primaryColorDark: Colors.orange,
          fontFamily: 'Vazirmatn-VariableFont_wght',
          textTheme: const TextTheme(
              // headline1: TextStyle(color: Colors.deepPurpleAccent),
              // headline2: TextStyle(color: Colors.deepPurpleAccent),
              // bodyText2: TextStyle(color: Colors.deepPurpleAccent),
              // subtitle1: TextStyle(color: Colors.pinkAccent),
              ),
        ),
        //
        home:
            // driversignup()
            activeConnection
                ? (user != null ? nav2() : signup())
                : noconnection(context),
        navigatorObservers: [FlutterSmartDialog.observer],
        // here
        builder: FlutterSmartDialog.init(),
      ),
    );
  }

  noconnection(context) {
    Counterprovider provider =
        Provider.of<Counterprovider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Lottie.asset(
                "pictures/connectionerror.json",
              ),
            ),
            Text("!no internet connection",
                style: TextStyle(
                  fontSize: Get.height / 33,
                  color: provider.black,
                )),
            SizedBox(
              height: Get.height / 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(18, 0, 0, 0),
                        offset: const Offset(5, 10),
                        blurRadius: 8,
                        spreadRadius: 1.0,
                      )
                    ]),
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.network_check),
                        onPressed: () async {
                          activeConnection =
                              await InternetConnectionChecker().hasConnection;

                          setState(() {});
                        },
                        label: Container(
                            padding: const EdgeInsets.all(9),
                            child: const Text(
                              "المحاولة مجددًا",
                              style: TextStyle(fontSize: 15),
                            ))),
                  ),
                ),
                Container(
                  child: Container(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(9),
                            child: Text(
                              "إغلاق",
                              style: TextStyle(
                                  fontSize: 15, color: provider.black),
                            ))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: Get.height / 5,
            )
          ],
        ),
      ),
    );
  }
}
