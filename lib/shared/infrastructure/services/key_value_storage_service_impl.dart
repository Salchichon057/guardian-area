import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  
  Future getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case const (int):
        return prefs.getInt(key) as T?;
      case const (double):
        return prefs.getDouble(key) as T?;
      case const (String):
        return prefs.getString(key) as T?;
      case const (bool):
        return prefs.getBool(key) as T?;
      case const (List):
        return prefs.getStringList(key) as T?;
      default:
        throw UnimplementedError('Get not implemented for type $T');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case const (int):
        await prefs.setInt(key, value as int);
        break;
      case const (double):
        await prefs.setDouble(key, value as double);
        break;
      case const (String):
        await prefs.setString(key, value as String);
        break;
      case const (bool):
        await prefs.setBool(key, value as bool);
        break;
      case const (List):
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw UnimplementedError('Set not implemented for type $T');
    }

  }

}