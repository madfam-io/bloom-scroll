import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/feed_screen.dart';
import 'theme/bloom_theme.dart';

void main() {
  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(BloomTheme.systemUiOverlayStyle);

  runApp(
    // Wrap app in ProviderScope for Riverpod
    const ProviderScope(
      child: BloomScrollApp(),
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
