import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:dio/dio.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';

class BusinessRemoteDataSource {
  final Dio _dio;

  BusinessRemoteDataSource(this._dio);

  Future<List<Business>> getBusinesses() async {
    try {
      final response = await _dio.get('/business/all');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data.map((json) => Business.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load businesses');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load businesses: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }

  Future<BusinessStatement> getStatements() async {
    try {
      final response = await _dio.get('/business/statement');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return BusinessStatement.fromJson(data);
      } else {
        throw Exception('Failed to load business statement');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load business statement: ${e.message}');
    }
  }
}
