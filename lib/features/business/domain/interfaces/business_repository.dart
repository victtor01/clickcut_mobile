import 'package:clickcut_mobile/features/business/domain/entities/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinesses();
}