import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/features/business/data/datasources/business_remote_datasource.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;

  BusinessRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Business>> getBusinesses() async {
    return await remoteDataSource.getBusinesses();
  }

  @override
  Future<BusinessStatement> getStatements() async {
    return await remoteDataSource.getStatements();
  }
}
