import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fl_chart/fl_chart.dart';

class BusinessDashboards extends StatelessWidget {
  const BusinessDashboards({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20),
          HistoryWidget(),
          SizedBox(width: 8),
          HistoryWidget(),
          SizedBox(width: 8),
          HistoryWidget(),
          SizedBox(width: 8),
          HistoryWidget(),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colors.surfaceContainer),
      width: 300,
      height: 150,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Histórico de agendamento"),
                Icon(
                  Iconsax.chart_2,
                  size: 20,
                  color: colors.onSurface,
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false), 
                  titlesData: FlTitlesData(show: false), 
                  borderData: FlBorderData(show: false), 
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 3),
                        FlSpot(2, 2.5),
                        FlSpot(3, 4),
                        FlSpot(4, 3.5),
                      ], 
                      isCurved: true,
                      color: colors.onSurface,
                      barWidth: 3,
                      dotData: FlDotData(show: false), // sem pontos
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
