import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/business/domain/usecases/get_business_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SelectBusinessState { idle, loading, success, error }

class SelectBusinessController extends ChangeNotifier {
  final GetBusinessesUseCase _getBusinessesUseCase;

  SelectBusinessController(this._getBusinessesUseCase);

  SelectBusinessState _state = SelectBusinessState.idle;
  SelectBusinessState get state => _state;

  List<Business> _businesses = [];
  List<Business> get businesses => _businesses;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBusinesses() async {
    _state = SelectBusinessState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _businesses = await _getBusinessesUseCase();
      _state = SelectBusinessState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = SelectBusinessState.error;
    }
    notifyListeners();
  }

  void selectBusiness(BuildContext context, Business business) {
    if (business.hasPassword) {
      context.go('/select/pin', extra: business);
    } else {
      print('Business ${business.name} selecionado, indo para /home');
      context.go('/home');
    }
  }
}