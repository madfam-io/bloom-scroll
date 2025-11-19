/// Aesthetic Card Widget - Displays images from visual culture
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/bloom_card.dart';
import '../theme/design_tokens.dart';
import 'perspective/flippable_card.dart';

class AestheticCard extends StatelessWidget {
  final BloomCard card;

  const AestheticCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final aestheticData = card.aestheticData;
    if (aestheticData == null) {
      return _buildErrorCard(context, 'Invalid aesthetic data');
    }

    return FlippableCard(
      card: card,
      front: GestureDetector(
        onTap: () {
          // Open full-screen view with Hero animation
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _FullScreenImage(
                card: card,
                aestheticData: aestheticData,
              ),
            ),
          );
        },
        child: Card(
        margin: const EdgeInsets.all(BloomSpacing.xs),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with Hero animation and aspect ratio
            Hero(
              tag: 'aesthetic-${card.id}',
              child: AspectRatio(
                aspectRatio: aestheticData.aspectRatio,
                child: CachedNetworkImage(
                  imageUrl: aestheticData.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: _parseColor(aestheticData.dominantColor),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: BloomColors.skeletonBg,
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: BloomColors.inkTertiary,
                    ),
                  ),
                ),
              ),
            ),

            // Metadata
            Padding(
              padding: const EdgeInsets.all(BloomSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vibe tags
                  if (aestheticData.vibeTags.isNotEmpty)
                    Wrap(
                      spacing: BloomSpacing.xs,
                      runSpacing: BloomSpacing.xs,
                      children: aestheticData.vibeTags.take(2).map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: BloomColors.surfaceBg,
                          labelStyle: BloomTypography.caption.copyWith(
                            color: BloomColors.inkSecondary,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: BloomSpacing.sm),

                  // Title (truncated)
                  Text(
                    card.title,
                    style: BloomTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return Card(
      margin: const EdgeInsets.all(BloomSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(BloomSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.title,
              style: BloomTypography.bodyMedium,
            ),
            const SizedBox(height: BloomSpacing.sm),
            Text(
              message,
              style: BloomTypography.bodyMedium.copyWith(
                color: BloomColors.bloomRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return BloomColors.inkTertiary;
    }
  }
}

/// Full-screen image viewer with Hero animation
class _FullScreenImage extends StatelessWidget {
  final BloomCard card;
  final AestheticData aestheticData;

  const _FullScreenImage({
    required this.card,
    required this.aestheticData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              // TODO: Open original URL
            },
            tooltip: 'View source',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen image with Hero animation
          Center(
            child: Hero(
              tag: 'aesthetic-${card.id}',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: aestheticData.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: _parseColor(aestheticData.dominantColor),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom metadata overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (card.summary != null)
                      Text(
                        card.summary!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: aestheticData.vibeTags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
