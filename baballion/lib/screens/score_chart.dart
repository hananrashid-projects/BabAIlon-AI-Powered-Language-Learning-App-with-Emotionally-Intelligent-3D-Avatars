// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:babellion/models/dashboard_data.dart'; // Ensure this path is correct

// enum ChartType { bar, scatter }

// class ScoreChart extends StatelessWidget {
//   final List<Score> scores;
//   final ChartType chartType;

//   const ScoreChart({Key? key, required this.scores, required this.chartType})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300, // Adjust size as needed
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: chartType == ChartType.bar
//               ? _buildBarChart()
//               : _buildScatterPlot(),
//         ),
//       ),
//     );
//   }

//   /// Builds a Bar Chart using `fl_chart`
//   Widget _buildBarChart() {
//     return BarChart(
//       BarChartData(
//         titlesData: FlTitlesData(show: true),
//         borderData: FlBorderData(show: false),
//         barGroups: scores.asMap().entries.map((entry) {
//           int index = entry.key;
//           Score score = entry.value;
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                   toY: score.vocabulary_score, color: Colors.blue, width: 15),
//               BarChartRodData(
//                   toY: score.fluency_score, color: Colors.green, width: 15),
//               BarChartRodData(
//                   toY: score.grammar_score, color: Colors.red, width: 15),
//               BarChartRodData(
//                   toY: score.pronunciation_score,
//                   color: Colors.orange,
//                   width: 15),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   /// Builds a Scatter Plot using `fl_chart`
//   Widget _buildScatterPlot() {
//     return ScatterChart(
//       ScatterChartData(
//         titlesData: FlTitlesData(show: true),
//         borderData: FlBorderData(show: false),
//         scatterSpots: scores.asMap().entries.expand((entry) {
//           int index = entry.key;
//           Score score = entry.value;
//           return [
//             ScatterSpot(
//               index.toDouble(),
//               score.vocabulary_score,
//               dotData: FlDotData(
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(radius: 4, color: Colors.blue);
//                 },
//               ),
//             ),
//             ScatterSpot(
//               index.toDouble(),
//               score.fluency_score,
//               dotData: FlDotData(
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(radius: 4, color: Colors.green);
//                 },
//               ),
//             ),
//             ScatterSpot(
//               index.toDouble(),
//               score.grammar_score,
//               dotData: FlDotData(
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(radius: 4, color: Colors.red);
//                 },
//               ),
//             ),
//             ScatterSpot(
//               index.toDouble(),
//               score.pronunciation_score,
//               dotData: FlDotData(
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(radius: 4, color: Colors.orange);
//                 },
//               ),
//             ),
//           ];
//         }).toList(),
//       ),
//     );
//   }
// }
