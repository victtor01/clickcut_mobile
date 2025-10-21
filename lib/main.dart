import 'package:clickcut_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:clickcut_mobile/features/auth/data/repositories/auth_repository_implements.dart';
import 'package:clickcut_mobile/features/auth/domain/interfaces/auth_repository.dart';
import 'package:clickcut_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:clickcut_mobile/features/auth/presentasion/controllers/auth_controller.dart';
import 'package:clickcut_mobile/features/auth/presentasion/screens/login_page.dart';
import 'package:clickcut_mobile/features/business/data/datasources/business_remote_datasource.dart';
import 'package:clickcut_mobile/features/business/data/repositories/business_repository_implements.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/business/domain/interfaces/business_repository.dart';
import 'package:clickcut_mobile/features/business/domain/usecases/get_business_usecase.dart';
import 'package:clickcut_mobile/features/home/presentation/screens/home_page.dart';
import 'package:clickcut_mobile/features/select/apresentation/controllers/select_business_controller.dart';
import 'package:clickcut_mobile/features/select/apresentation/screens/pin_entry_screen.dart';
import 'package:clickcut_mobile/features/select/apresentation/screens/select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appDocDir = await getApplicationDocumentsDirectory();

  final cookieJar = PersistCookieJar(
    storage: FileStorage('${appDocDir.path}/cookies'),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.220.0.8:5055/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  dio.interceptors.add(CookieManager(cookieJar));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          Provider<Dio>.value(value: dio),
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

          //business
          Provider<BusinessRemoteDataSource>(
            create: (context) => BusinessRemoteDataSource(context.read<Dio>()),
          ),
          Provider<BusinessRepository>(
            create: (context) => BusinessRepositoryImpl(
                context.read<BusinessRemoteDataSource>()),
          ),
          Provider<GetBusinessesUseCase>(
            create: (context) =>
                GetBusinessesUseCase(context.read<BusinessRepository>()),
          ),
          ChangeNotifierProvider<SelectBusinessController>(
            create: (context) =>
                SelectBusinessController(context.read<GetBusinessesUseCase>()),
          ),
        ],
        child: const MyApp(),
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
    GoRoute(
      path: '/select',
      builder: (context, state) => const SelectScreen(), // Corrigido
      routes: [
        GoRoute(
          path: 'pin',
          builder: (context, state) {
            final business = state.extra as Business;
            return PinEntryScreen(business: business);
          },
        ),
      ],
    )
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
      ).copyWith(
          primary: Colors.indigoAccent[400],
          secondary: Colors.indigoAccent[200]),
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
