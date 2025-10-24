import 'package:clickcut_mobile/core/dtos/responses/booking_history.dart';
import 'package:clickcut_mobile/core/dtos/responses/business_statement.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinesses();
		Future<BusinessStatement> getStatements();
		Future<BookingHistoryResponse> getBusinessBookingsHistory();
}