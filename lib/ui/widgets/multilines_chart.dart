import 'package:fl_chart/fl_chart.dart';
import 'package:conso_follow/models/consumption.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// Assisté par IA pour la création du LineChart, car je ne connaissais pas la librairie.

class ConsumptionMultiLineChart extends StatelessWidget {
  final List<List<Consumption>> series;
  final List<Color>? lineColors;
  final Color? backgroundColor;

  const ConsumptionMultiLineChart({
    super.key,
    required this.series,
    this.lineColors,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          // Titre du graphique
          // Titre extérieure au graphique parce que ce dernier se retrouve sous le graphique si l'on souhaite l'éditer.
          Center(
            child: Text(
              'Consommation',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 20, 12),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Date'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: Duration.millisecondsPerDay.toDouble(),
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Transform.rotate(
                              angle: math.pi / 2,
                              child: Text(
                                _formatDay(value),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: _buildLineBarsData(),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${_formatDay(spot.x)}\n${spot.y.toInt()}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    return List.generate(series.length, (index) {
      final color = (lineColors != null && index < lineColors!.length)
          ? lineColors![index]
          : Colors.blue;

      return LineChartBarData(
        spots: _generateSpots(series[index]),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: true, color: color.withOpacity(0.2)), // .withOpacity est déprécié, mais il n'y a pas d'alternative
      );
    });
  }

  /// Converti la liste de données de consommation en une liste de points pour le graph
  List<FlSpot> _generateSpots(List<Consumption> data) {
    final sortedData = [...data]..sort((consoOne, nextConso) => consoOne.date.compareTo(nextConso.date));
    return sortedData.map((e) {
      final xValue = e.time.millisecondsSinceEpoch.toDouble();
      return FlSpot(xValue, e.amount);
    }).toList();
  }

  String _formatDay(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.round());
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }
}