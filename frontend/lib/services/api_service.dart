/// API service for communicating with Bloom Scroll backend
library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/bloom_card.dart';
import 'api_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiUrl,
        connectTimeout: ApiConfig.timeout,
        receiveTimeout: ApiConfig.timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (ApiConfig.enableLogging && kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  /// Fetch the bloom feed
  Future<FeedResponse> getFeed() async {
    try {
      final response = await _dio.get('/feed');
      return FeedResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('Error fetching feed: ${e.message}');
      rethrow;
    }
  }

  /// Ingest a single OWID dataset (for testing)
  Future<BloomCard> ingestOwid({
    String datasetKey = 'co2_emissions',
    String entity = 'World',
    int yearsBack = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/ingest/owid',
        queryParameters: {
          'dataset_key': datasetKey,
          'entity': entity,
          'years_back': yearsBack,
        },
      );
      return BloomCard.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('Error ingesting OWID data: ${e.message}');
      rethrow;
    }
  }

  /// Get list of available datasets
  Future<Map<String, dynamic>> getAvailableDatasets() async {
    try {
      final response = await _dio.get('/ingest/datasets');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('Error fetching datasets: ${e.message}');
      rethrow;
    }
  }

  /// Check backend health
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('$baseUrl/health');
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('Health check failed: ${e.message}');
      return false;
    }
  }

  String get baseUrl => ApiConfig.baseUrl;
}
