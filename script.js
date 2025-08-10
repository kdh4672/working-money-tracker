class IncomeTracker {
    constructor() {
        this.hourlyWage = 0;
        this.startTime = null;
        this.isRunning = false;
        this.animationId = null;
        this.totalEarned = 0;
        this.lastUpdateTime = null;
        
        this.initElements();
        this.bindEvents();
        this.updatePerSecondIncome();
    }

    initElements() {
        this.hourlyWageInput = document.getElementById('hourlyWage');
        this.startBtn = document.getElementById('startBtn');
        this.stopBtn = document.getElementById('stopBtn');
        this.resetBtn = document.getElementById('resetBtn');
        this.incomeAmount = document.getElementById('incomeAmount');
        this.perSecondIncome = document.getElementById('perSecondIncome');
        this.elapsedTime = document.getElementById('elapsedTime');
        this.displayHourlyWage = document.getElementById('displayHourlyWage');
    }

    bindEvents() {
        this.startBtn.addEventListener('click', () => this.start());
        this.stopBtn.addEventListener('click', () => this.stop());
        this.resetBtn.addEventListener('click', () => this.reset());
        
        this.hourlyWageInput.addEventListener('input', () => {
            this.updatePerSecondIncome();
            this.updateDisplayHourlyWage();
        });
        
        this.hourlyWageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.start();
            }
        });
    }

    updatePerSecondIncome() {
        const wage = parseFloat(this.hourlyWageInput.value) || 0;
        const perSecond = wage / 3600;
        this.perSecondIncome.textContent = this.formatNumber(perSecond);
    }

    updateDisplayHourlyWage() {
        const wage = parseFloat(this.hourlyWageInput.value) || 0;
        this.displayHourlyWage.textContent = '₩' + this.formatNumber(wage);
    }

    start() {
        const wage = parseFloat(this.hourlyWageInput.value);
        
        if (!wage || wage <= 0) {
            alert('유효한 시급을 입력해주세요!');
            this.hourlyWageInput.focus();
            return;
        }
        
        this.hourlyWage = wage;
        this.startTime = performance.now();
        this.lastUpdateTime = this.startTime;
        this.isRunning = true;
        this.totalEarned = 0;
        
        this.startBtn.disabled = true;
        this.stopBtn.disabled = false;
        this.hourlyWageInput.disabled = true;
        
        this.animate();
    }

    stop() {
        this.isRunning = false;
        
        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
            this.animationId = null;
        }
        
        this.startBtn.disabled = false;
        this.stopBtn.disabled = true;
        this.hourlyWageInput.disabled = false;
    }

    reset() {
        this.stop();
        this.totalEarned = 0;
        this.startTime = null;
        this.lastUpdateTime = null;
        
        this.incomeAmount.textContent = '₩0';
        this.elapsedTime.textContent = '00:00:00';
        
        this.hourlyWageInput.value = '';
        this.hourlyWageInput.disabled = false;
        this.hourlyWageInput.focus();
        
        this.updatePerSecondIncome();
        this.updateDisplayHourlyWage();
    }

    animate() {
        if (!this.isRunning) return;
        
        const currentTime = performance.now();
        const elapsedMs = currentTime - this.startTime;
        const elapsedSeconds = elapsedMs / 1000;
        
        this.totalEarned = (this.hourlyWage * elapsedSeconds) / 3600;
        
        this.updateDisplay(elapsedMs);
        
        this.lastUpdateTime = currentTime;
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