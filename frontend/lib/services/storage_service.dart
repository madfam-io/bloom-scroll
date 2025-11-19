/// Local storage service for read state tracking (STORY-007)
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _readCountKey = 'bloom_read_count';
  static const String _lastResetDateKey = 'bloom_last_reset_date';
  static const String _readCardIdsKey = 'bloom_read_card_ids';

  late final SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the storage service (must be called before use)
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    _initialized = true;

    // Check if we need to reset daily counters
    await _checkAndResetDaily();
  }

  /// Check if we need to reset daily counters (new day)
  Future<void> _checkAndResetDaily() async {
    final lastResetDate = _prefs.getString(_lastResetDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

    if (lastResetDate != today) {
      // New day! Reset counters
      debugPrint('New day detected. Resetting read count.');
      await _prefs.setInt(_readCountKey, 0);
      await _prefs.setStringList(_readCardIdsKey, []);
      await _prefs.setString(_lastResetDateKey, today);
    }
  }

  /// Get current read count for today
  Future<int> getReadCount() async {
    await _checkAndResetDaily();
    return _prefs.getInt(_readCountKey) ?? 0;
  }

  /// Increment read count
  Future<void> incrementReadCount({int by = 1}) async {
    final current = await getReadCount();
    await _prefs.setInt(_readCountKey, current + by);
    debugPrint('Read count incremented to ${current + by}');
  }

  /// Get list of read card IDs for today
  Future<List<String>> getReadCardIds() async {
    await _checkAndResetDaily();
    return _prefs.getStringList(_readCardIdsKey) ?? [];
  }

  /// Mark a card as read
  Future<void> markCardAsRead(String cardId) async {
    final readIds = await getReadCardIds();
    if (!readIds.contains(cardId)) {
      readIds.add(cardId);
      await _prefs.setStringList(_readCardIdsKey, readIds);
      await incrementReadCount();
    }
  }

  /// Check if a card has been read today
  Future<bool> isCardRead(String cardId) async {
    final readIds = await getReadCardIds();
    return readIds.contains(cardId);
  }

  /// Clear all storage (for testing/debugging)
  Future<void> clearAll() async {
    await _prefs.clear();
    debugPrint('Storage cleared');
  }

  /// Get last reset date
  String? get lastResetDate => _prefs.getString(_lastResetDateKey);
}
