import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:permission_handler/permission_handler.dart';

import '../generated/l10n.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  
  Set<Marker> _markers = {};

  
  Position? _currentPosition;
  String _currentAddress = '';
  bool _isLoading = false;

  
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomMarker();
      _createInitialMarkers();
      _getCurrentLocation();
    });
  }

  
  Future<void> _loadCustomMarker() async {
    try {
      customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/marker_icon.png',
      );
    } catch (error) {
      
      customMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }

    
    _createInitialMarkers();
  }

  
  void _createInitialMarkers() {
    
    final locations = [
      {'id': '1', 'title': 'San Francisco', 'position': const LatLng(37.7749, -122.4194)},
      {'id': '2', 'title': 'Golden Gate Bridge', 'position': const LatLng(37.8199, -122.4783)},
      {'id': '3', 'title': 'Fisherman\'s Wharf', 'position': const LatLng(37.8080, -122.4177)},
    ];

    setState(() {
      _markers = locations.map((location) {
        return Marker(
          markerId: MarkerId(location['id'] as String),
          position: location['position'] as LatLng,
          infoWindow: InfoWindow(
            title: location['title'] as String,
            snippet: S.of(context).more_info,
          ),
          icon: customMarkerIcon,
          onTap: () {
            
            _showLocationInfo(location['title'] as String);
          },
        );
      }).toSet();
    });
  }

  
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(S.of(context).denied_permissions)),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text(S.of(context).permanently_denied_permissions),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;

        
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow:  InfoWindow(
              title: S.of(context).your_location,
              snippet: S.of(context).you_are_here,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      });

      await _goToCurrentLocation();

      await _getAddressFromLatLng(position);

    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${S.of(context).error_getting_location} ${e}")),
        );
      }
    }  finally {
       if (mounted) {
         setState(() => _isLoading = false);
       }
     }
  }

  
  Future<void> _goToCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      CameraPosition newPosition = CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 15,
      );

      await controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    }
  }

  
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            _currentAddress = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
          });
        }
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  
  Future<void> _searchLocation(String address) async {
    setState(() => _isLoading = true);

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;

        
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('search_${DateTime.now().millisecondsSinceEpoch}'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: address,
                snippet: S.of(context).searched_location,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            ),
          );
        });

        
        final GoogleMapController controller = await _controller.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${S.of(context).not_find_location} $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLocationInfo(String locationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locationName),
        content: Text(S.of(context).additional_info),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(S.of(context).close),
          ),
        ],
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (LatLng position) {
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId('tap_${DateTime.now().millisecondsSinceEpoch}'),
                    position: position,
                    infoWindow:  InfoWindow(
                      title: S.of(context).new_location,
                      snippet: 'Added by tapping',
                    ),
                  ),
                );
              });
            },
            onCameraMove: (CameraPosition position) {
              print('Camera moved to: ${position.target}');
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: lottie.Lottie.asset('assets/loading.json'),
                ),
              ),
            ),
          if (_currentAddress.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                   S.of(context).current_address + _currentAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                  onPressed: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black),
                  onPressed: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'search',
                  mini: true,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.search, color: Colors.black),
                  onPressed: showSearchDialog,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () {
          _goToCurrentLocation();
        },
      ),
    );
  }

  void showSearchDialog() {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).search_for_location),
        content: TextField(
          controller: searchController,
          decoration:  InputDecoration(
            hintText: S.of(context).enter_address_to_search,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _searchLocation(value);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                _searchLocation(searchController.text);
                Navigator.pop(context);
              }
            },
            child:  Text(S.of(context).search),
          ),
        ],
      ),
    );
  }
}

class MapState extends ChangeNotifier {
  LatLng? lastSearched;

  Future<void> searchByAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        lastSearched = LatLng(locations[0].latitude, locations[0].longitude);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
  }
}