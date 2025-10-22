import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/auth/presentasion/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    FocusScope.of(context).unfocus();

    final controller = context.read<LoginController>();
    final service = Provider.of<SessionService>(context, listen: false);

    final success = await controller.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.indigoAccent,
          content: Text(
            'Login realizado com sucesso!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

						await service.initSessionUser();

      context.go('/select');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text('Email ou senha incorretos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();

    final Color pageBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final Brightness iconBrightness =
        ThemeData.estimateBrightnessForColor(pageBackgroundColor) ==
                Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: pageBackgroundColor,
        systemNavigationBarIconBrightness: iconBrightness,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Bem-vindo ao ClickCut',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Faça login para continuar',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 48),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 40),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 40),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: controller.isLoading ? null : _doLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      footer(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget footer(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              print('Esqueceu a senha?');
            },
            child: const Text('Esqueceu a senha?'),
          ),
        ),
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Não tem uma conta?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () {
                print('Crie uma aqui');
              },
              child: const Text('Crie uma aqui'),
            ),
          ],
        ),
      ],
    );
  }
}
