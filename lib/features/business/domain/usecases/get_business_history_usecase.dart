// /summary/bookings/history

import 'package:clickcut_mobile/core/dtos/responses/booking_history.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';

class GetBusinessHistoryUsecase {
  final BusinessRepository repository;

  GetBusinessHistoryUsecase(this.repository);

  Future<BookingHistoryResponse> call() async {
    return await repository.getBusinessBookingsHistory();
  }
}