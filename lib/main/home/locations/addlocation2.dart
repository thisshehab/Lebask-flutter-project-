import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../others/provider1.dart';

class addlocation2 extends StatefulWidget {
  final isstore;
  const addlocation2({Key? key, this.isstore = false}) : super(key: key);
  @override
  State<addlocation2> createState() => addlocation2State();
}

class addlocation2State extends State<addlocation2> {
  static String selectedlatitude = '';
  static String selectedlongtude = '';
  late GoogleMapController mapcontroller;
  static const CameraPosition initialpos =
      CameraPosition(target: LatLng(15.3712857, 44.1917896), zoom: 14);
  Set<Marker> markers = {};
  TextEditingController locationname = TextEditingController();
  int next = 0;
  bool selectedlocation = false;
  BitmapDescriptor image = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration.empty,
    //   "pictures/third.png",
    // ).then((value) => image = value);
  }

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      // indoorViewEnabled: true,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      onTap: ((pos) {
                        markers.clear();
                        markers.add(Marker(
                            markerId: const MarkerId("alocation"),
                            position: LatLng(pos.latitude, pos.longitude)));
                        selectedlocation = true;
                        selectedlatitude = pos.latitude.toString();
                        selectedlongtude = pos.longitude.toString();
                        setState(() {});
                      }),
                      initialCameraPosition: initialpos,
                      markers: markers,
                      zoomControlsEnabled: true,
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        mapcontroller = controller;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 17, bottom: 40),
                      alignment: Alignment.bottomRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(24, 0, 0, 0),
                                offset: Offset(4, 10),
                                blurRadius: 7,
                                spreadRadius: 3.0,
                              )
                            ]),
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.green),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () async {
                                  Position pos = await currentpossition();
                                  selectedlatitude = pos.latitude.toString();
                                  selectedlongtude = pos.longitude.toString();
                                  mapcontroller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(
                                                  pos.latitude, pos.longitude),
                                              zoom: 18)));
                                  markers.clear();
                                  markers.add(Marker(
                                      icon: image,
                                      infoWindow: const InfoWindow(
                                        title: "موقعي",
                                      ),
                                      markerId:
                                          const MarkerId("currentlocation"),
                                      position:
                                          LatLng(pos.latitude, pos.longitude)));
                                  selectedlocation = true;
                                  setuserlocation();
                                  setState(() {});
                                },
                                icon: Icon(Icons.my_location_rounded),
                                label: Text("تحديد موقعي"),
                              ),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(24, 0, 0, 0),
                                  offset: Offset(4, 10),
                                  blurRadius: 7,
                                  spreadRadius: 3.0,
                                )
                              ]),
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shadowColor:
                                        MaterialStateProperty.all(Colors.green),
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 239, 88, 0)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    if (selectedlocation && next == 0) {
                                      next++;

                                      if (widget.isstore)
                                        addstorelocation(provider);
                                      setState(() {});
                                      return;
                                    } else if (next == 0) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        headerAnimationLoop: false,
                                        title: 'حدد موقعًا',
                                        btnOkOnPress: () {},
                                        btnOkIcon: Icons.cancel,
                                        btnOkColor: Colors.orangeAccent,
                                      ).show();
                                      return;
                                    }
                                    adduserlocation(provider);

                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 17,
                                  ),
                                  label: Container(
                                      padding: EdgeInsets.only(
                                          right: Get.width / 66,
                                          left: Get.width / 29),
                                      child: const Text("التالي")),
                                ),
                              ),
                            ),
                          ),

                          // FloatingActionButton(
                          //   backgroundColor: provider.orange,
                          //   onPressed: () async {
                          //     Position pos = await currentpossition();
                          //     mapcontroller.animateCamera(
                          //         CameraUpdate.newCameraPosition(CameraPosition(
                          //             target: LatLng(pos.latitude, pos.longitude),
                          //             zoom: 18)));
                          //     markers.clear();
                          //     markers.add(Marker(
                          //         markerId: const MarkerId("currentlocation"),
                          //         position: LatLng(pos.latitude, pos.longitude)));
                          //     setState(() {});
                          //   },
                          //   child: Icon(Icons.my_location_rounded),
                          // ),
                          Container(
                            width: 1,
                          )
                        ],
                      ),
                    ),
                    widget.isstore
                        ? Container()
                        : AnimatedContainer(
                            curve: Curves.fastOutSlowIn,
                            duration: const Duration(milliseconds: 260),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(85, 0, 0, 0),
                                    offset: Offset(4, 4),
                                    blurRadius: 7,
                                    spreadRadius: 3.0,
                                  )
                                ],
                                color: provider.colortheme,
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(Get.width / 12),
                                    bottomLeft:
                                        Radius.circular(Get.width / 12))),
                            height: next >= 1 ? Get.height / 5 : 0,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 19,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      "تسمية الموقع",
                                      style: TextStyle(
                                          fontSize: 16, color: provider.black),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(
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
                                    child: TextField(
                                      controller: locationname,
                                      decoration: const InputDecoration(
                                        hintText: 'المنزل، العمل ...',
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(height: 1.2),
                                        icon: Icon(Icons.location_on_outlined),
                                      ),
                                      keyboardType: TextInputType.name,
                                      style: const TextStyle(
                                          fontSize: 15, height: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height / 26)
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> currentpossition() async {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
          child: SpinKitRipple(
            color: Colors.orange,
            size: Get.width / 3.2,
            duration: const Duration(milliseconds: 1300),
          ),
        );
      },
    );
    bool serviceenabled;
    LocationPermission permission;
    serviceenabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceenabled) {
      return Future.error("location premission denyed");
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("permission denyed");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("permission denyed for ever");
    }
    Position pos = await Geolocator.getCurrentPosition();
    Navigator.of(context).pop();

    return pos;
  }

  adduserlocation(provider) async {
    if (locationname.text == "") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        title: 'يجب تسمية الموقع',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orangeAccent,
      ).show();
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    if (userdoc == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        desc: " !قُم بتسجيل الدخول ",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orange,
      ).show();
      return;
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .collection('locations')
        .add({
      'location': '$selectedlatitude-$selectedlongtude',
      'name': locationname.text
    }).then((value2) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userdoc)
          .collection('locations')
          .doc(value2.id)
          .update({"docid": value2.id});
      provider.addlocation('$selectedlatitude-$selectedlongtude',
          locationname.text.isNotEmpty ? locationname.text : 'موقع', value2.id);
    });
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: 'تمت إضافة الموقع ',
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) async {
        Navigator.of(context).pop();
      },
    ).show();
  }

  addstorelocation(provider) async {
    final prefs = await SharedPreferences.getInstance();

    // var userdoc = nav2.userdoc ?? prefs.getString('userid');

    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(userdoc)
    //     .collection('locations')
    //     .add({
    //   'location': '$selectedlatitude-$selectedlongtude',
    //   'name': locationname.text
    // }).then((value2) {
    //   FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(userdoc)
    //       .collection('locations')
    //       .doc(value2.id)
    //       .update({"docid": value2.id});
    //   provider.addlocation('$selectedlatitude-$selectedlongtude',
    //       locationname.text.isNotEmpty ? locationname.text : 'موقع', value2.id);
    // });
    provider.showredmethod(showred2: false);
    Navigator.of(context).pop();
  }

  setuserlocation() async {
    final prefs = await SharedPreferences.getInstance();

    var userdoc = nav2.userdoc ?? prefs.getString('userid');
    if (userdoc == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        headerAnimationLoop: false,
        desc: " !قُم بتسجيل الدخول ",
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.orange,
      ).show();
      return;
    }
    if (selectedlatitude != "") {
      FirebaseFirestore.instance.collection("users").doc(userdoc).update(
          {"usercurrentlocation": '$selectedlatitude-$selectedlongtude'});
    }
  }
}
