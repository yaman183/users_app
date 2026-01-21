import 'package:shared_preferences/shared_preferences.dart';

class ActiveStatusStore {
  static const String _prefix = 'user_active_';

  Future<bool?> getStatus(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$userId';
    if (!prefs.containsKey(key)) return null;
    return prefs.getBool(key);
  }

  Future<void> setStatus(int userId, bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$userId', isActive);
  }

 

  Future<void> ensureDefaults({
    required List<int> userIds,
    int defaultActiveCount = 6, // number of active
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final ids = [...userIds]..sort();
    final count = defaultActiveCount.clamp(0, ids.length);

    for (int i = 0; i < ids.length; i++) {
      final id = ids[i];
      final key = '$_prefix$id';

      
      if (prefs.containsKey(key)) continue;

      final isActive = i < count;
      await prefs.setBool(key, isActive);
    }
  }

  Future<Map<int, bool>> getStatuses(List<int> userIds) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <int, bool>{};

    for (final id in userIds) {
      final key = '$_prefix$id';
      map[id] = prefs.getBool(key) ?? false;
    }
    return map;
  }
}
