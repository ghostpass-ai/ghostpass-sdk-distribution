# GhostPass SDK — Distribution Repository

> **지원 플랫폼** iOS 14.0+ · Android (지원 예정)  
> **배포 방식** Private GitHub Repository

이 저장소는 **GhostPass 파트너사**에 한해 접근이 허용된 비공개 배포 저장소입니다.

---

## 저장소 구조

```
ghostpass-sdk-distribution/
├── docs/
│   ├── integration_guide_kr.md   # iOS SDK 연동 가이드 (한국어)
│   └── error_codes.md            # 에러 코드 목록 및 처리 방법
├── ios/
│   ├── frameworks/               # GoPassSDK.xcframework
│   └── sample-app/               # 연동 샘플 Xcode 프로젝트
├── android/                      # 추후 제공 예정
└── LICENSE
```

---

## 빠른 시작 (iOS)

### 1. 저장소 접근 권한 요청

GhostPass 담당자에게 아래 정보를 전달하여 GitHub 초대를 요청하세요.

- GitHub 계정 이메일 (또는 username)
- 회사명 / 서비스명 / Bundle ID
- 담당자 이메일

### 2. SDK 설치 (Swift Package Manager)

1. Xcode → **File → Add Package Dependencies...**
2. URL 입력:

```
https://github.com/ghostpass-ai/ghostpass-sdk-distribution
```

3. `GoPassSDK` 라이브러리를 앱 타깃에 추가

### 3. API Key 발급

GhostPass 담당자에게 서비스 등록을 요청하면 **API Key**를 발급해 드립니다.

### 4. SDK 초기화

```swift
import GoPassSDK

GPSDK.shared.gpInit(apiKey: "YOUR_API_KEY") { result in
    switch result {
    case .success: print("✅ SDK 준비 완료")
    case .failure(let error): print("❌ \(error.errorDescription ?? "")")
    }
}
```

### 5. 얼굴 등록

```swift
GPSDK.shared.gpSaveLandmark(image: cameraImage) { result in
    switch result {
    case .success: print("✅ 얼굴 등록 완료")
    case .failure(let error): print("❌ \(error.localizedDescription)")
    }
}
```

그 이후의 **인증은 SDK가 자동으로 처리**합니다.  
키오스크 비콘 감지 시 자동으로 인증 세션이 수립되고, 결과는 `delegate` 콜백으로 전달됩니다.

---

## 문서

| 문서 | 내용 |
|------|------|
| [연동 가이드](docs/integration_guide_kr.md) | 설치, 초기화, 얼굴 등록·인증, API Reference |
| [에러 코드](docs/error_codes.md) | 에러 타입별 설명 및 처리 방법 |

---

## 지원

연동 문의 및 기술 지원: **sdk-support@ghostpass.ai**
