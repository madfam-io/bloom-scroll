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

/// Main BloomCard model - polymorphic content container
class BloomCard {
  final String id;
  final String sourceType;
  final String title;
  final String? summary;
  final String originalUrl;
  final Map<String, dynamic> dataPayload;
  final double? biasScore;
  final double? constructivenessScore;
  final List<String>? blindspotTags;
  final DateTime createdAt;

  BloomCard({
    required this.id,
    required this.sourceType,
    required this.title,
    this.summary,
    required this.originalUrl,
    required this.dataPayload,
    this.biasScore,
    this.constructivenessScore,
    this.blindspotTags,
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
      biasScore: (json['bias_score'] as num?)?.toDouble(),
      constructivenessScore: (json['constructiveness_score'] as num?)?.toDouble(),
      blindspotTags: (json['blindspot_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

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
