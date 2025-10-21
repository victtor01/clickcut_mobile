import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';

class GetBusinessesUseCase {
  final BusinessRepository repository;

  GetBusinessesUseCase(this.repository);

  Future<List<Business>> call() async {
    return await repository.getBusinesses();
  }
}