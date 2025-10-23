import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/features/initial/domain/usecases/find_statement_usecase.dart';
import 'package:flutter/material.dart';

class InitialController extends ChangeNotifier {
  InitialController({required this.findStatementUsecase});

  String? _error;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

  FindStatementUsecase findStatementUsecase;

  BusinessStatement? statement;

  Future<BusinessStatement?> getStatements() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final statement = await findStatementUsecase();

      _isLoading = false;

      notifyListeners();

      this.statement = statement;
						
      return statement;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      notifyListeners();
    }
    return null;
  }
}
