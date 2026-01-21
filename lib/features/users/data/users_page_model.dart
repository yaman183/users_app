import 'user_model.dart';

class UsersPageModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserModel> users;

  UsersPageModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });

  factory UsersPageModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? []);
    return UsersPageModel(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 1,
      users: dataList
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
