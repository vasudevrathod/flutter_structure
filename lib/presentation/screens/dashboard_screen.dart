import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_structure/config/env_config.dart';
import 'package:flutter_structure/l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    Future.microtask(() => ref.read(dashboardProvider.notifier).fetchAllData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)!.helloWorld} ${EnvConfig.apiUrl}",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).fetchAllData(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Users List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildUserList(state),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Posts List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildPostList(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(DashboardUIState state) {
    if (state.userState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.userState.isFailure) {
      return Center(child: Text(state.userState.errorMessage!));
    }

    final users = state.userState.data ?? [];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, i) => Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: Text(users[i].name)),
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(DashboardUIState state) {
    if (state.postState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.postState.isFailure) {
      return Center(child: Text(state.postState.errorMessage!));
    }

    final posts = state.postState.data ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(posts[i].title),
        subtitle: Text(posts[i].body, maxLines: 1),
      ),
    );
  }
}
