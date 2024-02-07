import 'dart:io';

import 'package:c0nnect/components/default_button.dart';
import 'package:c0nnect/helper/strings.dart';
import 'package:c0nnect/widget/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locationInstance;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class LocationPickerWidget extends StatefulWidget {
  final ValueChanged<Map<String,String>> continueListener;

  const LocationPickerWidget({Key key, this.continueListener}) : super(key: key);

  @override
  _LocationPickerWidgetState createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  double initialLat, initialLng;
  BitmapDescriptor defaultPointer;
  GoogleMapController mapController;
  locationInstance.LocationData _position;
  bool _serviceEnabled;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Strings.GOOGLE_PLACES_API_KEY);

  locationInstance.Location location = new locationInstance.Location();
  locationInstance.PermissionStatus _permissionGranted;

  double selectedLat, selectedLng;
  String address;

  @override
  void initState() {
    if(Platform.isIOS){
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5, size: Size.square(20)), 'assets/images/location-pin-ios.png').then((onValue) {
        defaultPointer = onValue;
      });
    }else{
      BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5, size: Size.square(20)), 'assets/images/location-pin.png').then((onValue) {
        defaultPointer = onValue;
      });
    }


    getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            openGooglePlaceSearch(context);
          },
          child: Container(
            width: Get.width,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[200]),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search event location here',
                  style: TextStyle(color: Colors.grey[500], letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w500),
                ),

                Icon(Icons.search, size: 25, color: Colors.grey[500],),

              ],
            )
          ),
        ),

        SizedBox(height: 20,),
        Container(
          width: Get.width,
          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.green),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected location",
                style: TextStyle(color: Colors.white, letterSpacing: 1.0, fontSize: 12, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 10,),
              Text(
                address ?? "",
                style: TextStyle(color: Colors.white,height: 1.2, letterSpacing: 1.0, fontSize: 14, fontWeight: FontWeight.w500),
              ),

            ],
          )
        ),
        initialLat != null
            ? Container(
                width: Get.width,
                height: Get.height * 0.3,
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[300]),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: GoogleMap(
                      zoomControlsEnabled: true,
                      initialCameraPosition: CameraPosition(target: LatLng(initialLat, initialLng), zoom: 15),
                      myLocationEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      onCameraMove: (latLong) {
                        print("Checking lat long --- ${latLong.target.latitude}");
                        addMarker(LatLng(latLong.target.latitude, latLong.target.longitude), defaultPointer, "Current", InfoWindow());
                        setState(() {
                          selectedLat = latLong.target.latitude;
                          selectedLng = latLong.target.longitude;
                        });
                      },
                      onCameraIdle: () {
                        //Get address
                        if (selectedLat != null && selectedLng != null) {
                          getAddress(selectedLat, selectedLng);
                        } else {
                          getAddress(initialLat, initialLng);
                        }
                      },
                      onMapCreated: onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                        ),
                      ].toSet()),
                ),
              )
            : LoadingWidget(),

        SizedBox(height: 20,),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Container(
                  width: double.infinity,
                  child: DefaultButton(
                    text: "Continue",
                    press: () {
                      if (selectedLng != null && selectedLat != null) {
                        widget.continueListener({
                          'address' : address,
                          'lat' : selectedLat.toString(),
                          'lng' : selectedLng.toString(),
                        });
                      }
                    },
                  )),
            ),
          ),
        ),
      ],
    );
  }

  addMarker(LatLng position, BitmapDescriptor descriptor, String label, InfoWindow infoWindow) {
    MarkerId markerId = MarkerId(label);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position, infoWindow: infoWindow);

    markers[markerId] = marker;
  }

  //Map Functins
  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locationInstance.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locationInstance.PermissionStatus.granted) {
        return;
      }
    }

    _position = await location.getLocation();

    print("Check User location ${_position.latitude} : ${_position.longitude}");

    setState(() {
      initialLat = _position.latitude;
      initialLng = _position.longitude;

      selectedLat = _position.latitude;
      selectedLng = _position.longitude;
    });
  }

  void getAddress(double lat, double lng) async {
    print("Cehcking lat lng --- ${lat.toString()} - ${lng.toString()}");
    final coordinates = new Coordinates(lat, lng);
//    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates).catchError((error){print("Error --- ${error}");});
    var addresses = await Geocoder.google(Strings.GOOGLE_MAP_API_KEY).findAddressesFromCoordinates(coordinates);
    if(addresses == null){
      return;
    }
    var first = addresses.first;
    setState(() {
      address = first.addressLine;
    });
  }

  void openGooglePlaceSearch(BuildContext context) async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Strings.GOOGLE_PLACES_API_KEY,
      mode: Mode.overlay, // Mode.fullscreen
      language: "en",
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p?.placeId);
    selectedLat = detail.result.geometry.location.lat;
    selectedLng = detail.result.geometry.location.lng;

    setState(() {
      address = p.description;

      var newPosition = LatLng(selectedLat, selectedLng);
      CameraPosition newCameraPosition = CameraPosition(target: newPosition, zoom: 15);
      mapController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    });
  }
}
