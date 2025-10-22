abstract class AuthRepository {
  Future<String> login(String email, String password);
		Future<String> authBusiness(String businessId, String? password);
}
