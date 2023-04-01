import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lebask/admin/orderdetails.dart';
import 'package:lebask/main/other/navbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main/home/converter.dart';
import '../others/provider1.dart';

class orders extends StatefulWidget {
  const orders({super.key});

  @override
  State<orders> createState() => ordersState();
}

class ordersState extends State<orders> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getorders();
  }

  var customersdocid = [];
  var customercode = [];
  var customername = [];
  var customerphone = [];
  var customerstate = [];
  static String? selectedorderid;

  List<String> locations = [];
  List<Map<String, Map<String, String>>> customerproducts = [];
  bool loading = false;
  getorders() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("driverid", "CgWnEV5o50OQEHzzixmx");

    loading = true;
    customersdocid.clear();
    customercode.clear();
    customername.clear();
    customerphone.clear();
    customerproducts.clear();
    customerstate.clear();
    final prefs = await SharedPreferences.getInstance();

    var driverdoc = nav2.userdoc ?? prefs.getString('driverid');
    FirebaseFirestore.instance
        .collection("drivers")
        .doc(driverdoc)
        .collection("orders")
        .where("finished", isEqualTo: false)
        .get()
        .then((value) {
      try {
        selectedorderid = value.docs[0].data()['orderid'];
      } catch (e) {}
    });
    //step one>>>>>>>>>>>>>>>>>
    //
    //
    //>>>>>>>>>>>>>>>>>>>>>>>>>
    await FirebaseFirestore.instance
        .collection("users")
        .where("hasorder", isEqualTo: true)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(element.data()['docid'])
              .collection('orders')
              //!   you have to edit this>>>>>
              .where("completed", isEqualTo: false)
              .where("confirmed", isEqualTo: true)
              .get()
              .then((value) {
            locations.add(value.docs[0].data()['location']);
            customerstate.add(value.docs[0].data()['currentstep']);
            customercode.add(value.docs[0].data()['id']);
          });
          customersdocid.add(element.data()['docid']);
          customername.add(element.data()['name']);
          customerphone.add(element.data()['phone']);
        } catch (e) {}
      }
    });

    // print(customersdocid);
// step tow>>>>>>>>>>
//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>
    print(locations);
    setthestoreslocations();
  }

  late GoogleMapController mapcontroller;
  static const CameraPosition initialpos =
      CameraPosition(target: LatLng(15.3712857, 44.1917896), zoom: 12);
  Set<Marker> markers = {};

  setthestoreslocations() {
    BitmapDescriptor nothing = BitmapDescriptor.defaultMarker;
    BitmapDescriptor waiting = BitmapDescriptor.defaultMarker;

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "pictures/location.png",
    ).then((value) => nothing = value);
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "pictures/locationwaiting.png",
    ).then((value) => waiting = value);
// Here you can write your code
    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < locations.length; i++) {
        try {
          if (customerstate[i] == 1) {
            markers.add(Marker(
                icon: nothing,
                markerId: MarkerId("alocation$i"),
                infoWindow: InfoWindow(
                  title: "${customername[i]}",
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => orderdetails(
                            code: customercode[i],
                            candriveorder:
                                selectedorderid == null ? true : false,
                            customerdocid: customersdocid[i],
                            customername: customername[i],
                            customerphone: customerphone[i],
                          )));
                },
                position: LatLng(
                  double.parse(locations[i].split('-')[0]),
                  double.parse(locations[i].split('-')[1]),
                )));
          } else if (customerstate[i] == 2 &&
              customersdocid[i] == selectedorderid) {
            markers.add(Marker(
                icon: waiting,
                markerId: MarkerId("alocation$i"),
                infoWindow: InfoWindow(
                  title: "${customername[i]}",
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => orderdetails(
                            code: customercode[i],
                            candriveorder:
                                selectedorderid == null ? true : false,
                            customerdocid: customersdocid[i],
                            customername: customername[i],
                            customerphone: customerphone[i],
                          )));
                },
                position: LatLng(
                  double.parse(locations[i].split('-')[0]),
                  double.parse(locations[i].split('-')[1]),
                )));
          }
        } catch (e) {}
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
// Here you can write your code
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Counterprovider provider = Provider.of<Counterprovider>(context);

    return SafeArea(
        child: loading
            ? Scaffold(
                body: Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: SpinKitRipple(
                      color: provider.orange,
                      size: Get.width / 3.2,
                      duration: const Duration(milliseconds: 1100),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: GoogleMap(
                  // indoorViewEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onTap: ((pos) {}),
                  initialCameraPosition: initialpos,
                  markers: markers,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    mapcontroller = controller;
                  },
                ),
              ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   Counterprovider provider = Provider.of<Counterprovider>(context);

  //   return Directionality(
  //     textDirection: TextDirection.rtl,
  //     child: Scaffold(
  //         appBar: AppBar(title: const Text("الطلبات")),
  //         body: customername.isEmpty
  //             ? Center(
  //                 child: SpinKitCubeGrid(
  //                   color: provider.orange,
  //                   size: 100.0,
  //                   duration: const Duration(milliseconds: 1000),
  //                 ),
  //               )
  //             : ListView.builder(
  //                 itemCount: customername.length,
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                     margin: EdgeInsets.all(20),
  //                     color: provider.colortheme,
  //                     height: Get.height / 7,
  //                     width: Get.width,
  //                     child: InkWell(
  //                       onTap: () {
  //                         Navigator.of(context).push(MaterialPageRoute(
  //                             builder: (context) => orderdetails(
  //                                   customerdocid: customersdocid[index],
  //                                   customername: customername[index],
  //                                   customerphone: customerphone[index],
  //                                 )));
  //                       },
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(customername[index]),
  //                           Text(customerphone[index]),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               )),
  //   );
  // }
}
