import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth', 
        data: {'email': email, 'password': password},
      );

      return response.data; 
    } on DioException catch (e) {
      throw Exception('Falha no login: ${e.message}');
    }
  }
}
