/// Flippable Card Widget - 3D flip animation for perspective overlay
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/bloom_card.dart';
import '../../theme/design_tokens.dart';
import 'perspective_overlay.dart';

class FlippableCard extends StatefulWidget {
  final Widget front;
  final BloomCard card;

  const FlippableCard({
    super.key,
    required this.front,
    required this.card,
  });

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300), // Snappy animation <300ms per architect's note
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Determine if we should show front or back based on rotation
        final angle = _animation.value;
        final showFront = angle < math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Add perspective
            ..rotateY(angle),
          child: showFront
              ? _buildFront()
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: _buildBack(),
                ),
        );
      },
    );
  }

  Widget _buildFront() {
    return Stack(
      children: [
        widget.front,
        // Info icon button in top-right corner
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _flip,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BloomColors.primaryBg.withOpacity(0.9),
                  border: Border.all(
                    color: BloomColors.inkTertiary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: BloomColors.inkPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBack() {
    return PerspectiveOverlay(
      card: widget.card,
      onClose: _flip,
    );
  }
}
