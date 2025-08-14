# 워킹 머니 트래커 (Flutter)

실시간으로 시간당 수익을 계산해주는 Flutter 모바일 앱입니다.

## 주요 기능

- **시급/월급 입력 모드**: 시급 직접 입력 또는 월급에서 시급 자동 계산
- **실시간 수익 계산**: 출근 시간부터 현재까지 누적 수익 실시간 표시
- **출퇴근 시간 설정**: 사용자 정의 근무 시간 설정
- **축하 메시지**: 퇴근 시간 도달 시 축하 메시지와 일일 총 수익 표시
- **위젯 모드**: 전체화면 위젯 모드로 실시간 수익 모니터링
- **데이터 자동 저장**: 앱 종료 후 재시작해도 상태 유지

## 설치 및 실행

### 필수 요구사항
- Flutter SDK 3.0.0 이상
- Dart SDK 3.0.0 이상
- Android Studio 또는 VS Code
- iOS 개발의 경우 Xcode

### 설치 방법

1. 프로젝트 클론
```bash
git clone <repository-url>
cd flutter_money_tracker
```

2. 종속성 설치
```bash
flutter pub get
```

3. 앱 실행
```bash
# Android
flutter run

# iOS
flutter run -d ios
```

### 빌드 방법

#### Android APK 빌드
```bash
flutter build apk --release
```

#### iOS 앱 빌드 (애플스토어 배포용)
```bash
flutter build ios --release
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/
│   └── income_tracker.dart   # 데이터 모델
├── providers/
│   └── income_provider.dart  # 상태 관리 (Provider)
├── screens/
│   └── home_screen.dart      # 메인 화면
└── widgets/
    ├── input_mode_toggle.dart    # 시급/월급 모드 토글
    ├── hourly_input.dart         # 시급 입력 위젯
    ├── salary_input.dart         # 월급 입력 위젯
    ├── work_time_section.dart    # 출퇴근 시간 설정
    ├── income_display.dart       # 수익 표시 위젯
    ├── control_buttons.dart      # 제어 버튼들
    └── stats_section.dart        # 통계 섹션
```

## 사용된 패키지

- `provider`: 상태 관리
- `shared_preferences`: 로컬 데이터 저장
- `intl`: 날짜/시간 포맷팅
- `wakelock`: 화면 깨우기 유지

## 애플스토어 배포 가이드

### 1. Apple Developer 계정 준비
- Apple Developer Program 가입 ($99/년)
- Xcode에서 Team 설정

### 2. 앱 아이콘 및 스플래시 준비
- 앱 아이콘: 1024x1024px PNG (투명 배경 불가)
- 다양한 디바이스용 아이콘 크기 준비

### 3. 빌드 및 업로드
```bash
# iOS 릴리즈 빌드
flutter build ios --release

# Xcode에서 Archive 생성 후 App Store Connect에 업로드
```

### 4. App Store Connect 설정
- 앱 정보, 스크린샷, 설명 등록
- 개인정보처리방침 URL 필요
- 연령 등급 설정

### 5. 심사 제출
- 앱 심사 가이드라인 준수 확인
- 테스트 계정 정보 제공 (필요시)

## 라이센스

MIT License

## 기여

버그 리포트나 기능 제안은 이슈로 등록해주세요.