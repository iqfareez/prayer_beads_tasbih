import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';
import 'package:vibration/vibration.dart';

import '../../../constants.dart';

class MyCounter {
  // Main signal for tracking total bead count
  final totalCount = signal<int>(0);
  // Computed signals for derived values
  late final beadCount = computed<int>(() {
    // If total count is 0, return 0 for bead count
    if (totalCount.value == 0) return 0;

    final currentBeadInRound = totalCount.value % _maxBeadsPerRound;
    return currentBeadInRound == 0 ? _maxBeadsPerRound : currentBeadInRound;
  });

  late final roundCount = computed<int>(() {
    return (totalCount.value / _maxBeadsPerRound).floor();
  });

  late final accumulatedCount = computed<int>(() => totalCount.value);

  final int _maxBeadsPerRound = 33;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  bool _canVibrate = true;

  MyCounter() {
    _initVibration();
  }

  Future<void> _initVibration() async {
    _canVibrate = await Vibration.hasVibrator();
  }

  Future<void> loadData() async {
    final storedTotalCount = await _prefs.getInt(kSpBeadsCount);
    totalCount.value = storedTotalCount ?? 0;
  }

  int increment() {
    totalCount.value++;

    // Check if we completed a round - this happens when beadCount is 33 (last bead in round)
    // Since beadCount is now a computed property, we need to check after incrementing
    if (beadCount.peek() == _maxBeadsPerRound) {
      // Just completed a round
      if (_canVibrate) {
        // TODO: Add different vibration patterns
        Vibration.vibrate(duration: 100, amplitude: 100);
      }
    }

    // Save to storage
    _saveData();

    return totalCount.value;
  }

  void decrement() {
    if (totalCount.value > 0) {
      totalCount.value--;
      _saveData();
    }
  }

  Future<void> reset() async {
    totalCount.value = 0;
    await _prefs.remove(kSpBeadsCount);
  }

  Future<void> _saveData() async {
    await _prefs.setInt(kSpBeadsCount, totalCount.value);
  }
}
