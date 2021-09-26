import 'dart:async';
import 'dart:typed_data';
//import 'dart:html';

import 'package:app_comunic/app/ui/globald_widgets/rounded_buttom_forms.dart';
import 'package:app_comunic/app/ui/pages/gestionar_ubicacion/bloc/places_function.dart';
import 'package:app_comunic/app/ui/pages/gestionar_ubicacion/model/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapList extends StatefulWidget {
  const MapList({Key? key}) : super(key: key);

  @override
  _MapListState createState() => _MapListState();
}

class _MapListState extends State<MapList> {
  Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late LatLng currentLocation;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> _markers = Set();
  @override
  void initState() {
    super.initState();
    getMarkerData();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-12.078600, -76.977333),
    zoom: 17,
  );

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['latitud'].latitude, specify['longitud'].longitude),
      //infoWindow: InfoWindow(title: specify['nombreSitio']),
    );
    setState(() {
      markers[markerId] = marker;
    });
    print(LatLng);
    _markers.add(
      Marker(
        markerId: markerId,
        position:
            LatLng(specify['latitud'].latitude, specify['longitud'].longitude),
      ),
    );
    print(LatLng);
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('mark').get().then((markerData) {
      if (markerData.docs.isNotEmpty) {
        for (int i = 0; i < markerData.docs.length; ++i) {
          initMarker(markerData.docs[i].data(), markerData.docs[i].id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
        title: Text(
          'Sitios',
          textAlign: TextAlign.center,
          // style: Colors.indigo.lightTheme.textTheme.headline2
        ),
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        //   onPressed: getMarkerData(),
        label: Text('Registrar!'),
        icon: Icon(Icons.directions_boat),
        onPressed: () {
          getMarkerData();
        },
      ),
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
