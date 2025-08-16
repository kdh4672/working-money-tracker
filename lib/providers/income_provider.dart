import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/income_tracker.dart';

class IncomeProvider extends ChangeNotifier {
  IncomeTracker _tracker = IncomeTracker();
  Timer? _timer;
  bool _isWidgetMode = false;

  IncomeTracker get tracker => _tracker;
  bool get isWidgetMode => _isWidgetMode;

  IncomeProvider() {
    _loadState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('income_tracker_state');
      if (jsonString != null) {
        final jsonData = jsonDecode(jsonString);
        _tracker = IncomeTracker.fromJson(jsonData);
        
        // 앱이 종료된 상태에서 재시작할 때 타이머 재개
        if (_tracker.isRunning) {
          _startTimer();
        }
      }
    } catch (e) {
      print('상태 로드 실패: $e');
    }
    notifyListeners();
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_tracker.toJson());
      await prefs.setString('income_tracker_state', jsonString);
    } catch (e) {
      print('상태 저장 실패: $e');
    }
  }

  void setInputMode(InputMode mode) {
    _tracker.inputMode = mode;
    notifyListeners();
    _saveState();
  }

  void setHourlyWage(double wage) {
    _tracker.hourlyWage = wage;
    notifyListeners();
    _saveState();
  }

  void setMonthlySalary(double salary) {
    _tracker.monthlySalary = salary;
    notifyListeners();
    _saveState();
  }

  void setMonthlyHours(double hours) {
    _tracker.monthlyHours = hours;
    notifyListeners();
    _saveState();
  }

  void setWorkStartTime(TimeOfDay time) {
    final now = DateTime.now();
    _tracker.workStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    notifyListeners();
    _saveState();
  }

  void setWorkEndTime(TimeOfDay time) {
    final now = DateTime.now();
    _tracker.workEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    notifyListeners();
    _saveState();
  }

  String? validateAndStart() {
    if (_tracker.calculatedHourlyWage <= 0) {
      if (_tracker.inputMode == InputMode.hourly) {
        return '유효한 시급을 입력해주세요!';
      } else {
        return '유효한 월급과 근무시간을 입력해주세요!';
      }
    }
    
    _tracker.start();
    _startTimer();
    notifyListeners();
    _saveState();
    return null;
  }

  void stop() {
    _tracker.stop();
    _timer?.cancel();
    notifyListeners();
    _saveState();
  }

  void reset() {
    _tracker.reset();
    _timer?.cancel();
    notifyListeners();
    _saveState();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tracker.updateEarnings();
      notifyListeners();
      
      // 백그라운드에서도 상태 유지를 위해 주기적으로 저장
      if (timer.tick % 30 == 0) { // 30초마다 저장
        _saveState();
      }
    });
  }

  void toggleWidgetMode() {
    _isWidgetMode = !_isWidgetMode;
    notifyListeners();
  }

  void exitWidgetMode() {
    _isWidgetMode = false;
    notifyListeners();
  }

  void toggleLunchTimeDeduction() {
    _tracker.deductLunchTime = !_tracker.deductLunchTime;
    // 실행 중이라면 즉시 수익 재계산
    if (_tracker.isRunning) {
      _tracker.updateEarnings();
    }
    notifyListeners();
    _saveState();
  }

  String formatCurrency(double amount) {
    return '₩${amount.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String formatTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}