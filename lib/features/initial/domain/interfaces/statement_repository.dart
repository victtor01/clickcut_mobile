import 'package:clickcut_mobile/core/dtos/responses/business_statement.dart';

abstract class StatementRepository {
		Future<BusinessStatement> FindStatement(); 
}