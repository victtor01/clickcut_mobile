import 'package:clickcut_mobile/features/auth/domain/usecases/auth_business_usecase.dart';
import 'package:flutter/material.dart';

class PinEntryController extends ChangeNotifier {
  final AuthBusinessUseCase _verifyPinUseCase;

  PinEntryController(this._verifyPinUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyPin(String businessId, String pin) async {
    _isLoading = true;
    _errorMessage = null;
				
    notifyListeners();

    try {
      final String result = await _verifyPinUseCase.call(businessId, pin);

      if (result.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
