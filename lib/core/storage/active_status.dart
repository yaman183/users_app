import 'package:shared_preferences/shared_preferences.dart';

class ActiveStatusStorage {
  static const _key = 'active_user_ids';

  Future<Set<int>> getActiveIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    return list.map(int.parse).toSet();
  }

  Future<void> saveActiveIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final list = ids.map((e) => e.toString()).toList();
    await prefs.setStringList(_key, list);
  }
}
