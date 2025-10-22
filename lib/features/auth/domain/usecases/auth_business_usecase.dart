import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';

class AuthBusinessUseCase {
  final AuthRepository repository;
		final SessionService sessionService;

  AuthBusinessUseCase(this.repository, this.sessionService);

  Future<String> call(String businessId, String password) async {
    final logged = await repository.authBusiness(businessId, password);
  
				if(logged.isNotEmpty) {
					await sessionService.initSessionBusiness();
				}

				return logged;
		}
}
