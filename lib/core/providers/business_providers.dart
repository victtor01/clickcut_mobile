import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/auth/domain/usecases/auth_business_usecase.dart';
import 'package:clickcut_mobile/features/business/data/datasources/business_remote_datasource.dart';
import 'package:clickcut_mobile/features/business/data/repositories/business_repository_implements.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';
import 'package:clickcut_mobile/features/business/domain/usecases/get_business_history_usecase.dart';
import 'package:clickcut_mobile/features/business/domain/usecases/get_business_usecase.dart';
import 'package:clickcut_mobile/features/initial/domain/usecases/find_statement_usecase.dart';
import 'package:clickcut_mobile/features/initial/presentation/controllers/business_card_controller.dart';
import 'package:clickcut_mobile/features/initial/presentation/controllers/business_dashboards_controller.dart';
import 'package:clickcut_mobile/features/select/apresentation/controllers/entry_pin_controller.dart';
import 'package:clickcut_mobile/features/select/apresentation/controllers/select_business_controller.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> businessProviders(Dio dio) => [
      ...businessRepositories(dio),
      ...busienssUseCaseProviders(),
      ...businessControllerProviders()
    ];

List<SingleChildWidget> businessRepositories(Dio dio) {
  return [
    Provider<BusinessRemoteDataSource>(
        create: (_) => BusinessRemoteDataSource(dio)),
    Provider<BusinessRepository>(
        create: (context) =>
            BusinessRepositoryImpl(context.read<BusinessRemoteDataSource>())),
  ];
}

List<SingleChildWidget> busienssUseCaseProviders() => [
      Provider<GetBusinessesUseCase>(
          create: (context) =>
              GetBusinessesUseCase(context.read<BusinessRepository>())),
      Provider<FindStatementUsecase>(
          create: (context) => FindStatementUsecase(
              businessRepository: context.read<BusinessRepository>())),
      Provider(
          create: (context) =>
              GetBusinessHistoryUsecase(context.read<BusinessRepository>()))
    ];

List<SingleChildWidget> businessControllerProviders() => [
      ChangeNotifierProvider<SelectBusinessController>(
          create: (context) => SelectBusinessController(
              context.read<GetBusinessesUseCase>(),
              context.read<AuthBusinessUseCase>(),
              context.read<SessionService>())),
      ChangeNotifierProvider<PinEntryController>(
          create: (context) =>
              PinEntryController(context.read<AuthBusinessUseCase>())),
      ChangeNotifierProvider(
          create: (context) => InitialController(
              findStatementUsecase: FindStatementUsecase(
                  businessRepository: context.read<BusinessRepository>()))),
      ChangeNotifierProvider(
          create: (context) => BusinessDashboardsController(
              getBusinessHistoryUsecase:
                  context.read<GetBusinessHistoryUsecase>()))
    ];
