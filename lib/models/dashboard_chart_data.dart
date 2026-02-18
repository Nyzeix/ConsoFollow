import 'dart:ui';
import 'package:conso_follow/models/consumption.dart';

class DashboardChartData {
  final List<List<Consumption>> series;
  final List<Color> lineColors;
  final List<String> lineLabels;

  const DashboardChartData({
    required this.series,
    required this.lineColors,
    required this.lineLabels,
  });
}