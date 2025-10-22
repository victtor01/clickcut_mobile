import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class SessionService {
  User? _user;
  Business? _business;

  bool get isUserLogged => _user != null;
  bool get hasBusinessSession => _business != null;

  User? get user => _user;
  Business? get business => _business;

  final Dio dio;

  SessionService({required this.dio});

  Future<void> initSessionUser() async {
    try {
      final userResponse = await dio.get('/users/summary');
      _user = User.fromJson(userResponse.data);
    } catch (_) {
      _user = null;
    }
  }

  Future<void> initSessionBusiness() async {
    if (!isUserLogged) return;

    try {
      final businessResponse = await dio.get('/auth/business');
      _business = Business.fromJson(businessResponse.data);
    } catch (_) {
      _business = null;
    }
  }

  Future<void> initSession() async {
    await initSessionUser();
    await initSessionBusiness();
  }

 Future<void> logout() async {
    _user = null;

    if (dio.interceptors.any((i) => i is CookieManager)) {
      final cookieManager = dio.interceptors.firstWhere((i) => i is CookieManager) as CookieManager;
      await cookieManager.cookieJar.deleteAll();
    }
  }

  void clearSession() {
    _user = null;
    _business = null;
  }
}
