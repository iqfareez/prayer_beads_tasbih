import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';
import 'package:vibration/vibration.dart';

import '../../../constants.dart';

class MyCounter {
  static final MyCounter globalInstance = MyCounter._internal();
  // Main signal for tracking total bead count
  final totalCount = signal<int>(0);
  // Signal for round count (beads per round)
  final roundSize = signal<int>(33);
  // Computed signals for derived values
  late final beadCount = computed<int>(() {
    // If total count is 0, return 0 for bead count
    if (totalCount.value == 0) return 0;
    final currentBeadInRound = totalCount.value % roundSize.value;
    return currentBeadInRound == 0 ? roundSize.value : currentBeadInRound;
  });

  late final roundCount = computed<int>(() {
    return (totalCount.value / roundSize.value).floor();
  });

  late final accumulatedCount = computed<int>(() => totalCount.value);

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  bool _canVibrate = true;

  MyCounter._internal() {
    _initVibration();
  }

  factory MyCounter() => globalInstance;

  Future<void> _initVibration() async {
    _canVibrate = await Vibration.hasVibrator();
  }

  Future<void> loadData() async {
    final storedTotalCount = await _prefs.getInt(kSpBeadsCount);
    totalCount.value = storedTotalCount ?? 0;
    final storedRoundSize = await _prefs.getInt('round_size');
    if (storedRoundSize != null && storedRoundSize > 0) {
      roundSize.value = storedRoundSize;
    }
  }

  int increment() {
    totalCount.value++;
    if (beadCount.peek() == roundSize.value) {
      if (_canVibrate) {
        // TODO: Add different vibration patterns
        Vibration.vibrate(duration: 100, amplitude: 100);
      }
    }
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
    await _prefs.setInt('round_size', roundSize.value);
  }

  Future<void> setRoundSize(int newSize) async {
    if (newSize > 0) {
      roundSize.value = newSize;
      await _prefs.setInt('round_size', newSize);
    }
  }

  int get currentRoundSize => roundSize.value;
}
