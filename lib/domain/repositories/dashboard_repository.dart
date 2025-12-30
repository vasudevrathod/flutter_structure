import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../entities/post.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, List<Post>>> getPosts();
}
