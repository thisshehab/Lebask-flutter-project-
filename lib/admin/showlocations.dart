import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class showdirections extends StatefulWidget {
  final latitude;
  final longtude;
  final storeslocations;
  final storesnames;
  final customername;
  const showdirections(
      {super.key,
      required this.latitude,
      required this.longtude,
      required this.storeslocations,
      required this.storesnames,
      required this.customername});

  @override
  State<showdirections> createState() => _showdirectionsState();
}

class _showdirectionsState extends State<showdirections> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setthestoreslocations();
    setthecustomerlocation();
  }

  setthestoreslocations() {
    BitmapDescriptor image = BitmapDescriptor.defaultMarker;

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "pictures/storelocation.png",
    ).then((value) => image = value);
    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code
      for (int i = 0; i < widget.storeslocations.length; i++) {
        markers.add(Marker(
            icon: image,
            markerId: MarkerId("alocation$i"),
            infoWindow: InfoWindow(
              title: "${widget.storesnames[i]}",
            ),
            position: LatLng(
              double.parse(widget.storeslocations[i].split('-')[0]),
              double.parse(widget.storeslocations[i].split('-')[1]),
            )));
      }
    });
  }
  setthecustomerlocation() {
    BitmapDescriptor image = BitmapDescriptor.defaultMarker;

    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code
      markers.add(Marker(
          icon: image,
          markerId: const MarkerId("alocation"),
          infoWindow: InfoWindow(
            title: "${widget.customername}",
          ),
          position: LatLng(
            double.parse(widget.latitude),
            double.parse(widget.longtude),
          )));
      setState(() {});
    });
  }

  late GoogleMapController mapcontroller;
  static const CameraPosition initialpos =
      CameraPosition(target: LatLng(15.3712857, 44.1917896), zoom: 12);
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
    );
  }
}
