/// Bias Compass - Political spectrum visualization
library;

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

class BiasCompass extends StatelessWidget {
  final double biasScore; // -1.0 (left) to +1.0 (right)

  const BiasCompass({
    super.key,
    required this.biasScore,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp bias score to valid range
    final clampedScore = biasScore.clamp(-1.0, 1.0);

    // Convert to 0-1 range for positioning (0 = left, 0.5 = center, 1 = right)
    final position = (clampedScore + 1.0) / 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(
              Icons.explore_outlined,
              size: 16,
              color: BloomColors.inkSecondary,
            ),
            const SizedBox(width: BloomSpacing.xs),
            Text(
              'Political Spectrum',
              style: BloomTypography.labelMedium.copyWith(
                color: BloomColors.inkSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: BloomSpacing.sm),

        // The horizontal line with fulcrum
        SizedBox(
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The line
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        BloomColors.bloomRed.withOpacity(0.3), // Left
                        BloomColors.inkTertiary, // Center
                        BloomColors.bloomRed.withOpacity(0.3), // Right
                      ],
                    ),
                  ),
                ),
              ),

              // Fulcrum (center marker)
              Positioned(
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 2,
                    height: 12,
                    color: BloomColors.inkTertiary,
                  ),
                ),
              ),

              // The pill indicator
              Positioned(
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment(
                    (position * 2) - 1, // Convert 0-1 to -1 to 1
                    0,
                  ),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: BloomColors.inkPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: BloomColors.primaryBg,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: BloomSpacing.xs),

        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Left-Leaning',
              style: BloomTypography.caption,
            ),
            Text(
              'Center',
              style: BloomTypography.caption,
            ),
            Text(
              'Right-Leaning',
              style: BloomTypography.caption,
            ),
          ],
        ),
      ],
    );
  }
}
