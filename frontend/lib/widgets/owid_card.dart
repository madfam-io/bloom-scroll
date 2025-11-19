/// OWID Card Widget - Renders interactive charts from Our World in Data
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/bloom_card.dart';

class OwidCard extends StatefulWidget {
  final BloomCard card;

  const OwidCard({
    super.key,
    required this.card,
  });

  @override
  State<OwidCard> createState() => _OwidCardState();
}

class _OwidCardState extends State<OwidCard> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final owidData = widget.card.owidData;
    if (owidData == null) {
      return _buildErrorCard('Invalid OWID data');
    }

    final dataPoints = owidData.dataPoints;
    if (dataPoints.isEmpty) {
      return _buildErrorCard('No data available');
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              widget.card.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),

            // Source badge
            Chip(
              label: const Text('OWID'),
              backgroundColor: Colors.green.shade50,
              labelStyle: TextStyle(
                color: Colors.green.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              visualDensity: VisualDensity.compact,
            ),

            const SizedBox(height: 20),

            // Chart
            SizedBox(
              height: 200,
              child: _buildChart(dataPoints, owidData),
            ),

            const SizedBox(height: 16),

            // Summary info
            if (widget.card.summary != null)
              Text(
                widget.card.summary!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<ChartPoint> dataPoints, OwidChartData owidData) {
    return LineChart(
      LineChartData(
        // Grid and borders - Tufte style (minimal)
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: null,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),

        // Titles
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatValue(value, owidData.unit),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateInterval(owidData.years),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        // The actual line
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .map((point) => FlSpot(point.x, point.y))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: Colors.green.shade600,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: index == _touchedIndex ? 6 : 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.green.shade600,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.shade600.withOpacity(0.1),
            ),
          ),
        ],

        // Touch interaction
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (touchResponse == null || touchResponse.lineBarSpots == null) {
              setState(() {
                _touchedIndex = null;
              });
              return;
            }

            setState(() {
              _touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            });
          },
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: Colors.green.shade600,
                  strokeWidth: 2,
                  dashArray: [5, 5],
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: Colors.green.shade600,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.green.shade700,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final year = touchedSpot.x.toInt();
                final value = touchedSpot.y;
                return LineTooltipItem(
                  '$year\n${_formatValue(value, owidData.unit)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.card.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(double value, String unit) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B $unit';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M $unit';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K $unit';
    } else {
      return '${value.toStringAsFixed(1)} $unit';
    }
  }

  double _calculateInterval(List<int> years) {
    if (years.length <= 5) return 1;
    if (years.length <= 10) return 2;
    if (years.length <= 20) return 5;
    return 10;
  }
}
