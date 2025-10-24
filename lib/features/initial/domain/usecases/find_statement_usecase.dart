import 'package:clickcut_mobile/core/dtos/responses/business_statement.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';

class FindStatementUsecase {
  final BusinessRepository businessRepository;

  FindStatementUsecase({required this.businessRepository});

  Future<BusinessStatement> call() async {
    return await businessRepository.getStatements();
  }
}
