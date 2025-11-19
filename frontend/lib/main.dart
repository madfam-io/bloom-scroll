import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/feed_screen.dart';
import 'theme/bloom_theme.dart';
import 'widgets/error_boundary.dart';

void main() {
  // Global error handler for uncaught errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('💥 Uncaught error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(BloomTheme.systemUiOverlayStyle);

  runApp(
    // Wrap app in ProviderScope for Riverpod
    const ProviderScope(
      child: ErrorBoundary(
        child: BloomScrollApp(),
      ),
    ),
  );
}

class BloomScrollApp extends StatelessWidget {
  const BloomScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Scroll',
      debugShowCheckedModeBanner: false,
      // Apply "Paper & Ink" design system
      theme: BloomTheme.lightTheme,
      home: const FeedScreen(),
    );
  }
}
