import 'package:clickcut_mobile/core/providers/auth_providers.dart';
import 'package:clickcut_mobile/core/providers/business_providers.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/auth/presentasion/screens/login_page.dart';
import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:clickcut_mobile/features/select/apresentation/screens/pin_entry_screen.dart';
import 'package:clickcut_mobile/features/select/apresentation/screens/select_screen.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

  final sessionService = SessionService(dio: dio);
  await sessionService.initSession();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          Provider<Dio>.value(value: dio),
          Provider<SessionService>.value(value: sessionService),
          ...authProviders(dio),
          ...businessProviders(dio),
        ],
        child: const MyApp(),
      ),
    );
  });
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final List<String> publicRoutes = [
  '/login',
  '/register',
  '/forgot-password',
];

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) {
    final session = context.read<SessionService>();
    final isPublic = publicRoutes.contains(state.uri.toString());

    if (!session.isUserLogged && !isPublic) {
      return '/login';
    }

    if (session.isUserLogged && session.hasBusinessSession) {
      if (isPublic) return '/home'; // impede ir pro login novamente
      return null; // pode acessar normalmente
    }

    if (session.isUserLogged && !session.hasBusinessSession) {
      if (state.uri.toString() == '/select' ||
          state.uri.toString().startsWith('/select/pin')) {
        return null; // deixa passar
      }
      return '/select'; // força escolher empresa
    }

    return null;
  },
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
      builder: (context, state) => const SelectScreen(),
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
        onPrimary: Colors.white,
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
