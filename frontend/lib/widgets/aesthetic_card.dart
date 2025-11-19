/// Aesthetic Card Widget - Displays images from visual culture
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/bloom_card.dart';

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

    return GestureDetector(
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
        margin: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
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
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            // Metadata
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vibe tags
                  if (aestheticData.vibeTags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: aestheticData.vibeTags.take(2).map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: _parseColor(aestheticData.dominantColor)
                              .withOpacity(0.2),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: _parseColor(aestheticData.dominantColor)
                                .computeLuminance() > 0.5
                                ? Colors.black87
                                : Colors.white,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 8),

                  // Title (truncated)
                  Text(
                    card.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
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
      return Colors.grey;
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
