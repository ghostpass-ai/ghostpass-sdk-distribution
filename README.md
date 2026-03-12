# GhostPass SDK — Distribution Repository

**지원 플랫폼**
| 플랫폼 | 최소 버전 |
|------|------|
| iOS | 15.0+ |
| Android | 지원 예정 |

**배포 방식**
| 플랫폼 | 최소 버전 |
|------|------|
| iOS | SPM (Swift Package Manager) · CocoaPods |
| Android | 지원 예정 |

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

## 서비스 이용 방법 (공통)

### 1. 유저앱

**1.1. 저장소 접근 권한 요청**

GhostPass 담당자에게 아래 정보를 전달해 주세요.

- GitHub 계정 이메일 (또는 username)
- 회사명 / 서비스명 / Bundle ID
- 담당자 이메일

**1.2. API Key 발급**

GhostPass 담당자에게 서비스 등록을 요청하면 **API Key**를 발급해 드립니다.

### 2. 키오스크

---

## iOS 설치
> iOS는 현재 유저앱 SDK만 제공됩니다.

### Swift Package Manager (SPM)

**1.** Xcode → **File → Add Package Dependencies...**

**2.** 검색창에 아래 URL을 입력합니다.

```
https://github.com/ghostpass-ai/ghostpass-sdk-distribution
```

**3.** 버전 규칙을 선택하고 **Add Package** 를 클릭합니다.

**4.** `GoPassSDK` 라이브러리를 앱 타깃에 추가합니다.

---

### CocoaPods

**1.** `Podfile` 에 아래 내용을 추가합니다.

```ruby
target 'YourApp' do
use_frameworks!
pod 'GoPassSDK', '~> {VERSION}'
end
```

**2.** 터미널에서 설치합니다.

```bash
pod install
```

**3.** 이후 `.xcworkspace` 파일로 프로젝트를 엽니다.

**4.** Xcode → **Target → Build Settings → Other Linker Flags** 에 `$(inherited)` 가 포함되어 있는지 확인합니다.
> `$(inherited)` 가 없으면 CocoaPods 의존성이 링커에 정상적으로 전달되지 않아 빌드 에러가 발생할 수 있습니다.

---

## iOS 사용 방법
[연동 가이드]([docs/integration_guide_kr.md](https://github.com/ghostpass-ai/ghostpass-sdk-distribution/blob/main/docs/userApp_integration_guide_kr.md))를 참고해주세요.

---

## Android 설치

---

## 문서

| 문서 | 내용 |
|------|------|
| [연동 가이드](docs/userApp_integration_guide.md) | 설치, 초기화, 얼굴 등록·인증, API Reference |
| [에러 코드](docs/error_codes.md) | 에러 타입별 설명 및 처리 방법 |

---

## 지원

연동 문의 및 기술 지원: **sdk-support@ghostpass.ai**
