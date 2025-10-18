import 'package:clickcut_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:clickcut_mobile/features/auth/data/repositories/auth_repository_implementes.dart';
import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';
import 'package:clickcut_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:clickcut_mobile/features/auth/presentasion/controllers/auth_controller.dart';
import 'package:clickcut_mobile/features/auth/presentasion/screens/login_page.dart';
import 'package:clickcut_mobile/features/home/presentation/screens/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  final baseOptions = BaseOptions(
    baseUrl:
        'http://10.220.0.8:5055/api', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  WidgetsFlutterBinding.ensureInitialized();

		await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          Provider<Dio>(
            create: (_) => Dio(baseOptions),
          ),
          Provider<AuthRemoteDataSource>(
            create: (context) => AuthRemoteDataSource(context.read<Dio>()),
          ),
          Provider<AuthRepository>(
            create: (context) =>
                AuthRepositoryImpl(context.read<AuthRemoteDataSource>()),
          ),
          Provider<LoginUseCase>(
            create: (context) => LoginUseCase(context.read<AuthRepository>()),
          ),
          ChangeNotifierProvider<LoginController>(
            create: (context) => LoginController(context.read<LoginUseCase>()),
          ),
        ],
        child: const MyApp(), // O seu App é o filho do MultiProvider
      ),
    );
  });
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

				  GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );

    return MaterialApp.router(
      title: 'ClickCut App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: _router,
    );
  }
}
