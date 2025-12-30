import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/post.dart';
import '../../core/error/failure.dart';
import '../models/user_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;
  DashboardRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      final users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return Right(users);
    } catch (e) {
      return Left(NetworkFailure(message: "Failed to load users"));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final posts = (response.data as List)
          .map((e) => Post(id: e['id'], title: e['title'], body: e['body']))
          .toList();
      return Right(posts);
    } catch (e) {
      return Left(NetworkFailure(message: "Failed to load posts"));
    }
  }
}
