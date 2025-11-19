import 'package:flutter/material.dart';

void main() {
  runApp(const BloomScrollApp());
}

class BloomScrollApp extends StatelessWidget {
  const BloomScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Scroll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 Bloom Scroll'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.energy_savings_leaf,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Bloom Scroll',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'A perspective-driven content aggregator',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: () {
                // TODO: Navigate to feed
              },
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Start Scrolling Up'),
            ),
          ],
        ),
      ),
    );
  }
}
