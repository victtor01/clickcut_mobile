import 'package:clickcut_mobile/core/dtos/responses/business_statement.dart';
import 'package:clickcut_mobile/core/dtos/responses/business_statement_count.dart';
import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/initial/presentation/controllers/business_card_controller.dart';
import 'package:clickcut_mobile/features/initial/presentation/screens/components/business_card/business_card.dart';
import 'package:clickcut_mobile/features/initial/presentation/screens/components/dashboards/business_dashboards.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<InitialController>().getStatements();
      }
    });
  }

  final business = BusinessStatement(
    name: "ClickCut",
    revenue: 400.0,
    revenueGoal: 1000.0,
    userSession: User(email: "josevictor.ar@gmail.com", username: "", id: ""),
    count: Counts(finished: 5, canceled: 2, noShow: 1, paids: 3),
  );

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InitialController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(child: Text('Erro: ${controller.error}'));
    }

    if (controller.statement == null) {
      return const Center(child: Text('Nenhum dado disponível.'));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _apresentation(context),
              BusinessCard(statement: controller.statement!),
              BusinessDashboards()
            ],
          ),
        ),
      ),
    );
  }

  Widget _apresentation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final session = context.watch<SessionService>();

    if (!session.isUserLogged) {
      return const Center(child: Text('Usuário não logado'));
    }

    final user = session.user;
    final name = user?.username ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15, left: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Olá, $name",
            style: const TextStyle(fontSize: 24.0),
          ),
          // SUBSTITUÍDO: PopupMenuButton
          GestureDetector(
            onTap: () =>
                _showUserActionsModal(context), // <--- CHAMA O NOVO MODAL
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.surfaceBright,
              ),
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  color: Colors.grey.shade800,
                  child: user?.photoUrl != null
                      ? Image.network(
                          user!.photoUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.business, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserActionsModal(BuildContext context) {
  final sessionService = context.read<SessionService>();
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: false, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Um raio um pouco menor
    ),
    backgroundColor: colorScheme.surfaceContainer, 
    builder: (BuildContext bc) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(bc);
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(bc); // Fecha o modal
                sessionService.logout();
                context.go('/login');
              },
            ),

            const SizedBox(height: 10), 
          ],
        ),
      );
    },
  );
}
}
