class IncomeTracker {
  double hourlyWage;
  DateTime? startTime;
  DateTime? workStartTime;
  DateTime? workEndTime;
  bool isRunning;
  bool isWorkFinished;
  double totalEarned;
  InputMode inputMode;
  double monthlySalary;
  double monthlyHours;

  IncomeTracker({
    this.hourlyWage = 0,
    this.startTime,
    this.workStartTime,
    this.workEndTime,
    this.isRunning = false,
    this.isWorkFinished = false,
    this.totalEarned = 0,
    this.inputMode = InputMode.hourly,
    this.monthlySalary = 0,
    this.monthlyHours = 176,
  });

  double get perSecondIncome => hourlyWage / 3600;

  double get calculatedHourlyWage {
    if (inputMode == InputMode.salary && monthlySalary > 0 && monthlyHours > 0) {
      return (monthlySalary * 10000) / monthlyHours; // 만원을 원으로 변환
    }
    return hourlyWage;
  }

  Duration get elapsedTime {
    if (startTime == null) return Duration.zero;
    
    final now = DateTime.now();
    final endTime = isWorkFinished ? workEndTime! : now;
    return endTime.difference(startTime!);
  }

  void start() {
    if (calculatedHourlyWage <= 0) return;
    
    final now = DateTime.now();
    
    // 출근 시간이 현재 시간보다 이후라면 현재 시간으로 설정
    if (workStartTime != null && workStartTime!.isAfter(now)) {
      startTime = now;
    } else {
      startTime = workStartTime ?? now;
    }
    
    isRunning = true;
    isWorkFinished = false;
    totalEarned = 0;
    
    // 시작할 때 이미 퇴근 시간이 지났는지 확인
    if (workEndTime != null && now.isAfter(workEndTime!)) {
      _finishWork();
    }
  }

  void stop() {
    isRunning = false;
  }

  void reset() {
    startTime = null;
    isRunning = false;
    isWorkFinished = false;
    totalEarned = 0;
    hourlyWage = 0;
    monthlySalary = 0;
    monthlyHours = 176;
  }

  void updateEarnings() {
    if (!isRunning || startTime == null) return;
    
    final now = DateTime.now();
    
    // 퇴근 시간 체크
    if (workEndTime != null && now.isAfter(workEndTime!) && !isWorkFinished) {
      _finishWork();
      return;
    }
    
    final endTime = isWorkFinished ? workEndTime! : now;
    final elapsedSeconds = endTime.difference(startTime!).inSeconds;
    totalEarned = (calculatedHourlyWage * elapsedSeconds) / 3600;
  }

  void _finishWork() {
    isWorkFinished = true;
    if (workEndTime != null && startTime != null) {
      final workDuration = workEndTime!.difference(startTime!).inSeconds;
      totalEarned = (calculatedHourlyWage * workDuration) / 3600;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'hourlyWage': hourlyWage,
      'startTime': startTime?.millisecondsSinceEpoch,
      'workStartTime': workStartTime?.millisecondsSinceEpoch,
      'workEndTime': workEndTime?.millisecondsSinceEpoch,
      'isRunning': isRunning,
      'isWorkFinished': isWorkFinished,
      'totalEarned': totalEarned,
      'inputMode': inputMode.index,
      'monthlySalary': monthlySalary,
      'monthlyHours': monthlyHours,
    };
  }

  factory IncomeTracker.fromJson(Map<String, dynamic> json) {
    return IncomeTracker(
      hourlyWage: json['hourlyWage']?.toDouble() ?? 0,
      startTime: json['startTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['startTime'])
          : null,
      workStartTime: json['workStartTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['workStartTime'])
          : null,
      workEndTime: json['workEndTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['workEndTime'])
          : null,
      isRunning: json['isRunning'] ?? false,
      isWorkFinished: json['isWorkFinished'] ?? false,
      totalEarned: json['totalEarned']?.toDouble() ?? 0,
      inputMode: InputMode.values[json['inputMode'] ?? 0],
      monthlySalary: json['monthlySalary']?.toDouble() ?? 0,
      monthlyHours: json['monthlyHours']?.toDouble() ?? 176,
    );
  }
}

enum InputMode {
  hourly,
  salary,
}