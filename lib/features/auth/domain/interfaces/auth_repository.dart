import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
}
