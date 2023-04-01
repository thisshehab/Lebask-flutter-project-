import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../others/provider1.dart';

class editlocaitno extends StatefulWidget {
  final latitude;
  final longtude;
  final locationname;
  final isupdate;
  final locaitondocid;
  const editlocaitno(
      {Key? key,
      required this.latitude,
      required this.longtude,
      required this.locationname,
      this.locaitondocid,
      this.isupdate})
      : super(key: key);

  @override
  State<editlocaitno> createState() => _editlocaitnoState();
}

class _editlocaitnoState extends State<editlocaitno> {
  String selectedlatitude = '';
  String selectedlongtude = '';
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
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "pictures/storelocation.png",
    ).then((value) => image = value);
    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code
      markers.add(Marker(
          icon: image,
          markerId: const MarkerId("alocation"),
          infoWindow: InfoWindow(
            title: "${widget.locationname}",
          ),
          position: LatLng(
            double.parse(widget.latitude),
            double.parse(widget.longtude),
          )));
      setState(() {});
    });
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
                      onTap: ((pos) {
                        if (widget.isupdate) {
                          markers.clear();
                          markers.add(Marker(
                              markerId: const MarkerId("alocation"),
                              position: LatLng(pos.latitude, pos.longitude)));
                          selectedlocation = true;
                          selectedlatitude = pos.latitude.toString();
                          selectedlongtude = pos.longitude.toString();
                          setState(() {});
                        }
                      }),
                      initialCameraPosition: CameraPosition(
                          target: LatLng(double.parse(widget.latitude),
                              double.parse(widget.longtude)),
                          zoom: 14),
                      markers: markers,
                      zoomControlsEnabled: true,
                      mapType: MapType.normal,
                      onMapCreated: (controller) {
                        mapcontroller = controller;
                      },
                    ),
                    !widget.isupdate
                        ? Container()
                        : Container(
                            margin:
                                const EdgeInsets.only(right: 17, bottom: 40),
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
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.green),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                      ),
                                      onPressed: () async {
                                        Position pos = await currentpossition();

                                        selectedlatitude =
                                            pos.latitude.toString();
                                        selectedlongtude =
                                            pos.longitude.toString();
                                        mapcontroller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(pos.latitude,
                                                        pos.longitude),
                                                    zoom: 18)));
                                        markers.clear();
                                        markers.add(Marker(
                                            icon: image,
                                            infoWindow: const InfoWindow(
                                              title: "موقعي",
                                            ),
                                            markerId: const MarkerId(
                                                "currentlocation"),
                                            position: LatLng(
                                                pos.latitude, pos.longitude)));
                                        selectedlocation = true;
                                        setState(() {});
                                      },
                                      icon:const Icon(Icons.my_location_rounded),
                                      label: const Text("تحديد موقعي"),
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
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                const  Color.fromARGB(
                                                      255, 239, 88, 0)),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        onPressed: () {
                                          adduserlocation(provider);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 17,
                                        ),
                                        label: Container(
                                            child: const Text("تعديل الموقع")),
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
      FirebaseFirestore.instance
          .collection("users")
          .doc(userdoc)
          .collection('locations')
          .doc(widget.locaitondocid)
          .update({"location": '$selectedlatitude-$selectedlongtude'});
      provider.updatelocation(
          locaitondocid: widget.locaitondocid,
          selectedlatitude: selectedlatitude,
          selectedlongtude: selectedlongtude);
    }
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: '',
      desc: 'تم تعديل الموقع',
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) async {
        Navigator.of(context).pop();
      },
    ).show();
  }
}
