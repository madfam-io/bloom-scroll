/// Main feed screen with upward scrolling and masonry grid
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/bloom_card.dart';
import '../providers/api_provider.dart';
import '../widgets/owid_card.dart';
import '../widgets/aesthetic_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 Bloom Scroll'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(feedProvider);
            },
            tooltip: 'Refresh feed',
          ),
        ],
      ),
      body: feedAsync.when(
        data: (feedResponse) => _buildFeed(context, feedResponse),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _buildError(context, error, ref),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Scroll to top (which is bottom in reverse mode)
        },
        icon: const Icon(Icons.arrow_downward),
        label: const Text('Plant a Seed'),
        tooltip: 'Scroll to newest content',
      ),
    );
  }

  Widget _buildFeed(BuildContext context, FeedResponse feedResponse) {
    if (feedResponse.cards.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Info banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${feedResponse.count} cards • Scroll UP to see history',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // The upward scrolling masonry grid
        Expanded(
          child: CustomScrollView(
            // CRITICAL: reverse: true makes index 0 appear at the bottom
            reverse: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // End marker at top
              SliverToBoxAdapter(
                child: _buildEndMarker(context),
              ),

              // Masonry grid of cards
              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childCount: feedResponse.cards.length,
                itemBuilder: (context, index) {
                  return _buildCardForIndex(context, feedResponse.cards, index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build appropriate card widget with "Robin Hood" layout logic
  Widget _buildCardForIndex(BuildContext context, List<BloomCard> cards, int index) {
    final card = cards[index];

    // OWID cards: Full width (span 2 columns)
    if (card.isOwid) {
      return _buildFullWidthCard(card);
    }

    // Aesthetic cards: Single column (natural masonry fit)
    if (card.isAesthetic) {
      return AestheticCard(card: card);
    }

    // Fallback for other card types
    return _buildGenericCard(context, card);
  }

  /// Wrap OWID cards to span full width
  Widget _buildFullWidthCard(BloomCard card) {
    return SizedBox(
      // This will be placed in masonry but we want it full width
      // The parent will be 1 column wide, so we just render OwidCard normally
      child: OwidCard(card: card),
    );
  }

  Widget _buildEndMarker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Colors.green.shade600,
          ),
          const SizedBox(height: 12),
          Text(
            'You\'ve reached the end! 🌸',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No infinite scroll here. Time for a break!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenericCard(BuildContext context, BloomCard card) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(card.sourceType),
              visualDensity: VisualDensity.compact,
            ),
            if (card.summary != null) ...[
              const SizedBox(height: 8),
              Text(card.summary!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.energy_savings_leaf,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No cards in the feed yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingest some data from the backend',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load feed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(feedProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Show connection settings dialog
                _showConnectionDialog(context);
              },
              child: const Text('Check connection settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Help'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Make sure the backend is running:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'cd backend\n./run_dev.sh',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 12),
            const Text('iOS Simulator: http://localhost:8000'),
            const Text('Android Emulator: http://10.0.2.2:8000'),
            const Text('Physical Device: http://<your-ip>:8000'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
