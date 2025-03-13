import 'package:geocoding/geocoding.dart';

class GeocodingService {
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }
      return 'Address not found';
    } catch (e) {
      return 'Address lookup failed';
    }
  }
}
