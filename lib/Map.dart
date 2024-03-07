import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logistics/calculations.dart';
import 'package:logistics/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position currentPosition;
  late GoogleMapController _controller;
  var geoLocator = Geolocator();
  double bottomPaddingofMap = 0;
  Set<Marker> _markers = {};
  final TextEditingController URLController = TextEditingController();


  void locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show dialog or enable them programmatically
      return;
    } else {
      // Location services are enabled, attempt to locate position immediately
      try {
        // Check location permissions
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, request permission
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are still denied, show explanation dialog or handle it accordingly
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are permanently denied, show settings dialog
          await showSettingsDialog();
          return;
        }
        if (permission == LocationPermission.whileInUse) {
          // Get current position
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          currentPosition = position;

          LatLng latLngPosition = LatLng(position.latitude, position.longitude);
          CameraPosition cameraPosition = CameraPosition(
              target: latLngPosition, zoom: 14);
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(cameraPosition));

          // Add a marker for the current position
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('current_position'),
                position: latLngPosition,
                infoWindow: const InfoWindow(
                  title: 'Your Location ',
                  snippet: 'Please move to Google map to send your location',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed), // Customize marker icon if needed
              ),
            );
          });
        }
      } catch (e) {
        // Handle errors, such as no GPS signal or other location-related issues
        print('Error getting current position: $e');
      }
    }
  }

  Future<void> showSettingsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text(
              'Location permission is required to use this app. Please grant the permission in the app settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings(); // Open app settings
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop( context,
              MaterialPageRoute(
                  builder: (context) => CalculationPage()),
            ); // Navigate back to the previous page
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controllerGoogleMap.complete(controller);
              locatePosition();
              setState(() {
                bottomPaddingofMap = 100;
              });
            },
            markers: Set<Marker>.of(_markers),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomPaddingofMap +150,
            // Adjust the value as needed for spacing
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Column(
                children: [
                  TextFormField(
                    controller: URLController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Press on marker put your URL here',
                      prefixIcon:
                      Icon(Icons.account_box, color: Colors.orange),
                      labelStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );//TODO
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      "Make Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}