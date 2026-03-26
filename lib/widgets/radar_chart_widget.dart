import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../data/onet_data.dart';

class RadarChartWidget extends StatelessWidget {
  const RadarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final result = provider.getResult();
    
    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarTouchData: RadarTouchData(enabled: true),
          dataSets: [
            RadarDataSet(
              fillColor: AppColors.accent.withValues(alpha: 0.25),
              borderColor: AppColors.accent,
              entryRadius: 3,
              borderWidth: 2,
              dataEntries: [
                RadarEntry(value: result.percentageScores['R'] ?? 0),
                RadarEntry(value: result.percentageScores['I'] ?? 0),
                RadarEntry(value: result.percentageScores['A'] ?? 0),
                RadarEntry(value: result.percentageScores['S'] ?? 0),
                RadarEntry(value: result.percentageScores['E'] ?? 0),
                RadarEntry(value: result.percentageScores['C'] ?? 0),
              ],
            ),
          ],
          tickCount: 5,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          gridBorderData: BorderSide(color: AppColors.textLight.withValues(alpha: 0.1)),
          tickBorderData: BorderSide(color: AppColors.textLight.withValues(alpha: 0.1)),
          getTitle: (index, angle) {
            final codes = ['R', 'I', 'A', 'S', 'E', 'C'];
            final type = ONETData.riasecTypes.firstWhere((t) => t.code == codes[index]);
            return RadarChartTitle(
              text: '${type.emoji} ${type.name}',
              angle: angle,
            );
          },
          titleTextStyle: const TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
