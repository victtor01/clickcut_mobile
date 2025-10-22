import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/core/dtos/business_statement_count.dart';
import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:clickcut_mobile/features/initial/presentation/screens/components/business_card/busines_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatelessWidget {
  InitScreen({super.key});

  final business = BusinessStatement(
    name: "ClickCut",
    revenue: 400.0,
    revenueGoal: 1000.0,
    userSession: User(email: "josevictor.ar@gmail.com", username: "", id: ""),
    count: Counts(finished: 5, canceled: 2, noShow: 1, paids: 3),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _apresentation(context),
              BusinessCard(
                statement: business,
              ),
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
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'config') {
            // Navigator.pushNamed(context, '/configurations');
          } else if (value == 'logout') {
            context.read<SessionService>().logout();
            context.go('/login');
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 'config',
            child: Text('Configurações'),
          ),
          const PopupMenuItem(
            value: 'logout',
            child: Text('Logout'),
          ),
        ],
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
}
