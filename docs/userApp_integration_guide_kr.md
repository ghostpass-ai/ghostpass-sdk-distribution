# GhostPass SDK — 개발자 문서

> **버전** 1.0.0 · **지원 플랫폼** iOS 14.0+ · **배포 형식** XCFramework  
> **최종 업데이트** 2026년 2월 26일

---

## 목차

1. [개요](#1-개요)
2. [설치](#2-설치)
3. [사전 준비](#3-사전-준비)
4. [SDK 초기화](#4-sdk-초기화)
5. [얼굴 등록 (Enrollment)](#5-얼굴-등록)
6. [얼굴 인증 (Authentication)](#6-얼굴-인증)
7. [에러 처리](#7-에러-처리)
8. [FAQ](#8-faq)
9. [API Reference](#9-api-reference)

---

## 1. 개요

### 1.1 GhostPass SDK란?

GhostPass SDK는 iOS 앱에 **비접촉 안면 인식 인증**을 손쉽게 통합할 수 있는 보안 SDK입니다.  
Liveness Detection(위조 방지), 얼굴 특징 추출, 서버 연동을 모두 내부에서 처리하므로, 파트너 개발자가 직접 다뤄야 할 것은 **딱 3가지**입니다.

```
initialize(userOid:apiKey:)  →  registerBioData(imageBytes:)  →  (필요시) removeBioData()
```

### 1.2 주요 기능

| 기능 | 설명 |
|------|------|
| 안면 정보 등록 | 카메라 이미지로부터 안면 특징 벡터 추출 및 Keychain 저장 |
| Liveness Detection | BGR 기반 안티 스푸핑으로 사진·영상 위조 방지 |
| 안면 정보 인증 | 등록된 특징 벡터와 실시간 안면 정보 비교 |
| 보안 저장 | 모든 민감 데이터는 iOS Keychain에만 저장 |

### 1.3 동작 흐름

GhostPass SDK는 **API Key 한 줄**로 연동을 시작하며, 내부 보안 처리(기기 검증, 암호화, 인증 세션 관리)는 모두 SDK가 자동으로 수행합니다.

```
① 서비스 등록 (1회)
   GhostPass 담당자에게 Bundle ID 전달 → API Key 수령

② SDK 초기화 (앱 실행 시 1회)
   initialize(userOid:apiKey:) 호출 → SDK 내부 보안 채널 자동 수립

③ 얼굴 등록 (사용자당 1회)
   registerBioData(imageBytes:) 호출 → 안면 정보 추출 + Liveness 검사 + 특징 추출 + 안전 저장

④ 자동 인증 (키오스크 근접 시 자동 동작)
   키오스크 비콘 감지 → 인증 세션 수립 → 기기 내 얼굴 매칭
```

#### 파트너사에서 직접 구현할 것

| 단계 | 호출 | SDK 동작 |
|------|------|---------------|
| 초기화 | `initialize(userOid:apiKey:)` 1회 | 기기 검증 · 보안 채널 수립 · 내부 키 관리 |
| 안면 정보 등록 | `registerBioData(imageBytes:)` | 안면 정보 추출 · Liveness 검사 · 특징 추출 · 안전한 저장 |
| 안면 정보 삭제 | `removeBioData()` | 안면 정보 삭제 · 비콘 스캔 종료 |
| 에러 리스너 | `NotificationCenter` 옵저버 등록 | 비콘 스캔 · 근접 인증 등 SDK 자율 동작 중 발생한 에러를 앱에 통지 |

### 1.4 최소 요구 사항
SDK 바이너리가 동작하기 위한 조건
| 항목 | 최솟값 |
|------|--------|
| iOS | 14.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |
| 아키텍처 | arm64 (실기기 전용, 시뮬레이터 미지원) |
| 카메라 | 전면 카메라 필수 |

### 1.5 파트너사 앱 설정 요구사항

SDK가 정상 동작하려면 파트너사앱에 아래 설정이 **반드시** 적용되어야 합니다.

#### Info.plist 권한

| 항목 | 설명 | Info.plist Key |
|------|------|----------------|
| 카메라 | 안면 추출 기능 사용 시 필수 | `NSCameraUsageDescription` |
| Bluetooth | 비콘 탐지 시 필수 | `NSBluetoothAlwaysUsageDescription` |
| 위치 (사용 중) | 비콘 기능 사용 시 필수 | `NSLocationWhenInUseUsageDescription` |
| 위치 (항상) | 백그라운드 비콘 탐지 시 필수 | `NSLocationAlwaysAndWhenInUseUsageDescription` |

#### Signing & Capabilities — Background Modes

| 항목 | 설명 |
|------|------|
| Background fetch | 백그라운드 데이터 갱신 |
| Background processing | 백그라운드 작업 처리 |
| Location updates | 백그라운드 위치 업데이트 |

> Xcode → Target → **Signing & Capabilities → + Capability → Background Modes** 에서 해당 항목을 체크하세요.

---

## 2. 설치

GhostPass SDK는 **Private GitHub 저장소**를 통해 배포됩니다.  
아래 절차에 따라 GhostPass 팀에 접근 권한을 요청한 뒤 설치를 진행하세요.

#### Step 1. (공통) 저장소 접근 권한 요청

GhostPass 담당자에게 아래 정보를 전달하여 저장소 접근(Read) 권한을 요청합니다.

- GitHub 계정 이메일 (또는 GitHub username)
- 귀사 서비스명 / 담당자 이름

권한이 부여되면 초대 이메일이 발송됩니다. GitHub에서 초대를 수락하세요.

#### Step 2. (공통) GitHub 계정 인증 설정 (Xcode)

Private 저장소에 접근하려면 Xcode에 GitHub 계정이 등록되어 있어야 합니다.

1. **Xcode → Settings → Accounts** 탭으로 이동합니다.
2. `+` 버튼을 클릭하고 **GitHub** 계정을 선택합니다.
3. GitHub 계정 정보를 입력하여 로그인합니다.
> 💡 **팁**: GitHub Fine-grained Personal Access Token 또는 Classic Token을 사용하는 경우, **repo** 읽기 권한이 포함되어 있는지 확인하세요.

### 2.1 SPM (Swift Package Manager)
#### Step 3. Swift Package Manager로 SDK 추가

1. Xcode에서 프로젝트를 열고 **File → Add Package Dependencies...** 를 선택합니다.
2. 검색창에 아래 저장소 URL을 입력합니다.

```
https://github.com/ghostpass-ai/ghostpass-sdk-distribution
```

3. **Dependency Rule**을 선택합니다. (권장: `Up to Next Major Version`)
4. **Add Package** 버튼을 클릭하고, `GoPassSDK` 라이브러리를 앱 타깃에 추가합니다.

> ⚠️ **주의**: 저장소가 목록에 표시되지 않는 경우, Step 1에서 GitHub 접근 권한이 부여되었는지, Step 2에서 Xcode에 계정이 정상 등록되었는지 확인하세요.

#### CI/CD 환경에서의 설치

GitHub Actions 등 자동화 빌드 환경에서는 환경변수로 인증 정보를 관리합니다.

```bash
# Xcode Cloud / GitHub Actions 환경에서 SPM 인증을 위한 .netrc 설정 예시
echo "machine github.com login <YOUR_GITHUB_USER> password <YOUR_GITHUB_TOKEN>" >> ~/.netrc
```

> 💡 **팁**: GitHub Actions를 사용하는 경우 Repository Secret에 토큰을 저장하고 빌드 스크립트에서 참조하세요.

### 2.2 CocoaPods
#### Step 3. Podfile 설정 및 설치

1. 프로젝트 루트 폴더의 `Podfile`을 열고 아래와 같이 GhostPassSDK 저장소를 지정합니다.
2. Static Framework 연동을 위해 use_frameworks! :linkage => :static 설정을 확인하세요.

``` ruby
#Podfile
target 'YourAppTarget' do
  use_frameworks! :linkage => :static  # Static Linkage 설정

  # GhostPass SDK (Private Git URL 사용)
  pod 'GoPassSDK', :git => 'https://github.com/ghostpass-ai/ghostpass-sdk-distribution.git', :tag => '{SDK_TAG_VERSION}'
  
  # Firebase 의존성 추가
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
end
```
3. 터미널에서 아래 명령어를 실행하여 SDK를 설치합니다.
``` bash
pod install
```

#### CI/CD 환경에서의 설치 (Personal Access Token 사용)
SSH 키를 등록하기 어려운 자동화 환경에서는 **Personal Access Token(PAT)**을 URL에 포함하여 인증할 수 있습니다.

``` Ruby
# Podfile 예시 (GitHub Token 사용)
pod 'GoPassSDK', :git => 'https://<YOUR_TOKEN>@github.com/ghostpass-ai/ghostpass-sdk-distribution.git'
```
> ⚠️ **보안 주의**: 토큰이 포함된 Podfile은 보안에 취약할 수 있습니다. 가급적 CI 환경의 환경변수를 활용하거나 SSH Agent를 사용하세요.

#### Static Framework의 특이사항

GhostPass SDK는 Static Framework 형태로 제공됩니다. 호스트 앱 빌드 시 'Duplicate Symbol' 에러가 발생한다면, `Build Settings`의 `Other Linker Flags`에서 -ObjC 플래그가 중복되어 영향을 주는지 확인해주세요.

---

## 3. 사전 준비
### 3.1 서비스 등록 및 API Key 발급

GhostPass SDK를 사용하려면 서비스를 등록하고 **API Key**를 발급받아야 합니다.  
API Key는 SDK가 GhostPass 서버와 통신 시 서비스를 식별하는 핵심 인증 정보로, **GhostPass 담당자가 직접 생성하여 전달**합니다.

#### Step 1. 서비스 등록 요청

GhostPass 담당자(이메일·슬랙 등 지정 채널)에게 아래 정보를 전달합니다.

| 항목 | 내용 | 예시 |
|------|------|------|
| 회사명 | 귀사 법인명 | (주)고스트패스 |
| 서비스명 | SDK를 적용할 앱 이름 | A사 편의점 페이 |
| Bundle ID | Xcode Bundle Identifier | `com.company.myapp` |
| 환경 | 개발(dev) / 운영(prod) 구분 | dev, prod |
| 담당자 이메일 | API Key 수령 이메일 | dev@company.com |

> 💡 **팁**: **개발용·운영용 Bundle ID가 다르다면 환경을 구분하여 각각 요청**하세요. GhostPass는 환경별로 격리된 API Key를 발급합니다.

#### Step 2. API Key 수령

등록 요청을 처리한 뒤 GhostPass 담당자가 보안 채널(이메일 암호화 또는 지정 메신저)로 아래 정보를 전달합니다.

```
API_KEY  : gp_dev_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  (공개용 — 앱에 포함)
```

> ⚠️ **주의**: `APP_SECRET`(서버 내부 키)은 앱에 포함되지 않으며 파트너사에 전달되지 않습니다. SDK가 최초 실행 시 서버와 ECDH 프로토콜을 통해 안전하게 파생합니다.

#### Step 3. API Key 앱에 적용

소스 코드에 하드코딩하지 않고 **빌드 환경변수**로 분리하는 것을 강력 권장합니다.

**방법 A — `.xcconfig` 파일 (권장)**

```bash
# Debug.xcconfig  ← .gitignore에 반드시 추가
GHOSTPASS_API_KEY = gp_dev_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Release.xcconfig  ← .gitignore에 반드시 추가
GHOSTPASS_API_KEY = gp_prod_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

`Info.plist`에서 참조:
``` xml
<key>GhostPassAPIKey</key>
<string>$(GHOSTPASS_API_KEY)</string>
```

Swift 코드에서 읽어 SDK에 전달:
``` swift
let apiKey = Bundle.main.object(forInfoDictionaryKey: "GhostPassAPIKey") as? String ?? ""
GPSDK.shared.gpInit(apiKey: apiKey) { result in ... }
```

**방법 B — CI/CD 환경 변수 (GitHub Actions / Xcode Cloud)**

``` yaml
# .github/workflows/build.yml
- name: Build
  env:
    GHOSTPASS_API_KEY: ${{ secrets.GHOSTPASS_API_KEY }}
  run: xcodebuild ...
```

> ⚠️ **주의**: API Key를 소스 코드에 **직접 커밋하지 마세요**. 노출 시 즉시 GhostPass 담당자에게 Key 폐기 및 재발급을 요청하세요.

#### API Key 운영 정책

| 항목 | 내용 |
|------|------|
| 발급 주체 | GhostPass 담당자 직접 생성 후 전달 |
| 유효 기간 | 계약 기간 연동 (만료 30일 전 사전 안내) |
| 환경 분리 | 개발(dev) / 운영(prod) Key 별도 발급 |
| Key 폐기·재발급 | GhostPass 담당자에게 요청 (즉시 처리) |

---

### 3.2 Info.plist 권한 설정

정상적인 SDK 구동을 위해 아래 키를 `Info.plist`에 반드시 추가해야 합니다.

``` xml
<!-- 카메라: 안면 추출 기능 사용 시 필수 -->
<key>NSCameraUsageDescription</key>
<string>안면 정보 추출을 위해 카메라 접근이 필요합니다.</string>

<!-- Bluetooth: 비콘 탐지 시 필수 -->
<key>NSBluetoothAlwaysUsageDescription</key>
<string>근처 키오스크 감지를 위해 Bluetooth 접근이 필요합니다.</string>

<!-- 위치 (사용 중): 비콘 기능 사용 시 필수 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>근처 키오스크 감지를 위해 위치 접근이 필요합니다.</string>

<!-- 위치 (항상): 백그라운드 비콘 탐지 시 필수 -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>백그라운드에서도 키오스크를 감지하기 위해 항상 위치 접근이 필요합니다.</string>
```

> ⚠️ **주의**: 권한 설명 문자열을 누락하거나 너무 모호하게 작성하면 App Store 심사에서 거부될 수 있습니다. 사용하는 정확한 이유를 명시해주세요.

---

## 4. SDK 초기화

SDK를 사용하기 전 반드시 초기화를 완료해야 합니다. 초기화는 앱 실행 시점 **한 번만** 호출합니다.

### 4.1 API 형태 및 설명

| 항목 | 설명 | 예시 |
|------|------|------|
| userOid | Ghostpass SDK를 사용하기 위해 파트너사의 유저와 매핑된 id 값 | u12345 |
| apiKey | `3. 사전 준비` 시 발급 받은 apiKey | gp_dev_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
   
``` swift
// SDK 시스템 초기화
public func initialize(userOid: String, apiKey: String) async throws
```

### 4.2 예시

```swift
func startSDK() {
    Task {
        do {
            try await GoPass.shared.initialize(userOid: "YOUR_USER_OID", apiKey: "YOUR_API_KEY")
        } catch {
            self.isSuccess = false
            self.isProcessing = false
            self.statusMessage = "에러 발생: \(error.localizedDescription) ❌"
        }
    }
}
```

---

## 5. 안면 정보 등록 (작성중!!!!!)

안면 정보 등록은 카메라로 촬영한 이미지에서 안면 특징 벡터를 추출하여 기기의 Keychain에 저장하고 Beacon 탐지를 시작하는 과정입니다.

### 5.1 API 형태 및 설명

| 항목 | 설명 | 예시 |
|------|------|------|
| imageBytes | Ghostpass SDK를 사용하기 위해 파트너사의 유저와 매핑된 id 값 | u12345 |
   
``` swift
// 생체 데이터 등록
public func registerBioData(imageBytes: [UInt8]) async throws -> BioDataFrameStatus
```

### 5.2 예시


### 5.2 얼굴 등록 호출

```swift
import GoPassSDK

// 카메라 델리게이트 또는 이미지 피커에서 UIImage를 받은 후 호출
func registerFace(with image: UIImage) {
    GPSDK.shared.gpSaveLandmark(image: image) { result in
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("✅ 얼굴 등록 성공")
                self.showSuccessUI()

            case .failure(let error):
                if let faceError = error as? GPFaceDetectionError {
                    switch faceError {
                    case .noFaceDetected:
                        self.showGuide("화면에 얼굴을 위치시켜 주세요.")
                    case .invalidFace:
                        self.showGuide("정면을 바라봐 주세요.")
                    case .livenessNotSatisfied:
                        self.showGuide("실물 얼굴로 인증해 주세요.")
                    case .featureNotExtracted:
                        self.showGuide("얼굴 인식에 실패했습니다. 다시 시도해 주세요.")
                    }
                } else if let basicError = error as? GPBasicError {
                    self.showError(basicError.errorDescription)
                }
            }
        }
    }
}
```

### 5.3 등록 상태 확인

```swift
// 등록 여부 확인 (Keychain에 FVector가 저장되어 있는지 확인)
if GPSDK.shared.gpIsExistLandmark {
    print("✅ 등록된 얼굴 있음")
} else {
    print("⚠️ 등록된 얼굴 없음 — 등록 화면으로 이동")
}

// 등록된 사용자 ID 확인
if let userOid = GPSDK.shared.userOid {
    print("사용자 ID: \(userOid)")
}
```

### 5.4 얼굴 데이터 삭제 (재등록 / 탈퇴)

```swift
// 저장된 얼굴 특징 벡터를 Keychain에서 삭제
let deleted = GPSDK.shared.gpDeleteLandmark()
if deleted {
    print("✅ 얼굴 데이터 삭제 완료")
} else {
    print("❌ 삭제 실패 — 이미 삭제되었거나 저장된 데이터 없음")
}
```

### 5.5 Liveness 검증 기준

SDK 내부에서 자동으로 수행되는 안티 스푸핑 검사 기준입니다.

| 검사 항목 | 기준값 |
|----------|--------|
| 얼굴 각도 (Yaw/Pitch/Roll) | 각 ±15° 이내 |
| 얼굴 위치 | 화면 중앙 ±20% 이내 |
| 얼굴 크기 | 화면 너비의 10% ~ 80% |
| Liveness Confidence | 0.9030 이상 |
| 연속 사진 수집 | 내부 기준 충족 후 판정 |

> 💡 **팁**: 등록 시 밝은 조명에서 정면을 바라보도록 UI 가이드를 제공하면 등록 성공률이 크게 향상됩니다.

---

## 6. 얼굴 인증

### 6.1 인증 흐름 개요

```
서버로부터 암호화된 secureData 수신
               ↓
      gpCompareLandmark() 호출
               ↓
     내부에서 복호화 후 특징 벡터 비교
               ↓
        ┌──────┴──────┐
        ↓             ↓
      성공            실패
  transactionOid   GPBasicError
    반환              반환
```

> 💡 **팁**: 서버에서 내려오는 `secureData`는 SDK 내부에서 복호화됩니다. 파트너 앱은 해당 데이터를 그대로 전달하기만 하면 됩니다.

### 6.2 전체 연동 예시

```swift
import GoPassSDK

class AuthViewController: UIViewController {

    // 1단계: 등록 여부 확인
    func checkEnrollment() {
        guard GPSDK.shared.gpIsExistLandmark else {
            navigateToEnrollment()
            return
        }
        startAuthentication()
    }

    // 2단계: 서버로부터 secureData를 받아 인증 호출
    func startAuthentication() {
        fetchSecureDataFromServer { [weak self] secureData, hostLocationOid in
            guard let self = self else { return }
            self.authenticate(hostLocationOid: hostLocationOid, secureData: secureData)
        }
    }

    // 3단계: SDK 인증 수행
    private func authenticate(hostLocationOid: Int, secureData: String) {
        // gpCompareLandmark는 내부 private이므로 서버 연동 래퍼를 통해 호출됩니다.
        // 실제 연동 시 서버 API 응답의 secureData를 SDK에 전달하세요.
    }

    // 4단계: 인증 성공 처리
    func handleAuthSuccess(transactionOid: String) {
        DispatchQueue.main.async {
            print("✅ 인증 성공 — 거래 ID: \(transactionOid)")
            self.navigateToHome()
        }
    }

    // 5단계: 인증 실패 처리
    func handleAuthFailure(_ error: GPBasicError) {
        DispatchQueue.main.async {
            switch error {
            case .missingLandmark:
                self.showAlert("등록된 얼굴이 없습니다. 먼저 등록해 주세요.")
            case .invalidLandmark:
                self.showAlert("본인 인증에 실패했습니다. 다시 시도해 주세요.")
            case .networkError:
                self.showAlert("네트워크 오류가 발생했습니다. 연결을 확인해 주세요.")
            default:
                self.showAlert(error.errorDescription ?? "오류가 발생했습니다.")
            }
        }
    }
}
```

---

## 7. 에러 처리

GhostPass SDK는 두 가지 에러 타입을 제공합니다.

### 7.1 GPFaceDetectionError — 얼굴 감지 관련

| 케이스 | 설명 | 권장 처리 |
|--------|------|-----------|
| `noFaceDetected` | 이미지에서 얼굴을 감지하지 못함 | "화면에 얼굴을 위치시켜 주세요" 안내 |
| `invalidFace` | 각도·위치·크기 기준 미달 | "정면을 바라봐 주세요" 안내 |
| `livenessNotSatisfied` | 라이브니스 검사 실패 | "사진이 아닌 실물 얼굴로 시도" 안내 |
| `featureNotExtracted` | 얼굴 특징 벡터 추출 실패 | 재시도 유도 |

### 7.2 GPBasicError — 일반 SDK 에러

| 케이스 | 설명 | 권장 처리 |
|--------|------|-----------|
| `sdkInitFailed` | SDK 초기화 실패 | `gpInit()` 재호출 |
| `missingLandmark` | 등록된 얼굴 없음 | 등록 화면으로 이동 |
| `invalidLandmark` | 저장된 특징 벡터 유효하지 않음 | 재등록 유도 |
| `saveLandmarkFailed` | Keychain 저장 실패 | 재시도, 권한 확인 |
| `networkError` | 네트워크 통신 실패 | 연결 상태 확인 후 재시도 |
| `invalidSessionError` | 세션 만료 | 재로그인 유도 |
| `invalidDeviceIDError` | 기기 식별자 불일치 (중복 로그인) | 로그아웃 처리 후 재시도 |
| `compareRecordNetwork` | 인증은 성공했으나 결과 저장 실패 | 재시도 (인증 자체는 성공) |
| `parsingFailed` | 서버 응답 파싱 실패 | 서버 응답 형식 확인 |
| `loginFailed` | 본인인증 실패 | 본인인증 재시도 |
| `unknown` | 기타 알 수 없는 오류 | 로그 수집 후 고객지원 문의 |

### 7.3 에러 처리 예시 코드

```swift
func handleError(_ error: Error) {
    // SDK 에러 디버그 로그 출력 (공통 포맷)
    if let gpError = error as? any GPError {
        log(gpError) // [GPBasicError] op=… fn=… file:line reason=… recovery=…
    }

    // 타입별 분기 처리
    if let faceError = error as? GPFaceDetectionError {
        handleFaceError(faceError)
    } else if let basicError = error as? GPBasicError {
        handleBasicError(basicError)
    } else {
        showGenericError()
    }
}

func handleFaceError(_ error: GPFaceDetectionError) {
    switch error {
    case .noFaceDetected:
        showGuide("얼굴을 화면 가운데에 위치시켜 주세요.")
    case .invalidFace:
        showGuide("정면을 바라보고, 충분한 조명 아래에서 시도해 주세요.")
    case .livenessNotSatisfied:
        showGuide("이미지가 아닌 실물 얼굴로 인증해 주세요.")
    case .featureNotExtracted:
        showGuide("얼굴 인식에 실패했습니다. 다시 시도해 주세요.")
    }
}

func handleBasicError(_ error: GPBasicError) {
    switch error {
    case .missingLandmark:
        navigateToEnrollment()
    case .networkError:
        showRetryAlert("네트워크 연결을 확인해 주세요.")
    case .invalidSessionError, .sessionError:
        navigateToLogin()
    case .invalidDeviceIDError:
        logout()
    default:
        showAlert(error.errorDescription ?? "오류가 발생했습니다.")
    }
}
```

---

## 8. FAQ

**Q1. 비콘이 감지되지 않습니다.**  
A. 현재 SDK는 비콘 기능이 비활성화 상태입니다(`gpActivateBeacon` 주석 처리됨). 비콘 연동이 필요한 경우 기술 지원으로 문의해 주세요.

---

**Q2. 인증이 계속 실패합니다. 어떻게 디버깅하나요?**  
A. 아래 순서로 확인하세요.

1. `GPSDK.shared.gpIsExistLandmark`가 `true`인지 확인
2. 등록 시와 동일한 조명·카메라 조건인지 확인
3. `log(error)` 출력에서 `reason` 및 `recovery` 메시지 확인
4. `invalidLandmark` 에러 시 → 재등록 유도 (`gpDeleteLandmark()` 후 재등록)

---

**Q3. 시뮬레이터에서 빌드 오류가 발생합니다.**  
A. `AlcheraFaceSDKPro`는 **arm64** 아키텍처만 지원하므로 시뮬레이터(x86_64 / arm64 시뮬레이터)에서는 동작하지 않습니다. 반드시 **실기기**에서 테스트하세요.

---

**Q4. 얼굴 등록 후 앱을 삭제하면 어떻게 되나요?**  
A. 얼굴 특징 벡터는 iOS Keychain에 저장됩니다. 앱을 삭제해도 Keychain 데이터는 유지될 수 있으므로, 재설치 후 `gpIsExistLandmark`를 확인하세요.

---

**Q5. `compareRecordNetwork` 에러는 어떻게 처리해야 하나요?**  
A. 이 에러는 **안면 비교 자체는 성공**했지만 서버에 결과를 저장하지 못한 상태입니다. 사용자에게 "인증에 성공했으나 기록 저장 중 오류가 발생했습니다. 다시 시도해 주세요."라고 안내하고 재시도를 유도하세요.

---

**Q6. `invalidDeviceIDError`가 발생했습니다.**  
A. 중복 로그인이 감지된 상태입니다. 현재 세션을 로그아웃 처리하고 사용자에게 다시 로그인을 요청하세요.

---

## 9. API Reference

### GPSDK

`GPSDK`는 SDK의 메인 진입점으로, 싱글턴 패턴으로 제공됩니다.

```swift
public class GoPass {
    public static let shared = GoPass()
}
```

#### 초기화

```swift
/// SDK를 초기화합니다. 앱 실행 시 최초 한 번 호출하세요.
/// - Parameter completion: 초기화 결과 콜백
public func gpInit(_ completion: @escaping (Result<GPSDKInitResultModel?, GPBasicError>) -> Void)
```

#### 얼굴 등록

```swift
/// 주어진 이미지에서 얼굴 특징을 추출하여 Keychain에 저장합니다.
/// - Parameters:
///   - image: 등록에 사용할 UIImage (전면 카메라 캡처 이미지 권장)
///   - completion: 성공 시 Void, 실패 시 Error 반환
public func gpSaveLandmark(image: UIImage, _ completion: @escaping (Result<Void, Error>) -> Void)
```

#### 얼굴 상태 확인

```swift
/// Keychain에 등록된 얼굴 데이터 존재 여부
public var gpIsExistLandmark: Bool { get }

/// 등록된 사용자 OID (없으면 nil)
public var userOid: Int? { get }
```

#### 얼굴 삭제

```swift
/// Keychain에서 얼굴 특징 벡터를 삭제합니다.
/// - Returns: 삭제 성공 여부
public func gpDeleteLandmark() -> Bool
```

#### 로그 및 데이터 수집

```swift
/// 로그 데이터 추가
public func gpAddLogData(_ data: [LogFormat])

/// FRR 데이터 추가
public func gpAddFRRData(_ data: [FRRFormat])

/// 로그 CSV 내보내기 (공유 시트 표시)
public func gpDownloadLogCSV(data: [LogFormat]? = nil, fileName: String = "log_export.csv", completion: ((Bool) -> Void)? = nil)

/// FRR CSV 내보내기 (공유 시트 표시)
public func gpDownloadFRRCSV(data: [FRRFormat]? = nil, fileName: String = "frr_export.csv", completion: ((Bool) -> Void)? = nil)

/// 데이터 파일에 로그 행 추가
public func gpAppendLogDataToCSV(data: [LogFormat], fileName: String = "log_export.csv", completion: ((Result<URL, Error>) -> Void)? = nil)

/// 로그 데이터 초기화
public func gpClearLogData()

/// FRR 데이터 초기화
public func gpClearFRRData()
```

---

### GPSDKInitResultModel

SDK 초기화 성공 시 반환되는 모델입니다.

```swift
public struct GPSDKInitResultModel {
    /// 등록된 사용자의 얼굴 OID
    public let userFacialOid: Int
    /// 현재 호스트 위치 OID
    public let hostLocationOid: Int
}
```

---

### GPFaceDetectionError

얼굴 감지 및 등록 과정에서 발생하는 에러입니다.

```swift
public enum GPFaceDetectionError: GPError {
    case noFaceDetected(context: GPErrorContext)      // 얼굴 미감지
    case invalidFace(context: GPErrorContext)          // 유효하지 않은 얼굴 (각도/위치/크기)
    case livenessNotSatisfied(context: GPErrorContext) // Liveness 미충족
    case featureNotExtracted(context: GPErrorContext)  // 특징 추출 실패
}
```

---

### GPBasicError

일반 SDK 동작 중 발생하는 에러입니다.

```swift
@frozen
public enum GPBasicError: GPError {
    case sdkInitFailed(context:)       // SDK 초기화 실패
    case loginFailed(context:)         // 로그인 실패
    case detectFaceFailed(context:)    // 얼굴 감지 실패
    case notSatisfiedLiveness(context:)// Liveness 미충족
    case extractFeatureFailed(context:)// 특징 추출 실패
    case saveLandmarkFailed(context:)  // 랜드마크 저장 실패
    case missingLandmark(context:)     // 등록된 랜드마크 없음
    case invalidLandmark(context:)     // 유효하지 않은 랜드마크
    case parsingFailed(context:)       // 파싱 실패
    case networkError(underlying:context:) // 네트워크 오류
    case invalidSessionError(context:) // 세션 만료
    case sessionError(context:)        // 세션 오류
    case invalidDeviceIDError(context:)// 기기 ID 불일치
    case invalidResponse(context:)     // 유효하지 않은 응답
    case compareRecordNetwork(context:)// 비교 성공 후 저장 실패
    case withdrawFailed(context:)      // 탈퇴 처리 실패
    case emptyValue(value:context:)    // 빈 값 오류
    case unknown(underlying:context:)  // 알 수 없는 오류
}
```

---

### GPError Protocol

모든 SDK 에러가 준수하는 공통 프로토콜입니다.

```swift
public protocol GPError: Swift.Error, LocalizedError, CustomDebugStringConvertible, Sendable {
    /// 에러 발생 위치 및 작업 정보
    var context: GPErrorContext { get }
    /// 표준화된 디버그 로그 문자열
    var debugSummary: String { get }
}
```

디버그 로그 포맷:
```
[GPBasicError] op=<operation>
 fn=<function name>
 <file>:<line>
 reason=<error description>
 recovery=<recovery suggestion>
```

---

*© GhostPass AI. All rights reserved.*
