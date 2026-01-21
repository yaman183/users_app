import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:users_app/features/users/presentation/widgets/filter_widget.dart';
import 'user_controller.dart';
import 'user_details_screen.dart';
import 'widgets/error_view_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/user_list_item.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      final notifier = ref.read(usersControllerProvider.notifier);
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 220) {
        notifier.loadMore();
      }
    });

    _searchCtrl.addListener(() {
      ref.read(usersControllerProvider.notifier).setQuery(_searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersControllerProvider);
    final controller = ref.read(usersControllerProvider.notifier);

    //  Search filter
    final q = state.query.trim().toLowerCase();
    var list = q.isEmpty
        ? state.users
        : state.users.where((u) {
            final name = u.fullName.toLowerCase();
            final email = u.email.toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();

    // Status filter
    if (state.filter == UsersFilter.active) {
      list = list.where((u) => controller.isActive(u)).toList();
    } else if (state.filter == UsersFilter.inactive) {
      list = list.where((u) => !controller.isActive(u)).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF2F4F8),
        title: const Text(
          'Users',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F4F8), Color(0xFFF7F8FC)],
          ),
        ),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchCtrl,
              hintText: 'Search by name, email...',
            ),

            FilterWidget(
              selected: state.filter,
              onChanged: (f) => controller.setFilter(f),
            ),

            Expanded(
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : (state.error != null && state.users.isEmpty)
                  ? ErrorView(
                      message: state.error!,
                      onRetry: () => ref
                          .read(usersControllerProvider.notifier)
                          .loadInitial(),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(usersControllerProvider.notifier).refresh(),
                      child: list.isEmpty
                          ? const Center(child: Text('No users found.'))
                          : ListView.builder(
                              controller: _scroll,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: list.length + 1,
                              itemBuilder: (context, index) {
                                if (index == list.length) {
                                  return state.loadingMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const SizedBox(height: 20);
                                }

                                final user = list[index];
                                final active = controller.isActive(user);

                                return UserListItem(
                                  user: user,
                                  isActive: active,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            UserDetailsScreen(user: user),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
