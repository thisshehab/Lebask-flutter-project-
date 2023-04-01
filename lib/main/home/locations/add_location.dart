// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:get/get.dart';
// import 'package:lebask/main/home/cart/cart.dart';
// import 'package:lebask/main/other/navbar.dart';
// import 'package:lebask/main/search/Search.dart';
// import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../others/provider1.dart';
// import '../../../../main.dart';

// class addlocation extends StatefulWidget {
//   final isupdate;
//   String location;
//   String locationname;
//   addlocation(
//       {Key? key,
//       required this.isupdate,
//       this.location = '',
//       this.locationname = ''})
//       : super(key: key);

//   @override
//   State<addlocation> createState() => _addlocationState();
// }

// class _addlocationState extends State<addlocation> {
//   List tude = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (widget.isupdate) {
//       tude = widget.location.split('-');
//       print(tude);
//     }
//   }

//   String selectedlocation = "";
//   String selectedlatitude = '';
//   String selectedlongtude = '';
//   TextEditingController locationname = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     Counterprovider provider = Provider.of<Counterprovider>(context);

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: provider.darckblue,
//           title: Container(
//             margin: EdgeInsets.only(right: Get.width / 4.8),
//             child: Text(
//               widget.isupdate ? widget.locationname : "إضافة موقع",
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           leading: const BackButton(color: Colors.white),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: widget.isupdate
//                   ? FlutterLocationPicker(
//                       mapLoadingBackground: provider.colortheme,
//                       initPosition:
//                           LatLong(double.parse(tude[0]), double.parse(tude[1])),
//                       showZoomController: true,
//                       mapIsLoading: Center(
//                         child: SpinKitCubeGrid(
//                           color: provider.orange,
//                           size: 66.0,
//                           duration: const Duration(milliseconds: 1000),
//                         ),
//                       ),
//                       //initPosition: LatLong(),
//                       selectLocationButtonText: '',
//                       zoomButtonsBackgroundColor: provider.darckblue,
//                       locationButtonsBackgroundColor: provider.orange,
//                       initZoom: 120,
//                       showLocationController: false,
//                       minZoomLevel: 5,
//                       maxZoomLevel: 16,
//                       trackMyPosition: false,
//                       selectLocationButtonColor: provider.darckblue,
//                       onPicked: (pickedData) {})
//                   : FlutterLocationPicker(
//                       mapLoadingBackground: provider.colortheme,
//                       showZoomController: true,
//                       mapIsLoading: Center(
//                         child: SpinKitCubeGrid(
//                           color: provider.orange,
//                           size: 66.0,
//                           duration: const Duration(milliseconds: 1000),
//                         ),
//                       ),
//                       //initPosition: LatLong(),
//                       selectLocationButtonText: 'تحديد هذا الموقع',
//                       zoomButtonsBackgroundColor: provider.darckblue,
//                       locationButtonsBackgroundColor: provider.orange,
//                       initZoom: 120,
//                       minZoomLevel: 5,
//                       maxZoomLevel: 16,
//                       trackMyPosition: true,
//                       selectLocationButtonColor: provider.darckblue,
//                       onPicked: (pickedData) {
//                         selectedlocation = pickedData.address;
//                         selectedlatitude =
//                             pickedData.latLong.latitude.toString();
//                         selectedlongtude =
//                             pickedData.latLong.longitude.toString();
//                         print(pickedData.latLong.latitude);
//                         print(pickedData.latLong.longitude);
//                         print(pickedData.address);
//                         setState(() {});
//                       }),
//             ),
//             widget.isupdate
//                 ? Container()
//                 : Container(
//                     margin: EdgeInsets.only(
//                         top: Get.height / 33,
//                         bottom: 10,
//                         right: Get.width / 30,
//                         left: Get.width / 30),
//                     child: Column(
//                       children: [
//                         Text(
//                           "الموقع: $selectedlocation",
//                           style: TextStyle(fontSize: Get.width / 30),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           alignment: Alignment.topRight,
//                           margin: const EdgeInsets.only(right: 20, bottom: 12),
//                           child: Text(
//                             "تسمية الموقع",
//                             style:
//                                 TextStyle(fontSize: 16, color: provider.black),
//                           ),
//                         ),
//                         Container(
//                           padding:
//                               EdgeInsets.only(right: 20, bottom: 7, top: 7),
//                           decoration: BoxDecoration(
//                               color: provider.lightblue2,
//                               borderRadius: BorderRadius.circular(7),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Color.fromARGB(13, 0, 0, 0),
//                                   offset: Offset(4, 4),
//                                   blurRadius: 7,
//                                   spreadRadius: 3.0,
//                                 )
//                               ]),
//                           width: double.infinity,
//                           margin: const EdgeInsets.only(
//                               top: 0, left: 20, right: 20),
//                           child: TextField(
//                             controller: locationname,
//                             decoration: const InputDecoration(
//                               hintText: 'المنزل، العمل ...',
//                               border: InputBorder.none,
//                               labelStyle: TextStyle(height: 1.2),
//                               icon: Icon(Icons.location_on_outlined),
//                             ),
//                             keyboardType: TextInputType.name,
//                             style: const TextStyle(fontSize: 15, height: 2),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(
//                                   provider.darckblue)),
//                           onPressed: () {
//                             if (selectedlatitude != '') {
//                               adduserlocation(provider);
//                             } else {
//                               AwesomeDialog(
//                                 context: context,
//                                 dialogType: DialogType.warning,
//                                 animType: AnimType.rightSlide,
//                                 headerAnimationLoop: false,
//                                 title: 'حدد موقعًا',
//                                 btnOkOnPress: () {},
//                                 btnOkIcon: Icons.cancel,
//                                 btnOkColor: Colors.orangeAccent,
//                               ).show();
//                             }
//                           },
//                           child: Container(
//                             width: Get.width / 4.2,
//                             padding: EdgeInsets.all(5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 const Icon(
//                                   Icons.add_location_outlined,
//                                   color: Colors.white,
//                                 ),
//                                 Text(
//                                   'إضافة ',
//                                   style: TextStyle(
//                                       fontSize: Get.width / 27,
//                                       color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     )),
//           ],
//         ),
//       ),
//     );
//   }

//   adduserlocation(provider) async {
//     if (locationname.text == "") {
//       AwesomeDialog(
//         context: context,
//         dialogType: DialogType.error,
//         animType: AnimType.rightSlide,
//         headerAnimationLoop: false,
//         title: '! يجب تسمية الموقع ',
//         btnOkOnPress: () {},
//         btnOkIcon: Icons.cancel,
//         btnOkColor: Colors.red,
//       ).show();
//       return;
//     }
//     final prefs = await SharedPreferences.getInstance();

//     var userdoc = nav2.userdoc ?? prefs.getString('userid');
//         if (userdoc == null) {
//       AwesomeDialog(
//         context: context,
//         dialogType: DialogType.warning,
//         animType: AnimType.rightSlide,
//         headerAnimationLoop: false,
//         desc: " !قُم بتسجيل الدخول ",
//         btnOkOnPress: () {},
//         btnOkIcon: Icons.cancel,
//         btnOkColor: Colors.orange,
//       ).show();
//       return;
//     }
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(userdoc)
//         .collection('locations')
//         .add({
//       'location': '$selectedlatitude-$selectedlongtude',
//       'name': locationname.text
//     }).then((value2) {
//       FirebaseFirestore.instance
//           .collection("users")
//           .doc(userdoc)
//           .collection('locations')
//           .doc(value2.id)
//           .update({"docid": value2.id});
//       provider.addlocation('$selectedlatitude-$selectedlongtude',
//           locationname.text.isNotEmpty ? locationname.text : 'موقع', value2.id);
//     });
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.leftSlide,
//       headerAnimationLoop: false,
//       dialogType: DialogType.success,
//       showCloseIcon: true,
//       title: 'Succes',
//       desc: 'تمت إضافة الموقع ',
//       btnOkOnPress: () {},
//       btnOkIcon: Icons.check_circle,
//       onDismissCallback: (type) async {
//         Navigator.of(context).pop();
//       },
//     ).show();
//   }
// }
