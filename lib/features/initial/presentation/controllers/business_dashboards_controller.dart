import 'package:clickcut_mobile/core/dtos/responses/booking_history.dart';
import 'package:clickcut_mobile/core/dtos/responses/business_statement.dart';
import 'package:clickcut_mobile/features/business/domain/usecases/get_business_history_usecase.dart';
import 'package:flutter/material.dart';

class BusinessDashboardsController extends ChangeNotifier {
  final GetBusinessHistoryUsecase getBusinessHistoryUsecase;

  BusinessDashboardsController({required this.getBusinessHistoryUsecase});

  String? _error;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

		BookingHistoryResponse? businessHistory;

  Future<BookingHistoryResponse?> getStatements() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final statement = await getBusinessHistoryUsecase();

      _isLoading = false;

      notifyListeners();

      businessHistory = statement;

      return businessHistory;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      notifyListeners();
    }
    return null;
  }
}
