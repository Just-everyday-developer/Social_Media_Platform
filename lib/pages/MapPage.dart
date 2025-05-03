import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Google Maps Controller
  final Completer<GoogleMapController> _controller = Completer();

  // Default camera position (San Francisco)
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  // Set of markers
  Set<Marker> _markers = {};

  // Location data
  Position? _currentPosition;
  String _currentAddress = '';
  bool _isLoading = false;

  // Custom marker icons
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _createInitialMarkers();
    _getCurrentLocation();
  }

  // Task 2: Creating custom marker icon
  Future<void> _loadCustomMarker() async {
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/marker_icon.png',
    ).catchError((error) {
      // Fallback to default marker if custom one fails to load
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    });

    // Update markers with new icon
    _createInitialMarkers();
  }

  // Task 2: Create predefined markers
  void _createInitialMarkers() {
    // Creating predefined locations
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
            snippet: 'Tap for more info',
          ),
          icon: customMarkerIcon,
          onTap: () {
            // Handle marker tap
            _showLocationInfo(location['title'] as String);
          },
        );
      }).toSet();
    });
  }

  // Task 3: Implement location services
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    // 1. Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied, please enable them in settings'),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    // 2. Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;

        // Add current location marker
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'You are here',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      });

      // 3. Update camera position to user's location
      _goToCurrentLocation();

      // 4. Get address from coordinates (Task 5: Geocoding)
      _getAddressFromLatLng(position);
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  // Task 4: Move camera to current location
  Future<void> _goToCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _controller.future;
      CameraPosition newPosition = CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 15,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    }
  }

  // Task 5: Geocoding - Get address from coordinates
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Task 5: Geocoding - Search for a location by address
  Future<void> _searchLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;

        // Add marker for the searched location
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('search_${DateTime.now().millisecondsSinceEpoch}'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: address,
                snippet: 'Searched location',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            ),
          );
        });

        // Move camera to the searched location
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not find location: $e')),
      );
    }
  }

  void _showLocationInfo(String locationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locationName),
        content: const Text('This is additional information about this location.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Task 2: Display Google Map with Markers
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            // Task 4: Enable Map Gestures
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // Handle map interactions
            onTap: (LatLng position) {
              // Add new marker on tap
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId('tap_${DateTime.now().millisecondsSinceEpoch}'),
                    position: position,
                    infoWindow: const InfoWindow(
                      title: 'New Location',
                      snippet: 'Added by tapping',
                    ),
                  ),
                );
              });
            },
            onCameraMove: (CameraPosition position) {
              // You can track camera movement here
              print('Camera moved to: ${position.target}');
            },
          ),

          // Show loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Display current address
          if (_currentAddress.isNotEmpty)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Current Address: $_currentAddress',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Task 4: Map Control Buttons
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  child: const Icon(Icons.remove),
                  onPressed: () async {
                    final controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: _goToCurrentLocation,
      ),
    );
  }

  void showSearchDialog() {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Location'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Enter address to search',
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                _searchLocation(searchController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Search'),
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