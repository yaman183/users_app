import 'dart:convert';
import 'package:flutter/services.dart';
import 'users_page_model.dart';

class MockUsersLoader {
  Future<UsersPageModel> loadPage(int page) async {
    final path = 'assets/mock/users_page_$page.json';

    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    return UsersPageModel.fromJson(jsonMap);
  }
}
