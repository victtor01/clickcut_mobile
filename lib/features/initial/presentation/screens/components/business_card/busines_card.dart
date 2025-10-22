import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/features/auth/domain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessCard extends StatelessWidget {
  final BusinessStatement statement;

  const BusinessCard({super.key, required this.statement});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
	    final session = context.watch<SessionService>();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + info + revenue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Avatar circular
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Nome e email
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statement.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              statement.userSession.email,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Receita
                Text(
                  "R\$ ${statement.revenue.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            const SizedBox(height: 15),

            // Barra de progresso + labels
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "R\$ ${statement.revenue.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "R\$ ${statement.revenueGoal.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth;
                    final progressWidth =
                        (statement.progressPercentage.clamp(0, 100) / 100) *
                            barWidth;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          height: 10,
                          width: progressWidth,
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Positioned(
                          left: progressWidth - 25,
                          top: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "${statement.progressPercentage.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Estatísticas finais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statItem("Cancelados", statement.count.canceled),
                _statItem("Não apareceu", statement.count.noShow),
                _statItem("Completos", statement.count.finished),
                _statItem("Pagos", statement.count.paids),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        )
      ],
    );
  }
}
