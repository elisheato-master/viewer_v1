import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String getMongoUri() {
    final mongoUri = dotenv.env['MONGO_URI'] ?? '';
    if (mongoUri.isEmpty) {
      throw Exception('MongoDB URI not found in environment variables');
    }
    return mongoUri;
  }
}
