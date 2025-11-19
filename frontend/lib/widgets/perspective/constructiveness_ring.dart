/// Constructiveness Ring - Nutritional score visualization
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class ConstructivenessRing extends StatelessWidget {
  final double score; // 0.0 to 100.0

  const ConstructivenessRing({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp score to valid range
    final clampedScore = score.clamp(0.0, 100.0);

    // Determine color and label based on score
    final Color ringColor;
    final String label;
    if (clampedScore < 50) {
      ringColor = BloomColors.inkTertiary; // Gray/Dull
      label = 'High Noise';
    } else if (clampedScore > 80) {
      ringColor = BloomColors.growthGreen; // Green
      label = 'High Signal';
    } else {
      ringColor = BloomColors.inkSecondary; // Medium gray
      label = 'Mixed Signal';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(
              Icons.radar_outlined,
              size: 16,
              color: BloomColors.inkSecondary,
            ),
            const SizedBox(width: BloomSpacing.xs),
            Text(
              'Constructiveness Score',
              style: BloomTypography.labelMedium.copyWith(
                color: BloomColors.inkSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: BloomSpacing.sm),

        // Ring and score
        Row(
          children: [
            // Radial gauge (circle)
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: _ConstructivenessRingPainter(
                  score: clampedScore,
                  color: ringColor,
                ),
                child: Center(
                  child: Text(
                    '${clampedScore.toInt()}',
                    style: BloomTypography.dataLarge.copyWith(
                      color: ringColor,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: BloomSpacing.md),

            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: BloomTypography.labelLarge.copyWith(
                      color: ringColor,
                    ),
                  ),
                  const SizedBox(height: BloomSpacing.xs),
                  Text(
                    _getScoreDescription(clampedScore),
                    style: BloomTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getScoreDescription(double score) {
    if (score < 50) {
      return 'Contains emotional language, partisan framing, or inflammatory content.';
    } else if (score > 80) {
      return 'Well-sourced, balanced analysis with constructive tone.';
    } else {
      return 'Mix of factual content and opinion-based framing.';
    }
  }
}

class _ConstructivenessRingPainter extends CustomPainter {
  final double score; // 0.0 to 100.0
  final Color color;

  _ConstructivenessRingPainter({
    required this.score,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Background circle (light)
    final bgPaint = Paint()
      ..color = BloomColors.surfaceBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius, bgPaint);

    // Foreground arc (score indicator)
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Draw arc from -90 degrees (top) clockwise
    final sweepAngle = (score / 100.0) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start at top
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_ConstructivenessRingPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
