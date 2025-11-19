/// Dart model mirroring the backend BloomCard schema
library;

import 'package:flutter/foundation.dart';

/// OWID-specific chart data payload
class OwidChartData {
  final String chartType;
  final List<int> years;
  final List<double> values;
  final String unit;
  final String indicator;
  final String entity;

  OwidChartData({
    required this.chartType,
    required this.years,
    required this.values,
    required this.unit,
    required this.indicator,
    required this.entity,
  });

  factory OwidChartData.fromJson(Map<String, dynamic> json) {
    return OwidChartData(
      chartType: json['chart_type'] as String? ?? 'line',
      years: (json['years'] as List<dynamic>).map((e) => e as int).toList(),
      values: (json['values'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      unit: json['unit'] as String,
      indicator: json['indicator'] as String,
      entity: json['entity'] as String? ?? 'World',
    );
  }

  /// Get chart data as coordinate pairs for fl_chart
  List<ChartPoint> get dataPoints {
    return List.generate(
      years.length,
      (i) => ChartPoint(years[i].toDouble(), values[i]),
    );
  }
}

/// Generic coordinate point for chart rendering
class ChartPoint {
  final double x;
  final double y;

  ChartPoint(this.x, this.y);
}

/// Perspective metadata for the flip overlay
class PerspectiveMeta {
  final double biasScore; // -1.0 (left) to +1.0 (right)
  final double constructivenessScore; // 0.0 to 100.0
  final List<String> blindspotTags;
  final String reasonTag; // BLINDSPOT_BREAKER, DEEP_DIVE, EXPLORE, etc.

  PerspectiveMeta({
    required this.biasScore,
    required this.constructivenessScore,
    required this.blindspotTags,
    required this.reasonTag,
  });

  factory PerspectiveMeta.fromJson(Map<String, dynamic> json) {
    return PerspectiveMeta(
      biasScore: (json['bias_score'] as num?)?.toDouble() ?? 0.0,
      constructivenessScore: (json['constructiveness_score'] as num?)?.toDouble() ?? 50.0,
      blindspotTags: (json['blindspot_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      reasonTag: json['reason_tag'] as String? ?? 'RECENT',
    );
  }

  /// Get human-readable reason text for display
  String get reasonText {
    switch (reasonTag) {
      case 'BLINDSPOT_BREAKER':
        return '🌱 Blindspot Breaker: You rarely read this perspective';
      case 'DEEP_DIVE':
        return '⚓ Deep Dive: Connected to your interests';
      case 'EXPLORE':
        return '🗺️ Explore: New territory for you';
      case 'PERSPECTIVE_SHIFT':
        return '🔄 Perspective Shift: Related but novel';
      case 'SERENDIPITY':
        return '✨ Serendipity: Discover something new';
      case 'RECENT':
      default:
        return '📰 Recent: Fresh content';
    }
  }
}

/// Main BloomCard model - polymorphic content container
class BloomCard {
  final String id;
  final String sourceType;
  final String title;
  final String? summary;
  final String originalUrl;
  final Map<String, dynamic> dataPayload;
  final PerspectiveMeta? meta; // Perspective metadata for flip overlay
  final DateTime createdAt;

  BloomCard({
    required this.id,
    required this.sourceType,
    required this.title,
    this.summary,
    required this.originalUrl,
    required this.dataPayload,
    this.meta,
    required this.createdAt,
  });

  factory BloomCard.fromJson(Map<String, dynamic> json) {
    return BloomCard(
      id: json['id'] as String,
      sourceType: json['source_type'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
      originalUrl: json['original_url'] as String,
      dataPayload: json['data_payload'] as Map<String, dynamic>,
      meta: json['meta'] != null
          ? PerspectiveMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Legacy accessors for backward compatibility
  double? get biasScore => meta?.biasScore;
  double? get constructivenessScore => meta?.constructivenessScore;
  List<String>? get blindspotTags => meta?.blindspotTags;

  /// Parse OWID-specific payload
  OwidChartData? get owidData {
    if (sourceType == 'OWID') {
      try {
        return OwidChartData.fromJson(dataPayload);
      } catch (e) {
        debugPrint('Error parsing OWID data: $e');
        return null;
      }
    }
    return null;
  }

  /// Parse aesthetic-specific payload
  AestheticData? get aestheticData {
    if (sourceType == 'AESTHETIC') {
      try {
        return AestheticData.fromJson(dataPayload);
      } catch (e) {
        debugPrint('Error parsing aesthetic data: $e');
        return null;
      }
    }
    return null;
  }

  /// Check if this is an OWID card
  bool get isOwid => sourceType == 'OWID';

  /// Check if this is an aesthetic card
  bool get isAesthetic => sourceType == 'AESTHETIC';
}

/// Aesthetic-specific image data payload
class AestheticData {
  final String imageUrl;
  final double aspectRatio;
  final String dominantColor;
  final List<String> vibeTags;
  final int? arenaBlockId;

  AestheticData({
    required this.imageUrl,
    required this.aspectRatio,
    required this.dominantColor,
    required this.vibeTags,
    this.arenaBlockId,
  });

  factory AestheticData.fromJson(Map<String, dynamic> json) {
    return AestheticData(
      imageUrl: json['image_url'] as String,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 1.0,
      dominantColor: json['dominant_color'] as String? ?? '#808080',
      vibeTags: (json['vibe_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      arenaBlockId: json['arena_block_id'] as int?,
    );
  }
}

/// Feed response from API
class FeedResponse {
  final String message;
  final String sessionId;
  final List<BloomCard> cards;
  final int count;

  FeedResponse({
    required this.message,
    required this.sessionId,
    required this.cards,
    required this.count,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      message: json['message'] as String,
      sessionId: json['session_id'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => BloomCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
    );
  }
}
