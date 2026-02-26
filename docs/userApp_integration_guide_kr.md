# GhostPass SDK — 개발자 문서

> **버전** 1.0.0 · **지원 플랫폼** iOS 14.0+ · **배포 형식** SPM, CocoaPod  
> **최종 업데이트** 2026년 2월 26일

---

## 목차

1. [개요](#1-개요)
2. [설치](#2-설치)
3. [사전 준비](#3-사전-준비)
4. [API Reference](#4-api-reference)
5. [에러 처리](#5-에러-처리)
6. [FAQ](#6-faq)

---

## 1. 개요

### 1.1 GhostPass SDK란?

GhostPass SDK는 iOS 앱에 **비접촉 생체 정보 인식 인증**을 손쉽게 통합할 수 있는 보안 SDK입니다.  
Liveness Detection(위조 방지), 얼굴 특징 추출, 서버 연동을 모두 내부에서 처리하므로, 파트너 개발자가 직접 다뤄야 할 것은 **딱 3가지**입니다.

```
initialize(userOid:apiKey:)  →  registerBioData(imageBytes:)  →  (필요시) removeBioData()
```

### 1.2 주요 기능

| 기능 | 설명 |
|------|------|
| 생체 정보 등록 | 카메라 이미지로부터 생체 정보 특징 벡터 추출 및 Keychain 저장 |
| Liveness Detection | BGR 기반 안티 스푸핑으로 사진·영상 위조 방지 |
| 생체 정보 인증 | 등록된 특징 벡터와 실시간 생체 정보 비교 |
| 보안 저장 | 모든 민감 데이터는 iOS Keychain에만 저장 |

### 1.3 동작 흐름

GhostPass SDK는 **API Key 한 줄**로 연동을 시작하며, 내부 보안 처리(기기 검증, 암호화, 인증 세션 관리)는 모두 SDK가 자동으로 수행합니다.

```
① 서비스 등록 (1회)
   GhostPass 담당자에게 Bundle ID 전달 → API Key 수령

② SDK 초기화 (앱 실행 시 1회)
   initialize(userOid:apiKey:) 호출 → SDK 내부 보안 채널 자동 수립

③ 얼굴 등록 (사용자당 1회)
   registerBioData(imageBytes:) 호출 → 생체 정보 추출 + Liveness 검사 + 특징 추출 + 안전 저장

④ 자동 인증 (키오스크 근접 시 자동 동작)
   키오스크 비콘 감지 → 인증 세션 수립 → 기기 내 얼굴 매칭
```

#### 파트너사에서 직접 구현할 것

| 단계 | 호출 | SDK 동작 |
|------|------|---------------|
| 초기화 | `initialize(userOid:apiKey:)` 1회 | 기기 검증 · 보안 채널 수립 · 내부 키 관리 |
| 생체 정보 등록 | `registerBioData(imageBytes:)` | 생체 정보 추출 · Liveness 검사 · 특징 추출 · 안전한 저장 |
| 생체 정보 삭제 | `removeBioData()` | 생체 정보 삭제 · 비콘 스캔 종료 |
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
| 카메라 | 생체 정보 추출 시 필수 | `NSCameraUsageDescription` |
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
try await GoPassSDK.shared.initialize(userOid: userOid, apiKey: apiKey)
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
<!-- 카메라: 생체 정보 추출 기능 사용 시 필수 -->
<key>NSCameraUsageDescription</key>
<string>생체 정보 추출을 위해 카메라 접근이 필요합니다.</string>

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

## 4. API Reference
### 4.1 SDK 초기화

SDK를 사용하기 전 반드시 초기화를 완료해야 합니다. 초기화는 앱 실행 시점 **한 번만** 호출합니다.

#### 4.1.1 API 형태 및 설명
**request**

| 항목 | 타입 | 설명 | 예시 |
|------|------|------|------|
| apiKey | String | `3. 사전 준비` 시 발급 받은 apiKey | `gp_dev_xxxxxx...` |

**response**

| 타입 | 설명 | 예시 |
|----|------|-----------|
| String | SDK가 발급한 사용자 식별자. 유저가 파트너사 앱 재설치시 변경될 수 있습니다. | `"7612bd71dfc485cfaf375374ed57..."` |

> 💡 **추가설명**: 반환된 String은 파트너사의 DB 내 유저와 직접 매핑을 진행하여야합니다.
   
``` swift
// SDK 시스템 초기화
public func initialize(apiKey: String) async throws -> String
```

#### 4.1.2 예시

```swift
func startSDK() {
    Task {
        do {
            let userId = try await GoPass.shared.initialize(apiKey: "YOUR_API_KEY")
            /* 파트너사 유저와 매핑하는 로직 */
        } catch {
            print(GoPassSDK.SDKError.code, GoPassSDK.SDKError.message)
        }
    }
}
```

---

### 4.2 생체 정보 등록

카메라로 촬영한 이미지에서 생체 정보 특징 벡터를 추출하여 기기의 Keychain에 저장하고 Beacon 탐지를 시작하는 과정입니다.

#### 4.2.1 API 형태 및 설명
**request**

| 항목 | 설명 | 예시 |
|------|------|------|
| imageBytes | 카메라 프레임(`CMSampleBuffer`)을 직접 전달하지 않으며, JPEG/PNG 데이터로 변환 후 전달해야 합니다. | `[0xFF, 0xD8, 0xFF, ...]` |

**response**

| 타입 | 값 | 권장 처리 |
|----|------|-----------|
| BioDataFrameStatus | saving | 카메라 캡처 유지, 다음 프레임 전달 |
| | done | 저장 완료. 카메라 캡쳐 중지 |
   
``` swift
// 생체 정보 데이터 등록
public func registerBioData(imageBytes: [UInt8]) async throws -> BioDataFrameStatus

public enum BioDataFrameStatus {
    case saving          // 계속 프레임 전송
    case done            // 모든 과정 성공 (등록 완료)
}
```

#### 4.2.2 예시
> 🗒️ **권장 사항**:  
> 1. captureOutput 전용 Serial Queue 생성  
>    AVCaptureVideoDataOutput의 샘플 버퍼 델리게이트는 반드시 별도의 Serial Queue를 지정해야 합니다. 메인 큐를 사용하면 UI 업데이트가 차단되고, Concurrent Queue를 사용하면 프레임이 순서 없이 처리되어 예기치 않은 동작이 발생할 수 있습니다. 전용 Serial Queue를 사용하면 프레임이 순서대로 처리되며 메인 스레드의 부하를 줄일 수 있습니다.
> 2. Guard Flag(isProcessingFrame) 생성  
>    카메라는 초당 30프레임 이상을 전송하므로, 이전 registerBioData 호출이 완료되기 전에 다음 프레임이 도착하면 호출이 중첩되어 콜스택에 누적됩니다. 이는 메모리 부하 및 예기치 않은 동작으로 이어질 수 있습니다.
>    isProcessingFrame 플래그를 두어 처리 중인 동안 들어오는 프레임을 스킵하고, registerBioData 완료 후 반드시 false로 초기화해야 다음 프레임 처리가 가능합니다.


``` swift
private let videoQueue = DispatchQueue(label: "biodata.videoQueue", qos: .userInitiated)
private var frameCount = 0
private var isProcessingFrame = false // registerBioData 처리중일 때 frame을 무시하기 위한 flag
private let frameInterval = 20

func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    frameCount += 1
    guard frameCount >= frameInterval else { return }  // 프레임 생성 속도가 매우 빨라 20프레임마다 처리 (파트너사의 선택)
    frameCount = 0

    guard !isProcessingFrame else { return }           // 이전 요청 처리 중이면 스킵
    guard let frameBytes = imageBytes(from: sampleBuffer) else { return }

    isProcessingFrame = true

    Task { [weak self] in
        guard let self else { return }
        defer { self.videoQueue.async { self.isProcessingFrame = false } } // Task 종료 후 isProcessingFrame false 변경

        do {
            let status = try await GoPass.shared.registerBioData(imageBytes: frameBytes)
            switch status {
            case .saving:
                break                                  // 계속 촬영

            case .done:
                DispatchQueue.main.async {
                    self.stopCapture()
                }

            @unknown default:
                break
            }
        } catch let sdkError as GoPassSDK.SDKError {
            DispatchQueue.main.async {
                self.stopCapture()
            }
            print(sdkError.code, sdkError.message)
        }
    }
}

// MARK: - CMSampleBuffer → JPEG [UInt8]
private func imageBytes(from sampleBuffer: CMSampleBuffer) -> [UInt8]? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        .oriented(.right)   // 전면 카메라 세로 방향 보정
    let uiImage = UIImage(ciImage: ciImage)
    guard let jpegData = uiImage.jpegData(compressionQuality: 0.9) else { return nil }
    return [UInt8](jpegData)
}
```
> 💡 **팁**: 등록 시 밝은 조명에서 정면을 바라보도록 UI 가이드를 제공하면 등록 성공률이 크게 향상됩니다.

---

### 4.3 생체 정보 삭제

로그아웃, 회원탈퇴, 유저의 선택과 같은 상황에 생체 정보를 삭제할 수 있습니다.

#### 4.3.1 API 형태 및 설명
   
``` swift
// 생체 정보 데이터 삭제
public func removeBioData() async throws
```

#### 4.3.2 예시
``` swift
func removeBioData() {
    Task {
        do {
            try await GoPass.shared.removeBioData()
        } catch let sdkError as GoPassSDK.SDKError
            print(sdkError.code, sdkError.description)
        }
    }
}
```

### 4.4 에러 리스너

비콘 탐지 및 인증을 수행하며 발생할 수 있는 에러를 구독하여 리스닝합니다.  
[5.1.1 GP0xx](#511-gp0xx--백그라운드-서비스-onserviceerror)에 해당하는 에러에 대하여 모두 addObserver를 세팅합니다.

#### 4.3.1 API 형태 및 설명
``` swift
NotificationCenter.default.addObserver(forName: .onServiceError, object: nil, queue: .main) { }
```

#### 4.3.2 예시
``` swift
NotificationCenter.default.addObserver(
    forName: .onServiceError,
    object: nil,
    queue: .main
) { [weak self] notification in
    guard let self,
          let error = notification.userInfo?[GoPassNotificationKey.sdkError] as? SDKError else { return }

    switch error {
    case .locationServiceDisabled:
        self.showAlert(
            title: "위치 권한 필요",
            message: "비콘 감지를 위해 위치 권한이 필요합니다. 설정에서 '항상 허용'으로 변경해 주세요.",
            action: ("설정으로 이동", {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        )
    case .bluetoothDisabled:
        self.showAlert(
            title: "블루투스 비활성화",
            message: "비콘 감지를 위해 블루투스를 활성화해 주세요."
        )
    default:
        print("[\(error.code)] \(error.message)")
    }
}
```
---

## 5. 에러 처리

### 5.1 에러 코드 정의
Ghostpass SDK를 사용하며 발견될 수 있는 에러 코드입니다.

#### 5.1.1 GP0xx — 백그라운드 서비스 (`onServiceError`)

| 에러 코드 | 설명 |
|-----------|------|
| GP0xx | 원격 트랜잭션 처리에 실패했습니다. |
| GP0xx | 위치 서비스 권한이 필요합니다. |
| GP0xx | 블루투스를 활성화해주세요. |
| GP0xx | 서비스 가능 위치가 아닙니다. |
| GP0xx | 네트워크 연결을 확인해주세요. |

#### 5.1.2 GP1xx — `initialize()`

| 에러 코드 | 설명 |
|-----------|------|
| GP101 | 요청 파라미터가 올바르지 않습니다. |
| GP102 | 네트워크 연결을 확인해주세요. |
| GP103 | 초기화를 실패했습니다. |
| GP104 | SDK 버전이 최신이 아닙니다. |
| GP105 | 내부 네트워크 통신에 실패하였습니다. |

#### 5.1.3 GP2xx — `registerBioData()`

| 에러 코드 | 설명 |
|-----------|------|
| GP201 | 이미지 데이터가 누락되었거나 형식이 올바르지 않습니다. |
| GP202 | 생체 데이터 등록에 실패했습니다. |

#### 5.1.4 GP3xx — `removeBioData()`

| 에러 코드 | 설명 |
|-----------|------|
| GP301 | 생체 데이터 삭제에 실패했습니다. |

---

### 5.2 에러 처리 예시 코드

```swift
// function
do {
    try await GoPass.shared.initialize(userOid: id, apiKey: key)
} catch let error as SDKError {
    print(error.code)     // "GP103(IN-107)"  ← 문의 시 에러 코드 전달
    print(error.message)  // "초기화를 실패했습니다."

    switch error {
    case .initializationFailed: showRetryAlert()
    case .updateSDK:            showUpdateAlert()
    case .invalidParameters:    showParamError()
    default: break
    }
}

// onServiceError
NotificationCenter.default.addObserver(
    forName: .onServiceError,
    object: nil,
    queue: .main
) { notification in
    guard let error = notification.userInfo?[GoPassNotificationKey.sdkError] as? SDKError else { return }
    print("[\(error.code)] \(error.message)")   // "[GP003(IN-107)] 현재 위치는 서비스 가능 구역이 아닙니다."
}
```

---

## 6. FAQ

**Q1. 비콘이 감지되지 않습니다.**  
A. 생체 정보 인증 데이터가 저장되어 있는지 확인해주세요. 생체 정보가 없으면 비콘 감지를 시작하지 않습니다.

---

**Q3. 시뮬레이터에서 빌드 오류가 발생합니다.**  
A. `GoPassSDK`는 **arm64** 아키텍처만 지원하므로 시뮬레이터(x86_64 / arm64 시뮬레이터)에서는 동작하지 않습니다. 반드시 **실기기**에서 테스트하세요.

---

**Q4. 얼굴 등록 후 앱을 삭제하면 어떻게 되나요?**  
A. 얼굴 특징 벡터는 iOS Keychain에 저장됩니다. 앱을 삭제해도 Keychain 데이터는 유지될 수 있으므로, 재설치 후 `removeBioData()`를 실행하면 삭제가 가능합니다.

---


*© GhostPass AI. All rights reserved.*
