import 'package:mongo_dart/mongo_dart.dart';
import '../config/env_config.dart';

class MongoDBService {
  Future<Map<String, dynamic>?> fetchLatestLocation(
      String dbName, String collectionName) async {
    Db? db;
    
    try {
      // Get MongoDB connection string
      final mongoUri = EnvConfig.getMongoUri();
      
      // Connect to MongoDB
      db = await Db.create(mongoUri);
      await db.open();
      
      // Access the specified database and collection
      final collection = db.collection(collectionName);
      
      // Query the latest record
      final result = await collection
          .find()
          .sort({'timestamp': -1})
          .limit(1)
          .toList();
      
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      rethrow;
    } finally {
      // Ensure database connection is closed
      if (db != null && db.isConnected) {
        await db.close();
      }
    }
  }
}
