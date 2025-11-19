/// Completion Widget - "The End" is the product (STORY-007)
library;

import 'package:flutter/material.dart';
import '../models/bloom_card.dart';
import '../theme/design_tokens.dart';

class CompletionWidget extends StatefulWidget {
  final CompletionData completion;

  const CompletionWidget({
    super.key,
    required this.completion,
  });

  @override
  State<CompletionWidget> createState() => _CompletionWidgetState();
}

class _CompletionWidgetState extends State<CompletionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Gentle fade and scale animation (snappy < 300ms per architect's note)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BloomSpacing.screenPadding,
          vertical: BloomSpacing.lg,
        ),
        padding: const EdgeInsets.all(BloomSpacing.xl),
        decoration: BoxDecoration(
          color: BloomColors.primaryBg,
          borderRadius: BloomSpacing.cardBorderRadius,
          border: Border.all(
            color: BloomColors.inkTertiary,
            width: BloomSpacing.borderWidth,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flower icon (simple alternative to Lottie for now)
            _buildFlowerIcon(),
            const SizedBox(height: BloomSpacing.lg),

            // Main message
            Text(
              widget.completion.message,
              style: BloomTypography.h2.copyWith(
                color: BloomColors.growthGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BloomSpacing.sm),

            // Subtitle
            Text(
              widget.completion.subtitle,
              style: BloomTypography.bodyMedium.copyWith(
                color: BloomColors.inkSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BloomSpacing.lg),

            // Stats
            _buildStatsRow(),
            const SizedBox(height: BloomSpacing.md),

            // Return tomorrow message
            Container(
              padding: const EdgeInsets.all(BloomSpacing.md),
              decoration: BoxDecoration(
                color: BloomColors.surfaceBg,
                borderRadius: BloomSpacing.cardBorderRadius,
                border: Border.all(
                  color: BloomColors.inkTertiary,
                  width: BloomSpacing.borderWidth,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: BloomColors.inkSecondary,
                  ),
                  const SizedBox(width: BloomSpacing.xs),
                  Text(
                    'New blooms arrive tomorrow',
                    style: BloomTypography.caption.copyWith(
                      color: BloomColors.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowerIcon() {
    // Simple animated flower using Flutter icons
    // Future: Replace with Lottie animation
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * 0.5, // Slight rotation during scale
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: BloomColors.growthGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_florist_outlined,
                size: 48,
                color: BloomColors.growthGreen,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BloomSpacing.md,
        vertical: BloomSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: BloomColors.surfaceBg,
        borderRadius: BloomSpacing.cardBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Read count
          _buildStatItem(
            icon: Icons.check_circle_outline,
            label: 'Cards Read',
            value: '${widget.completion.readCount}',
          ),
          const SizedBox(width: BloomSpacing.lg),
          // Daily limit indicator
          _buildStatItem(
            icon: Icons.spa_outlined,
            label: 'Daily Goal',
            value: '${widget.completion.dailyLimit}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: BloomColors.growthGreen,
        ),
        const SizedBox(height: BloomSpacing.xs),
        Text(
          value,
          style: BloomTypography.dataLarge.copyWith(
            color: BloomColors.inkPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: BloomTypography.caption.copyWith(
            color: BloomColors.inkSecondary,
          ),
        ),
      ],
    );
  }
}
