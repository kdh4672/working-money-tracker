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
  bool deductLunchTime;

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
    this.deductLunchTime = false,
  });

  double get perSecondIncome => hourlyWage / 3600;

  double get calculatedHourlyWage {
    if (inputMode == InputMode.salary && monthlySalary > 0 && monthlyHours > 0) {
      return (monthlySalary * 10000) / monthlyHours; // 만원을 원으로 변환
    }
    return hourlyWage;
  }

  Duration get elapsedTime {
    if (workStartTime == null) return Duration.zero;
    
    final now = DateTime.now();
    final endTime = isWorkFinished ? workEndTime! : now;
    return endTime.difference(workStartTime!);
  }

  void start() {
    if (calculatedHourlyWage <= 0) return;
    
    final now = DateTime.now();
    
    // workStartTime이 설정되지 않았으면 현재 시간으로 설정
    if (workStartTime == null) {
      workStartTime = now;
    }
    
    // 출근 시간이 현재 시간보다 이후라면 현재 시간으로 설정
    if (workStartTime!.isAfter(now)) {
      startTime = now;
      // workStartTime도 현재 시간으로 업데이트
      workStartTime = now;
    } else {
      startTime = workStartTime;
    }
    
    isRunning = true;
    isWorkFinished = false;
    
    // 시작할 때 이미 퇴근 시간이 지났는지 확인
    if (workEndTime != null && now.isAfter(workEndTime!)) {
      // 이미 퇴근 시간이 지났다면 즉시 완료 처리
      isWorkFinished = true;
      final workDurationSeconds = workEndTime!.difference(workStartTime!).inSeconds;
      final lunchDeductionSeconds = deductLunchTime ? 3600 : 0; // 1시간 = 3600초
      final actualWorkSeconds = workDurationSeconds - lunchDeductionSeconds;
      totalEarned = (calculatedHourlyWage * actualWorkSeconds) / 3600;
    } else {
      // 아직 퇴근 시간 전이라면, 이미 근무한 시간만큼 초기 금액 계산
      if (workStartTime!.isBefore(now)) {
        final alreadyWorkedSeconds = now.difference(workStartTime!).inSeconds;
        final lunchDeductionSeconds = deductLunchTime ? 3600 : 0; // 1시간 = 3600초
        final actualWorkSeconds = alreadyWorkedSeconds - lunchDeductionSeconds;
        totalEarned = (calculatedHourlyWage * actualWorkSeconds) / 3600;
      } else {
        totalEarned = 0;
      }
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
    deductLunchTime = false;
  }

  void updateEarnings() {
    if (!isRunning || workStartTime == null) return;
    
    final now = DateTime.now();
    
    // 퇴근 시간 체크
    if (workEndTime != null && now.isAfter(workEndTime!) && !isWorkFinished) {
      isWorkFinished = true;
      final workDurationSeconds = workEndTime!.difference(workStartTime!).inSeconds;
      final lunchDeductionSeconds = deductLunchTime ? 3600 : 0; // 1시간 = 3600초
      final actualWorkSeconds = workDurationSeconds - lunchDeductionSeconds;
      totalEarned = (calculatedHourlyWage * actualWorkSeconds) / 3600;
      return;
    }
    
    if (!isWorkFinished) {
      // 아직 퇴근 시간 전이면 실시간 계산 (출근시간부터 현재까지)
      final elapsedSeconds = now.difference(workStartTime!).inSeconds;
      final lunchDeductionSeconds = deductLunchTime ? 3600 : 0; // 1시간 = 3600초
      final actualWorkSeconds = elapsedSeconds - lunchDeductionSeconds;
      totalEarned = (calculatedHourlyWage * actualWorkSeconds) / 3600;
    } else {
      // 퇴근 후에는 고정된 값 유지
      final workDurationSeconds = workEndTime!.difference(workStartTime!).inSeconds;
      final lunchDeductionSeconds = deductLunchTime ? 3600 : 0; // 1시간 = 3600초
      final actualWorkSeconds = workDurationSeconds - lunchDeductionSeconds;
      totalEarned = (calculatedHourlyWage * actualWorkSeconds) / 3600;
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
      'deductLunchTime': deductLunchTime,
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
      deductLunchTime: json['deductLunchTime'] ?? false,
    );
  }
}

enum InputMode {
  hourly,
  salary,
}