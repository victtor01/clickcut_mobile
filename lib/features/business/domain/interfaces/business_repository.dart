import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinesses();
		Future<BusinessStatement> getStatements();
}