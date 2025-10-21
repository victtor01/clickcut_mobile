import 'package:clickcut_mobile/core/dtos/business_statement.dart';
import 'package:clickcut_mobile/core/dtos/business_statement_count.dart';
import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';
import 'package:clickcut_mobile/features/general/presentation/screens/components/business_card/busines_card.dart';
import 'package:flutter/material.dart';

class InitScreen extends StatelessWidget {
		
  InitScreen({super.key });

  final business = BusinessStatement(
    name: "ClickCut",
    revenue: 400.0,
    revenueGoal: 1000.0,
    userSession: User(email: "josevictor.ar@gmail.com", name: "", id: ""),
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
														BusinessCard(statement: business,),
												],
										),
								),
						),
    );
  }

  Widget _apresentation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15, left: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Olá, José",
            style: TextStyle(fontSize: 24.0),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.surfaceBright,
            ),
            width: 45,
            height: 45,
          ),
        ],
      ),
    );
  }
}