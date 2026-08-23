import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecase/user_login.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//// Initialize GetIt
final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  //// Register Supabase Client
  final Supabase supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  //// Register Auth Dependencies
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  //// Register Auth Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  //// Register Sign Up Use Cases
  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(serviceLocator()),
  );

  //// Register Login Use Cases
  serviceLocator.registerFactory<UserLogin>(() => UserLogin(serviceLocator()));

  //// Register Auth Bloc
  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator()),
  );
}
