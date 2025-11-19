/// Riverpod providers for API service and feed data
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bloom_card.dart';
import '../services/api_service.dart';

/// Provider for ApiService instance
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Provider for fetching the feed
final feedProvider = FutureProvider<FeedResponse>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getFeed();
});

/// Provider for backend health check
final healthCheckProvider = FutureProvider<bool>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.checkHealth();
});
