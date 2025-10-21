import 'package:clickcut_mobile/core/dtos/business_statement.dart';

abstract class StatementRepository {
		Future<BusinessStatement> FindStatement(); 
}