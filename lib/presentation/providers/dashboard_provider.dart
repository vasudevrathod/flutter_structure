import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/common/api_state.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/dashboard_repository.dart';

// UI State that holds multiple API responses
class DashboardUIState {
  final ApiState<List<User>> userState;
  final ApiState<List<Post>> postState;

  DashboardUIState({required this.userState, required this.postState});

  DashboardUIState copyWith({
    ApiState<List<User>>? userState,
    ApiState<List<Post>>? postState,
  }) {
    return DashboardUIState(
      userState: userState ?? this.userState,
      postState: postState ?? this.postState,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardUIState> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository)
    : super(
        DashboardUIState(
          userState: ApiState.initial(),
          postState: ApiState.initial(),
        ),
      );

  Future<void> fetchAllData() async {
    // 1. Set both to loading
    state = state.copyWith(
      userState: ApiState.loading(),
      postState: ApiState.loading(),
    );

    // 2. Run API calls concurrently
    final results = await Future.wait([
      _repository.getUsers(),
      _repository.getPosts(),
    ]);

    final userRes = results[0] as dynamic; // Either<Failure, List<User>>
    final postRes = results[1] as dynamic; // Either<Failure, List<Post>>

    // 3. Update state based on results
    userRes.fold(
      (failure) =>
          state = state.copyWith(userState: ApiState.failure(failure.message)),
      (users) => state = state.copyWith(userState: ApiState.success(users)),
    );

    postRes.fold(
      (failure) =>
          state = state.copyWith(postState: ApiState.failure(failure.message)),
      (posts) => state = state.copyWith(postState: ApiState.success(posts)),
    );
  }
}

// Dependency Injection Providers
final dioProvider = Provider((ref) => DioClient().getDio());

final dashboardRepoProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(dioProvider));
});

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardUIState>((ref) {
      return DashboardNotifier(ref.watch(dashboardRepoProvider));
    });
