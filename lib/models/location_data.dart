class LocationData {
  final double latitude;
  final double longitude;
  final dynamic timestamp;
  String address;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.address = 'Loading address...',
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      timestamp: map['timestamp'],
    );
  }

  static LocationData? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null || !map.containsKey('latitude') || !map.containsKey('longitude')) {
      return null;
    }
    return LocationData.fromMap(map);
  }
}
