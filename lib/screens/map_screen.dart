import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/location_data.dart';
import '../services/mongodb_service.dart';
import '../services/geocoding_service.dart';
import '../utils/timestamp_formatter.dart';
import '../widgets/info_header.dart';

class MapScreen extends StatefulWidget {
  final String groupName;
  final String userName;

  const MapScreen({
    Key? key,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  LocationData? locationData;
  final mapController = MapController();
  final MongoDBService _mongoService = MongoDBService();
  final GeocodingService _geocodingService = GeocodingService();

  @override
  void initState() {
    super.initState();
    fetchLatestLocationData();
  }

  Future<void> fetchLatestLocationData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // Fetch data from MongoDB
      final result = await _mongoService.fetchLatestLocation(
        widget.groupName,
        widget.userName,
      );

      if (result == null) {
        throw Exception('No data found for the specified user and group');
      }

      // Convert map to LocationData object
      locationData = LocationData.fromMap(result);

      // Get the address from coordinates
      locationData!.address = await _geocodingService.getAddressFromCoordinates(
        locationData!.latitude, 
        locationData!.longitude
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
      ),
      body: Column(
        children: [
          InfoHeader(
            groupName: widget.groupName,
            userName: widget.userName,
            address: locationData?.address ?? 'Address unavailable',
            timestamp: locationData?.timestamp,
            onRefresh: fetchLatestLocationData,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: $errorMessage',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : locationData != null
                        ? FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: LatLng(
                                locationData!.latitude,
                                locationData!.longitude,
                              ),
                              zoom: 15.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(
                                      locationData!.latitude,
                                      locationData!.longitude,
                                    ),
                                    builder: (ctx) => const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const Center(
                            child: Text('No location data available'),
                          ),
          ),
        ],
      ),
    );
  }
}
