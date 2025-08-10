# ⚡ 워킹 머니 트래커

**실시간으로 내가 버는 돈을 확인하며 동기부여 받는 PWA 앱**

[![Live Demo](https://img.shields.io/badge/Live-Demo-success)](https://kdh4672.github.io/working-money-tracker/)
[![PWA Ready](https://img.shields.io/badge/PWA-Ready-blue)](https://kdh4672.github.io/working-money-tracker/)

## 📱 앱 소개

직장인들이 업무를 하면서 실시간으로 자신이 벌고 있는 돈을 확인할 수 있는 동기부여 앱입니다.

### ✨ 주요 기능
- 💰 **실시간 수익 계산**: 시급을 입력하면 매 초마다 수익이 증가
- 📱 **PWA 앱 설치**: 홈 화면에 설치해서 네이티브 앱처럼 사용
- 🔄 **오프라인 지원**: 인터넷 없이도 사용 가능
- 💪 **동기부여 메시지**: "지금 이 순간에도 돈을 벌고 있다"는 긍정적 피드백
- ⚡ **부드러운 애니메이션**: 스무스한 카운터 증가 효과

## 🚀 사용 방법

### 웹에서 사용
1. [https://kdh4672.github.io/working-money-tracker/](https://kdh4672.github.io/working-money-tracker/) 접속
2. 시급 입력 후 "시작" 버튼 클릭
3. 실시간으로 수익 확인!

### iPhone에 앱 설치
1. Safari에서 위 링크 접속
2. 공유 버튼 🔗 터치
3. "홈 화면에 추가" 선택
4. "추가" 버튼 터치
5. 홈 화면에 "머니트래커" 앱 아이콘 생성!

## 🛠️ 기술 스택

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **PWA**: Service Worker, Web App Manifest
- **Design**: CSS Grid, Flexbox, Gradient UI
- **Deployment**: GitHub Pages

## 📊 개발일지

### 2025-08-10 (초기 개발)

#### 🎯 프로젝트 목표 설정
- **동기**: 직장인들이 업무 중 동기부여를 받을 수 있는 도구 필요
- **컨셉**: "지금 이 순간에도 돈을 벌고 있다"는 실시간 피드백
- **타겟**: 시급제/월급제 직장인, 프리랜서

#### 📋 1단계: 기본 기능 구현
```javascript
// 핵심 로직 - 실시간 수익 계산
animate() {
    const currentTime = performance.now();
    const elapsedSeconds = (currentTime - this.startTime) / 1000;
    this.totalEarned = (this.hourlyWage * elapsedSeconds) / 3600;
}
```

**구현 내용:**
- ✅ 시급 입력 기능
- ✅ 실시간 타이머 및 수익 계산
- ✅ 시작/정지/리셋 버튼
- ✅ 경과시간 표시

#### 🎨 2단계: UI/UX 개선
**문제점**: 기존 "실시간 수익 계산기"라는 이름이 딱딱함

**해결책**: 
- 앱명 변경: "워킹 머니 트래커"
- 메시지 개선: "지금 이 순간에도 당신은 돈을 벌고 있습니다"
- 색상 테마: 전문적이면서도 동기부여되는 블루 그라데이션

```css
/* 동기부여 UI 디자인 */
background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #667eea 100%);
```

#### 📱 3단계: PWA 변환
**목표**: iOS에서 네이티브 앱처럼 사용하고 싶다는 요청

**구현한 PWA 기능:**
```json
// manifest.json - 앱 메타데이터
{
  "name": "워킹 머니 트래커",
  "display": "standalone",
  "start_url": "./"
}
```

- ✅ Web App Manifest 생성
- ✅ Service Worker로 오프라인 지원
- ✅ iOS 전용 메타태그 추가
- ✅ 앱 아이콘 생성 (192px, 512px)

#### 🔧 4단계: 사용성 개선
**사용자 피드백**: 
1. "소수점이 너무 많아서 보기 힘들다"
2. "돈 올라가는 속도를 더 스무스하게 해달라"

**개선 사항:**
```javascript
// Before: 소수점 2자리
formatNumber(num) {
    return parseFloat(num).toLocaleString('ko-KR', {
        maximumFractionDigits: 2
    });
}

// After: 정수로만 표시
formatNumber(num) {
    return Math.round(parseFloat(num)).toLocaleString('ko-KR');
}
```

- ✅ 소수점 제거 → 정수로만 표시
- ✅ 업데이트 주기 단축: 50ms → 16ms (60fps)
- ✅ 애니메이션 강도 조절: scale(1.02) → scale(1.005)

#### 🚀 5단계: 배포
**GitHub Pages 배포 과정:**
1. 새로운 리포지토리 생성: `working-money-tracker`
2. 기존 git 설정 제거 후 새로 초기화
3. GitHub Pages 설정으로 자동 배포
4. HTTPS 환경에서 PWA 기능 정상 작동 확인

**최종 URL**: https://kdh4672.github.io/working-money-tracker/

## 💡 배운 점

### 기술적 학습
- **PWA 구현**: Service Worker와 Manifest 설정 방법
- **iOS PWA**: Safari에서의 PWA 설치 및 최적화
- **성능 최적화**: requestAnimationFrame을 활용한 부드러운 애니메이션
- **사용자 경험**: 피드백을 통한 실용적 개선

### 프로덕트 관점
- **사용자 중심 설계**: 개발자 관점이 아닌 실제 사용자 피드백 반영
- **동기부여 효과**: 단순한 계산기가 아닌 심리적 효과 고려
- **접근성**: PWA로 설치 장벽 낮추기

## 🔮 향후 개선 계획

### 단기 계획
- [ ] 다크 모드 지원
- [ ] 일/주/월별 누적 수익 통계
- [ ] 목표 수익 설정 기능
- [ ] 소리/진동 알림 옵션

### 장기 계획  
- [ ] 여러 수익원 관리 (투잡 등)
- [ ] 세금 계산기 연동
- [ ] 소셜 기능 (수익 공유)
- [ ] 데이터 백업/동기화

## 📞 피드백

버그 발견이나 개선 아이디어가 있으시면 언제든 Issue를 남겨주세요!

---

**Made with ❤️ for 직장인들의 동기부여**