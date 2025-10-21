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
							print(data);
        return data.map((json) => Business.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load businesses');
      }
    } on DioException catch (e) {
      print('DioError fetching businesses: $e');
      throw Exception('Failed to load businesses: ${e.message}');
    } catch (e) {
      print('Error fetching businesses: $e');
      throw Exception('An unknown error occurred');
    }
  }
}