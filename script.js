class IncomeTracker {
    constructor() {
        this.hourlyWage = 0;
        this.startTime = null;
        this.isRunning = false;
        this.animationId = null;
        this.totalEarned = 0;
        this.lastUpdateTime = null;
        this.inputMode = 'hourly'; // 'hourly' or 'salary'
        this.isWorkFinished = false;
        this.workEndTime = null;
        
        this.initElements();
        this.bindEvents();
        this.updatePerSecondIncome();
        this.checkUrlParams();
        this.initWidgetMode();
    }

    initElements() {
        this.hourlyWageInput = document.getElementById('hourlyWage');
        this.monthlySalaryInput = document.getElementById('monthlySalary');
        this.monthlyHoursInput = document.getElementById('monthlyHours');
        this.workStartTimeInput = document.getElementById('workStartTime');
        this.workEndTimeInput = document.getElementById('workEndTime');
        this.startBtn = document.getElementById('startBtn');
        this.stopBtn = document.getElementById('stopBtn');
        this.resetBtn = document.getElementById('resetBtn');
        this.incomeAmount = document.getElementById('incomeAmount');
        this.perSecondIncome = document.getElementById('perSecondIncome');
        this.elapsedTime = document.getElementById('elapsedTime');
        this.displayHourlyWage = document.getElementById('displayHourlyWage');
        this.widgetModeBtn = document.getElementById('widgetModeBtn');
        this.widgetExitBtn = document.getElementById('widgetExitBtn');
        
        // 모드 전환 관련 요소들
        this.hourlyModeBtn = document.getElementById('hourlyModeBtn');
        this.salaryModeBtn = document.getElementById('salaryModeBtn');
        this.hourlyModeDiv = document.getElementById('hourlyMode');
        this.salaryModeDiv = document.getElementById('salaryMode');
        
        // 퇴근 메시지 관련 요소들
        this.incomeDisplay = document.getElementById('incomeDisplay');
        this.workingContent = document.getElementById('workingContent');
        this.celebrationContent = document.getElementById('celebrationContent');
        this.totalDailyEarning = document.getElementById('totalDailyEarning');
        
        // 계산된 시급 표시 요소들
        this.calculatedHourlyWage = document.getElementById('calculatedHourlyWage');
        this.calculatedHourlyValue = document.getElementById('calculatedHourlyValue');
        
        // 초기 상태에서 수익 표시 숨기기
        this.updateIncomeDisplayVisibility();
    }

    bindEvents() {
        this.startBtn.addEventListener('click', () => this.start());
        this.stopBtn.addEventListener('click', () => this.stop());
        this.resetBtn.addEventListener('click', () => this.reset());
        
        // 모드 전환 이벤트
        this.hourlyModeBtn.addEventListener('click', () => this.switchMode('hourly'));
        this.salaryModeBtn.addEventListener('click', () => this.switchMode('salary'));
        
        // 시급 입력 이벤트
        this.hourlyWageInput.addEventListener('input', () => {
            if (this.inputMode === 'hourly') {
                this.updatePerSecondIncome();
                this.updateDisplayHourlyWage();
                this.updateIncomeDisplayVisibility();
            }
        });
        
        this.hourlyWageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.start();
            }
        });
        
        // 월급 입력 이벤트
        this.monthlySalaryInput.addEventListener('input', () => {
            if (this.inputMode === 'salary') {
                this.calculateHourlyWageFromSalary();
                this.updateIncomeDisplayVisibility();
            }
        });
        
        this.monthlyHoursInput.addEventListener('input', () => {
            if (this.inputMode === 'salary') {
                this.calculateHourlyWageFromSalary();
                this.updateIncomeDisplayVisibility();
            }
        });
        
        this.monthlySalaryInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.start();
            }
        });
    }

    switchMode(mode) {
        this.inputMode = mode;
        
        if (mode === 'hourly') {
            this.hourlyModeBtn.classList.add('active');
            this.salaryModeBtn.classList.remove('active');
            this.hourlyModeDiv.classList.remove('hidden');
            this.salaryModeDiv.classList.add('hidden');
            this.calculatedHourlyWage.style.display = 'none'; // 시급 모드에서는 계산된 시급 숨기기
            this.updatePerSecondIncome();
            this.updateDisplayHourlyWage();
            this.updateIncomeDisplayVisibility();
            this.hourlyWageInput.focus();
        } else {
            this.salaryModeBtn.classList.add('active');
            this.hourlyModeBtn.classList.remove('active');
            this.salaryModeDiv.classList.remove('hidden');
            this.hourlyModeDiv.classList.add('hidden');
            this.calculateHourlyWageFromSalary();
            this.updateIncomeDisplayVisibility();
            this.monthlySalaryInput.focus();
        }
    }

    calculateHourlyWageFromSalary() {
        const salaryInManwon = parseFloat(this.monthlySalaryInput.value) || 0;
        const salary = salaryInManwon * 10000; // 만원을 원으로 변환
        const hours = parseFloat(this.monthlyHoursInput.value) || 176;
        
        const calculatedHourlyWage = salary / hours;
        this.hourlyWageInput.value = Math.round(calculatedHourlyWage);
        
        // 계산된 시급 표시
        if (salaryInManwon > 0) {
            this.calculatedHourlyValue.textContent = '₩' + this.formatNumber(calculatedHourlyWage);
            this.calculatedHourlyWage.style.display = 'block';
        } else {
            this.calculatedHourlyWage.style.display = 'none';
        }
        
        this.updatePerSecondIncome();
        this.updateDisplayHourlyWage();
    }

    updatePerSecondIncome() {
        const wage = this.getCurrentHourlyWage();
        const perSecond = wage / 3600;
        this.perSecondIncome.textContent = this.formatNumber(perSecond);
    }

    updateDisplayHourlyWage() {
        const wage = this.getCurrentHourlyWage();
        this.displayHourlyWage.textContent = '₩' + this.formatNumber(wage);
    }

    updateIncomeDisplayVisibility() {
        const wage = this.getCurrentHourlyWage();
        if (wage > 0 && !this.isRunning) {
            // 시급이 있고 아직 시작하지 않은 상태에서는 일과 중 UI 표시
            this.incomeDisplay.style.display = 'block';
            this.displayHourlyWage.parentElement.style.display = 'block';
            this.showWorkingUI();
        } else if (wage <= 0) {
            this.incomeDisplay.style.display = 'none';
            this.displayHourlyWage.parentElement.style.display = 'none';
        }
        // isRunning이 true일 때는 animate()에서 처리
    }

    getCurrentHourlyWage() {
        if (this.inputMode === 'hourly') {
            return parseFloat(this.hourlyWageInput.value) || 0;
        } else {
            const salaryInManwon = parseFloat(this.monthlySalaryInput.value) || 0;
            const salary = salaryInManwon * 10000; // 만원을 원으로 변환
            const hours = parseFloat(this.monthlyHoursInput.value) || 176;
            return salary / hours;
        }
    }

    start() {
        const wage = this.getCurrentHourlyWage();
        
        if (!wage || wage <= 0) {
            if (this.inputMode === 'hourly') {
                alert('유효한 시급을 입력해주세요!');
                this.hourlyWageInput.focus();
            } else {
                alert('유효한 월급과 근무시간을 입력해주세요!');
                this.monthlySalaryInput.focus();
            }
            return;
        }
        
        this.hourlyWage = wage;
        this.isWorkFinished = false;
        
        // 출근 시간을 기준으로 시작 시간 계산
        const now = new Date();
        const workStartTime = this.parseTimeInput(this.workStartTimeInput.value);
        const workEndTime = this.parseTimeInput(this.workEndTimeInput.value);
        
        const workStart = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 
                                   workStartTime.hours, workStartTime.minutes, 0);
        const workEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 
                                 workEndTime.hours, workEndTime.minutes, 0);
        
        // 만약 현재 시간이 출근 시간보다 이전이면, 출근 시간을 현재 시간으로 설정
        if (now < workStart) {
            this.workStartTime = now.getTime();
        } else {
            this.workStartTime = workStart.getTime();
        }
        
        this.workEndTime = workEnd.getTime();
        this.startTime = this.workStartTime;
        this.lastUpdateTime = performance.now();
        this.isRunning = true;
        this.totalEarned = 0;
        
        // UI 초기화 (퇴근 메시지 숨기기)
        this.showWorkingUI();
        
        this.startBtn.disabled = true;
        this.stopBtn.disabled = false;
        this.hourlyWageInput.disabled = true;
        this.monthlySalaryInput.disabled = true;
        this.monthlyHoursInput.disabled = true;
        this.workStartTimeInput.disabled = true;
        this.workEndTimeInput.disabled = true;
        this.hourlyModeBtn.disabled = true;
        this.salaryModeBtn.disabled = true;
        
        // 화면이 꺼지지 않도록 설정
        this.keepScreenAwake();
        
        this.animate();
    }

    stop() {
        this.isRunning = false;
        
        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
            this.animationId = null;
        }
        
        // 화면 깨우기 해제
        this.releaseScreenWake();
        
        this.startBtn.disabled = false;
        this.stopBtn.disabled = true;
        this.hourlyWageInput.disabled = false;
        this.monthlySalaryInput.disabled = false;
        this.monthlyHoursInput.disabled = false;
        this.workStartTimeInput.disabled = false;
        this.workEndTimeInput.disabled = false;
        this.hourlyModeBtn.disabled = false;
        this.salaryModeBtn.disabled = false;
    }

    reset() {
        this.stop();
        this.totalEarned = 0;
        this.startTime = null;
        this.lastUpdateTime = null;
        this.isWorkFinished = false;
        this.workEndTime = null;
        
        // UI 초기화
        this.showWorkingUI();
        this.incomeAmount.textContent = '₩0';
        this.elapsedTime.textContent = '00:00:00';
        
        // 현재 모드에 따라 적절한 필드 초기화
        if (this.inputMode === 'hourly') {
            this.hourlyWageInput.value = '';
            this.hourlyWageInput.disabled = false;
            this.calculatedHourlyWage.style.display = 'none';
            this.hourlyWageInput.focus();
        } else {
            this.monthlySalaryInput.value = '';
            this.monthlyHoursInput.value = '176';
            this.hourlyWageInput.value = '';
            this.calculatedHourlyWage.style.display = 'none';
            this.monthlySalaryInput.disabled = false;
            this.monthlyHoursInput.disabled = false;
            this.monthlySalaryInput.focus();
        }
        
        this.hourlyModeBtn.disabled = false;
        this.salaryModeBtn.disabled = false;
        this.workStartTimeInput.disabled = false;
        this.workEndTimeInput.disabled = false;
        
        this.updatePerSecondIncome();
        this.updateDisplayHourlyWage();
        this.updateIncomeDisplayVisibility();
    }

    parseTimeInput(timeString) {
        const [hours, minutes] = timeString.split(':').map(Number);
        return { hours, minutes };
    }

    showWorkingUI() {
        this.incomeDisplay.classList.remove('celebration');
        this.workingContent.classList.remove('hidden');
        this.celebrationContent.classList.add('hidden');
    }

    showEndOfWorkUI() {
        this.incomeDisplay.classList.add('celebration');
        this.workingContent.classList.add('hidden');
        this.celebrationContent.classList.remove('hidden');
        this.totalDailyEarning.textContent = '₩' + this.formatNumber(this.totalEarned);
    }

    animate() {
        if (!this.isRunning) return;
        
        // 현재 시간과 출근 시간의 차이를 계산 (실제 시간 기준)
        const now = Date.now();
        
        // 퇴근 시간이 지났는지 확인
        if (now >= this.workEndTime && !this.isWorkFinished) {
            this.isWorkFinished = true;
            // 퇴근 시간까지의 수익만 계산
            const workDurationMs = this.workEndTime - this.workStartTime;
            const workDurationSeconds = workDurationMs / 1000;
            this.totalEarned = (this.hourlyWage * workDurationSeconds) / 3600;
            this.showEndOfWorkUI();
        }
        
        if (!this.isWorkFinished) {
            // 아직 퇴근 시간 전이면 실시간 계산
            const elapsedRealMs = now - this.workStartTime;
            const elapsedRealSeconds = elapsedRealMs / 1000;
            this.totalEarned = (this.hourlyWage * elapsedRealSeconds) / 3600;
            this.updateDisplay(elapsedRealMs);
        } else {
            // 퇴근 후에는 고정된 값만 표시
            const workDurationMs = this.workEndTime - this.workStartTime;
            this.updateDisplay(workDurationMs);
        }
        
        this.lastUpdateTime = performance.now();
        this.animationId = requestAnimationFrame(() => this.animate());
    }

    updateDisplay(elapsedMs) {
        this.incomeAmount.textContent = '₩' + this.formatNumber(this.totalEarned);
        
        this.incomeAmount.classList.add('updating');
        setTimeout(() => {
            this.incomeAmount.classList.remove('updating');
        }, 16);
        
        this.elapsedTime.textContent = this.formatTime(Math.floor(elapsedMs / 1000));
    }

    formatNumber(num) {
        return Math.round(parseFloat(num)).toLocaleString('ko-KR');
    }

    formatTime(totalSeconds) {
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;
        
        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }

    checkUrlParams() {
        const urlParams = new URLSearchParams(window.location.search);
        const wage = urlParams.get('wage');
        const autostart = urlParams.get('autostart');
        
        if (wage) {
            this.hourlyWageInput.value = wage;
            this.updatePerSecondIncome();
            this.updateDisplayHourlyWage();
            
            if (autostart === 'true') {
                setTimeout(() => {
                    this.start();
                }, 500);
            }
        }
    }

    // 화면이 꺼지지 않도록 유지
    async keepScreenAwake() {
        if ('wakeLock' in navigator) {
            try {
                this.wakeLock = await navigator.wakeLock.request('screen');
                console.log('화면 깨우기 활성화');
            } catch (err) {
                console.log('Wake Lock 지원하지 않음:', err);
            }
        }
    }

    // 화면 깨우기 해제
    releaseScreenWake() {
        if (this.wakeLock) {
            this.wakeLock.release();
            this.wakeLock = null;
            console.log('화면 깨우기 해제');
        }
    }

    // 위젯 모드 초기화
    initWidgetMode() {
        if (this.widgetModeBtn) {
            this.widgetModeBtn.addEventListener('click', () => {
                this.toggleWidgetMode();
            });
        }
        
        if (this.widgetExitBtn) {
            this.widgetExitBtn.addEventListener('click', () => {
                this.exitWidgetMode();
            });
        }
    }

    // 위젯 모드 토글
    toggleWidgetMode() {
        document.body.classList.toggle('widget-mode');
        
        if (document.body.classList.contains('widget-mode')) {
            this.widgetModeBtn.textContent = '📱 일반 모드';
            // 전체화면 요청
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
            }
        } else {
            this.widgetModeBtn.textContent = '📱 위젯 모드';
            // 전체화면 해제
            if (document.exitFullscreen) {
                document.exitFullscreen();
            }
        }
    }

    // 위젯 모드 종료
    exitWidgetMode() {
        document.body.classList.remove('widget-mode');
        this.widgetModeBtn.textContent = '📱 위젯 모드';
        
        // 전체화면 해제
        if (document.exitFullscreen) {
            document.exitFullscreen();
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Register service worker for PWA functionality
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('./sw.js')
            .then((registration) => {
                console.log('SW registered: ', registration);
            })
            .catch((registrationError) => {
                console.log('SW registration failed: ', registrationError);
            });
    }
    
    new IncomeTracker();
    
    const container = document.querySelector('.container');
    container.style.opacity = '0';
    container.style.transform = 'translateY(30px)';
    
    setTimeout(() => {
        container.style.transition = 'all 0.6s ease-out';
        container.style.opacity = '1';
        container.style.transform = 'translateY(0)';
    }, 100);
    
    document.getElementById('hourlyWage').focus();
});