

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class HomeScreen extends StatefulWidget {
static const String routeName='home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<Marker> marker={};
  Completer<GoogleMapController> _controller = Completer();
Location location = new Location();
StreamSubscription <LocationData>? streamSubscription=null;
double lat=30.788891;
 double lang= 31.0677548;


 dispose(){

   streamSubscription?.cancel();
 }
initState(){
  getUserLocation();
  var usermarker=Marker(markerId: MarkerId('user-markere'),
  position:LatLng(locationData?.latitude??lat,locationData?.longitude??lang) );
  marker.add(usermarker);


}

static final CameraPosition _myhome = CameraPosition(
  target: LatLng(30.788891, 31.0677548),
  zoom: 14.4746,
);

static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414);

late PermissionStatus prmissionstatus;

bool isServicedEnable=false;

LocationData? locationData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('location'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _myhome,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: marker,
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        ),
    );
  }

Future<bool> isPermissionGranted()async{
    prmissionstatus= await location.hasPermission();
    if(prmissionstatus==PermissionStatus.denied){
      prmissionstatus=await location.requestPermission();
    }
    return prmissionstatus==PermissionStatus.granted;
  }
Future<void> _goToTheLake() async {
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
}
updateusermarker(){
  var usermarker=Marker(markerId: MarkerId('user-markere'),
      position:LatLng(locationData?.latitude??lat,locationData?.longitude??lang) );
  marker.add(usermarker);
  setState(() {

  });
}

  Future<bool>isServiedEnapeld()async{
isServicedEnable= await location.serviceEnabled();
if(!isServicedEnable){
  isServicedEnable=await location.requestService();

}
return isServicedEnable;
  }

  void getUserLocation() async{
    var permissiomstatus= await isPermissionGranted();
    var gpsenable=await isServiedEnapeld();
    if(permissiomstatus==false){
      return;
    }
    if(gpsenable==false){
      return;
    }
    if(permissiomstatus&&gpsenable){
   locationData  = await location.getLocation();
   print('${locationData?.latitude}');
   print('${locationData?.longitude}');
  streamSubscription = location.onLocationChanged.listen((newlocation) {
     locationData=newlocation;
     print('${locationData?.latitude}');
     print('${locationData?.longitude}');
   updateusermarker();


   });
    }

  }
}
