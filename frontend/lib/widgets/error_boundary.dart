/// Error boundary widget to catch and handle widget errors gracefully
library;

import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();

    // Capture errors in this subtree
    FlutterError.onError = (details) {
      if (mounted) {
        setState(() {
          _errorDetails = details;
        });
      }
      // Still log to console
      FlutterError.presentError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return widget.errorBuilder?.call(_errorDetails!) ??
          _buildDefaultErrorWidget(context);
    }

    return widget.child;
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      color: BloomColors.primaryBg,
      padding: const EdgeInsets.all(BloomSpacing.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: BloomColors.bloomRed,
            ),
            const SizedBox(height: BloomSpacing.lg),
            Text(
              'Something went wrong',
              style: BloomTypography.h3.copyWith(
                color: BloomColors.bloomRed,
              ),
            ),
            const SizedBox(height: BloomSpacing.sm),
            Text(
              'The app encountered an unexpected error.',
              style: BloomTypography.bodyMedium.copyWith(
                color: BloomColors.inkSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BloomSpacing.lg),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _errorDetails = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
