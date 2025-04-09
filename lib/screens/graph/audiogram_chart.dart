import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AudiogramChart extends StatelessWidget {
  final List<FlSpot> rightAirConduction = [
    FlSpot(125, 30),  // (Frequency in Hz, Hearing Threshold in dB)
    FlSpot(250, 40),
    FlSpot(500, 50),
    FlSpot(1000, 60),
    FlSpot(2000, 70),
    FlSpot(4000, 80),
    FlSpot(8000, 90),
  ];

  final List<FlSpot> leftAirConduction = [
    FlSpot(125, 35),
    FlSpot(250, 45),
    FlSpot(500, 55),
    FlSpot(1000, 65),
    FlSpot(2000, 75),
    FlSpot(4000, 85),
    FlSpot(8000, 95),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.5, // Adjust graph size
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text('${value.toInt()} dB'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text('${value.toInt()} Hz'),
                ),
              ),
            ),
            lineBarsData: [
              _buildLineData(rightAirConduction, Colors.red, isDashed: true),
              _buildLineData(leftAirConduction, Colors.blue, isDashed: false),
            ],
            borderData: FlBorderData(show: true),
            minX: 100,
            maxX: 8000,
            minY: 0,
            maxY: 130,
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineData(List<FlSpot> spots, Color color, {bool isDashed = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      barWidth: 3,
      color: color,
      belowBarData: BarAreaData(show: false),
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 5,
            color: color,
            strokeColor: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      dashArray: isDashed ? [5, 5] : null, // Dashed lines for masked values
    );
  }
}
