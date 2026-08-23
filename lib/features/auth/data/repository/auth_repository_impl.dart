import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(() async {
      return await remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
    });
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(() async {
      return await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final User user = await fn();

      return Right(user);
    } on sb.AuthException catch (e) {
      return Left(Failure(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
