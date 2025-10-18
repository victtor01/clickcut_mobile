import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
