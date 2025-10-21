import 'package:clickcut_mobile/features/business/domain/entities/business.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class PinEntryScreen extends StatefulWidget {
  final Business business;
  const PinEntryScreen({super.key, required this.business});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = '';

  void _onPinVerify(String pin) {
    context.go('/home');

    setState(() {
      _pin = '';
    });
  }

  void _onCancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
			final colorsScheme = Theme.of(context).colorScheme;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,																
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: colorsScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF18181b) // zinc-900
          : const Color(0xFFf4f4f5), // gray-100
      body: SafeArea(
								child: Stack(
										children: [
												Positioned(
														top: 10,
														right: 10,
														child: Material(
																color: Theme.of(context).brightness == Brightness.dark
																				? const Color(0xFF27272a) // zinc-800
																				: Colors.white,
																borderRadius: BorderRadius.circular(24),
																child: InkWell(
																		borderRadius: BorderRadius.circular(24),
																		onTap: _onCancel,
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
																				backgroundImage: widget.business.logoUrl != null
																								? NetworkImage(widget.business.logoUrl!)
																								: null,
																				child: widget.business.logoUrl == null
																								? const Icon(Icons.business, size: 40)
																								: null,
																		),
																		const SizedBox(height: 16),
																		Text(
																				'Bem-vindo, ${widget.business.name}',
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
																				// Chama _onPinVerify automaticamente quando 4 dígitos são inseridos
																				onCompleted: (pin) => _onPinVerify(pin),
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
