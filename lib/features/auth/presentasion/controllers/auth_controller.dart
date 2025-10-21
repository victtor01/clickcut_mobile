import 'package:clickcut_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      await _loginUseCase(email, password);
      _isLoading = false;
      notifyListeners();
      return true; 

    } catch (e) {
      
						_error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }
}