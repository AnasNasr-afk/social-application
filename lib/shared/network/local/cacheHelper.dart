import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  // Ensure sharedPreferences is initialized
  static Future<SharedPreferences> getSharedPreferences() async {
    if (sharedPreferences != null) {
      return sharedPreferences!;
    } else {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences!;
    }
  }

  // Save data to SharedPreferences
  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    SharedPreferences sharedPreferences = await getSharedPreferences();
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    return null;
  }

  static dynamic getData({
    required String key,
}){
    return sharedPreferences?.get(key);
  }

  static Future<bool?> removeData({
    required String key,
})
async
{
    return await sharedPreferences?.remove(key);
}
}

