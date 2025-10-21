import 'package:clickcut_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    final userMap = await remoteDataSource.login(email, password);

    return userMap["message"];
  }
}
