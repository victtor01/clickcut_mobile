import 'package:clickcut_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:clickcut_mobile/features/auth/data/repositories/auth_repository_implements.dart';
import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/auth/domain/usecases/auth_business_usecase.dart';
import 'package:clickcut_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:clickcut_mobile/features/auth/presentasion/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> authProviders(Dio dio) => [
      ...repositories(dio),
      ...authUseCases(),
      ...controllers(),
    ];

List<SingleChildWidget> repositories(Dio dio) => [
      Provider<AuthRemoteDataSource>(
        create: (_) => AuthRemoteDataSource(dio),
      ),
      Provider<AuthRepository>(
        create: (context) =>
            AuthRepositoryImpl(context.read<AuthRemoteDataSource>()),
      ),
    ];

List<SingleChildWidget> authUseCases() => [
      Provider<LoginUseCase>(
        create: (context) => LoginUseCase(context.read<AuthRepository>()),
      ),
      Provider<AuthBusinessUseCase>(
        create: (context) =>
            AuthBusinessUseCase(context.read<AuthRepository>(), context.read<SessionService>()),
      ),
    ];

List<SingleChildWidget> controllers() => [
      ChangeNotifierProvider<LoginController>(
        create: (context) => LoginController(context.read<LoginUseCase>()),
      ),
    ];
