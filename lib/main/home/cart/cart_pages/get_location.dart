import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lebask/main/home/locations/editlocations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import '../../../../others/provider1.dart';
import '../../locations/addlocation2.dart';

class location extends StatefulWidget {
  const location({Key? key}) : super(key: key);

  @override
  State<location> createState() => MyAppState();
  static String selectedlocation = "";
}

class MyAppState extends State<location> {
  double selectedlatitude = 15.362400011673422;
  double selectedlongtude = 44.19061157852411;
  String lcationdocid = "";
  String locationname = "";

  final TextEditingController _controller = TextEditingController();
  late GoogleMapController mapcontroller;

  @override
  Widget build(BuildContext context) {
    Counterprovider provider = Provider.of<Counterprovider>(context);

    Set<Marker> markers = {};
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId("alocation"),
        position: LatLng(selectedlatitude, selectedlongtude)));
    return Stack(
      children: [
        provider.loctiondocid.isEmpty
            ? const Center(
                child: Text(
                  "لم تتم إضافة أي موقع !",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر موقع التوصيل :',
                    style: TextStyle(fontSize: Get.height / 54),
                  ),
                  const Divider(
                    thickness: 1.2,
                    height: 17,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: GoogleMap(
                        // liteModeEnabled: true,
                        zoomControlsEnabled: false,
                        // indoorViewEnabled: true,
                        onTap: ((pos) {
                          if (m_selectedlocation == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              headerAnimationLoop: false,
                              desc: ' !أختر موقع لعرضه ',
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.cancel,
                              btnOkColor: Colors.orange,
                            ).show();
                            return;
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return editlocaitno(
                              isupdate: true,
                              latitude: selectedlatitude.toString(),
                              longtude: selectedlongtude.toString(),
                              locaitondocid: lcationdocid,
                              locationname: locationname,
                            );
                          })));
                        }),
                        initialCameraPosition: CameraPosition(
                            target: LatLng(selectedlatitude, selectedlongtude),
                            zoom: 13),
                        markers: markers,
                        mapType: MapType.normal,
                        onMapCreated: (controller) {
                          setState(() {
                            mapcontroller = controller;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.locaiton.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 250),
                        child: SlideAnimation(
                            verticalOffset: 8,
                            child: FadeInAnimation(
                                child: Container(
                              height: 50,
                              child: RadioListTile(
                                  activeColor: provider.orange,
                                  title: Text(provider.locaitonname[index]),
                                  value: provider.loctiondocid[index],
                                  groupValue: m_selectedlocation,
                                  onChanged: (value) {
                                    provider.setlocationindex(index);
                                    lcationdocid = provider.loctiondocid[index];
                                    locationname = provider.locaitonname[index];
                                    selectedlatitude = double.parse(
                                        provider.locaiton[index].split('-')[0]);
                                    selectedlongtude = double.parse(
                                        provider.locaiton[index].split('-')[1]);
                                    m_selectedlocation = value.toString();
                                    location.selectedlocation =
                                        '$selectedlatitude-$selectedlongtude';
                                    mapcontroller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: LatLng(
                                                    double.parse(provider
                                                        .locaiton[index]
                                                        .split('-')[0]),
                                                    double.parse(provider
                                                        .locaiton[index]
                                                        .split('-')[1])),
                                                zoom: 16)));
                                    setState(() {});
                                  }),
                            ))),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
        Container(
            margin: EdgeInsets.only(bottom: Get.height / 50),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(provider.darckblue)),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const addlocation2(),
                    type: PageTransitionType.leftToRight,
                    duration: const Duration(milliseconds: 320),
                    reverseDuration: const Duration(milliseconds: 320),
                  ),
                );
              },
              child: Container(
                width: Get.width / 3.8,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(44, 0, 0, 0).withOpacity(0.3),
                    offset: const Offset(5, 5),
                    blurRadius: 18,
                    spreadRadius: 1.0,
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.add_location_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      'إضافة موقع',
                      style: TextStyle(
                          fontSize: Get.height / 60, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  String m_selectedlocation = "";
}
