import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:clickcut_mobile/features/select/apresentation/controllers/entry_pin_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PinEntryScreen extends StatelessWidget {
  final Business business;
  const PinEntryScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PinEntryController>();
    final colorsScheme = Theme.of(context).colorScheme;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22,
        color: colorsScheme.onPrimary,
      ),
      decoration: BoxDecoration(
        color: colorsScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colorsScheme.primary),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );

    Future<void> onPinVerify(String pin) async {
      final isValid = await controller.verifyPin(business.id, pin);

      if (isValid) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage ?? 'PIN inválido')),
        );
      }
    }

    void onCancel() => context.pop();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF18181b)
          : const Color(0xFFf4f4f5),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF27272a)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onCancel,
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: business.logoUrl != null
                        ? NetworkImage(business.logoUrl!)
                        : null,
                    child: business.logoUrl == null
                        ? const Icon(Icons.business, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bem-vindo, ${business.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Insira o PIN para continuar',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Pinput(
                    length: 4,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                    onCompleted: onPinVerify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
