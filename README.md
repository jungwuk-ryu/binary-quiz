# Binary Quiz

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
[![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/kr/app/binary-quiz/id6636496411)  

> 십진수↔이진수 변환 퀴즈를 풀면서 변환 실력을 향상하세요!

---

1. [주요 기능](#주요-기능)
2. [스크린샷](#스크린샷)
3. [시작하기](#시작하기)
   - [전제 조건](#전제-조건)
   - [설치](#설치)
   - [실행](#실행)
4. [App Store](#app-store)
5. [로드맵](#로드맵)
6. [기여하기](#기여하기)
7. [라이선스](#라이선스)

---

## 주요 기능

- **이진 ↔ 십진 변환 퀴즈**: 무작위 문제를 통해 양 방향 변환 연습
- **중복 방지 모드**: 매 문제마다 새로운 숫자 제시

---

## 스크린샷

| iPhone | iPad |
| :---: | :---: |
| ![iPhone 스크린샷](https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/19/17/77/19177720-7065-93e4-42a2-a77251b18126/77ae9fff-0afb-469e-abe7-52a120080d4a_simulator_screenshot_3651A8E5-0A43-4411-9F98-501758AD6015.png/157x0w.webp) | ![iPad 스크린샷](https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/d9/5a/ef/d95aefcf-54c4-a68f-6aea-1485dc2dff9b/a137bf3b-bfb3-4d37-bdcb-b826b0eccc74_Simulator_Screenshot_-_iPad_Air_13-inch__U0028M2_U0029_-_2024-08-15_at_15.59.47.png/217x0w.webp) |

---

## 시작하기

### 전제 조건

- Flutter 3.28
- iOS: Xcode 15 이상
- Android: Android SDK 35 이상

### 설치

```bash
# 저장소 클론
$ git clone https://github.com/jungwuk-ryu/binary-quiz.git
$ cd binary-quiz

# 의존성 설치
$ flutter pub get

# Firebase CLI 설치
curl -sL https://firebase.tools | bash

# Firebase 로그인
firebase login

# flutterfire_cli 설치
dart pub global activate flutterfire_cli

# 프로젝트 설정
flutterfire configure
```

이후, ADManager class의 적절한 자식 클래스를 작성하고, [main.dart#L23](https://github.com/jungwuk-ryu/binary-quiz/blob/25df6cacf260fdcd21cbae6f9bb5e9870cd9cb17/lib/main.dart#L23)을 수정합니다.

### 실행

```bash
# 디바이스 또는 에뮬레이터에서 실행
$ flutter run
```

> 웹 빌드를 테스트하려면 `flutter run -d chrome` 또는 `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080`

---

## App Store

Binary Quiz는 Apple App Store에서 다운로드할 수 있습니다.

[![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/kr/app/binary-quiz/id6636496411)

---

## 로드맵

- [ ] 프로젝트 리팩토링
- [ ] 리더보드 (Game Center / Google Play Games 연동)
- [ ] 시간 제한 모드
- [ ] 더 나은 디자인

아이디어나 PR 언제든 환영합니다! 이슈를 열어주세요.

---

## 기여하기

1. 프로젝트를 포크하세요.
2. 기능 브랜치 생성 (`git checkout -b feature/새기능`)
3. 변경사항 커밋 (`git commit -m '새 기능 추가'`)
4. 브랜치 푸시 (`git push origin feature/새기능`)
5. 풀 리퀘스트 열기

제출 전 `dart format` 및 `flutter analyze`를 실행해주세요.

---

## 라이선스

MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참조하세요.
