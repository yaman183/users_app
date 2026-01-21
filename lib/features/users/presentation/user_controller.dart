import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:users_app/core/storage/active_status.dart';
import '../data/users_api_service.dart';
import '../data/user_model.dart';


enum UsersFilter { all, active, inactive }

class UsersState {
  final List<UserModel> users;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final int page;
  final int totalPages;

  final String query;
  final UsersFilter filter;

  final Set<int> activeIds;

  const UsersState({
    this.users = const [],
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.query = '',
    this.filter = UsersFilter.all,
    this.activeIds = const <int>{},
  });

  UsersState copyWith({
    List<UserModel>? users,
    bool? loading,
    bool? loadingMore,
    String? error,
    int? page,
    int? totalPages,
    String? query,
    UsersFilter? filter,
    Set<int>? activeIds,
  }) {
    return UsersState(
      users: users ?? this.users,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      activeIds: activeIds ?? this.activeIds,
    );
  }
}

final usersApiProvider = Provider((ref) => UsersApiService());
final activeStatusStorageProvider = Provider((ref) => ActiveStatusStorage());

final usersControllerProvider =
    StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController(
    ref.read(usersApiProvider),
    ref.read(activeStatusStorageProvider),
  );
});

class UsersController extends StateNotifier<UsersState> {
  final UsersApiService api;
  final ActiveStatusStorage storage;

  static const int perPage = 10;

  UsersController(this.api, this.storage) : super(const UsersState()) {
    loadInitial();
  }

  bool isActive(UserModel u) => state.activeIds.contains(u.id);

  
  bool _defaultActiveRule(UserModel u) => (u.id % 2 == 0);

  Future<void> _ensureActiveIdsForUsers(List<UserModel> users) async {
    final stored = await storage.getActiveIds();
    final updated = {...stored};

    
    for (final u in users) {
      if (!updated.contains(u.id)) {
        if (_defaultActiveRule(u)) {
          updated.add(u.id);
        }
      }
    }

    
    await storage.saveActiveIds(updated);
    state = state.copyWith(activeIds: updated);
  }

  Future<void> loadInitial() async {
    state = state.copyWith(
      loading: true,
      error: null,
      page: 1,
      users: [],
    );

    try {
      
      final stored = await storage.getActiveIds();
      state = state.copyWith(activeIds: stored);

      final res = await api.fetchUsers(page: 1, perPage: perPage);

      await _ensureActiveIdsForUsers(res.users);

      state = state.copyWith(
        loading: false,
        users: res.users,
        page: res.page,
        totalPages: res.totalPages,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore) return;
    if (state.page >= state.totalPages) return;

    state = state.copyWith(loadingMore: true, error: null);

    try {
      final next = state.page + 1;
      final res = await api.fetchUsers(page: next, perPage: perPage);

      
      await _ensureActiveIdsForUsers(res.users);

      final merged = [...state.users, ...res.users];

      state = state.copyWith(
        loadingMore: false,
        users: merged,
        page: res.page,
        totalPages: res.totalPages,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e.toString());
    }
  }

  void setQuery(String q) {
    state = state.copyWith(query: q);
  }

  void setFilter(UsersFilter f) {
    state = state.copyWith(filter: f);
  }

  Future<void> refresh() async {
    await loadInitial();
  }
}


