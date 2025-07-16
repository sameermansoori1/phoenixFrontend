import 'package:phoenix_app/features/auth/domain/entities/auth_token.dart';
import 'package:phoenix_app/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthToken> login(
      {required String email, required String password}) async {
    final response = await remoteDataSource.login(
      LoginRequestModel(email: email, password: password),
    );
    return AuthToken(token: response.token);
  }
}
