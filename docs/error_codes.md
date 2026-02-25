# GhostPass SDK — 에러 코드 참조

GhostPass SDK는 두 가지 에러 타입을 통해 오류를 전달합니다.

---

## GPFaceDetectionError — 얼굴 감지 에러

얼굴 등록(`gpSaveLandmark`) 시 발생하는 에러입니다.

| 에러 코드 | 설명 | 권장 처리 |
|-----------|------|-----------|
| `noFaceDetected` | 이미지에서 얼굴을 감지하지 못함 | "화면에 얼굴을 위치시켜 주세요" 안내 |
| `invalidFace` | 얼굴 각도·위치·크기 기준 미달 | "정면을 바라봐 주세요" 안내 |
| `livenessNotSatisfied` | Liveness(위조 방지) 검사 실패 | "사진이 아닌 실물 얼굴로 시도해 주세요" 안내 |
| `featureNotExtracted` | 얼굴 특징 추출 실패 | 재시도 유도 |

### 처리 예시

```swift
GPSDK.shared.gpSaveLandmark(image: image) { result in
    if case .failure(let error) = result,
       let faceError = error as? GPFaceDetectionError {
        switch faceError {
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
}
```

---

## GPBasicError — 일반 SDK 에러

SDK 전반에서 발생할 수 있는 에러입니다.

| 에러 코드 | 설명 | 권장 처리 |
|-----------|------|-----------|
| `sdkInitFailed` | SDK 초기화 실패 | `gpInit()` 재호출 |
| `missingLandmark` | 등록된 얼굴 없음 | 얼굴 등록 화면으로 이동 |
| `invalidLandmark` | 저장된 얼굴 데이터 유효하지 않음 | 재등록 유도 (`gpDeleteLandmark()` 후 재등록) |
| `saveLandmarkFailed` | 얼굴 데이터 저장 실패 | 재시도 |
| `networkError` | 네트워크 통신 실패 | 연결 상태 확인 후 재시도 |
| `invalidSessionError` | 세션 만료 | 재로그인 유도 |
| `sessionError` | 세션 오류 | 재로그인 유도 |
| `invalidDeviceIDError` | 기기 식별자 불일치 (중복 로그인) | 로그아웃 처리 후 재시도 |
| `compareRecordNetwork` | 인증 성공 후 결과 저장 실패 | 재시도 (인증 자체는 성공 상태) |
| `parsingFailed` | 서버 응답 파싱 실패 | 서버 응답 형식 확인 |
| `loginFailed` | 본인인증 실패 | 본인인증 재시도 |
| `unknown` | 알 수 없는 오류 | 로그 수집 후 기술 지원 문의 |

### 처리 예시

```swift
func handleError(_ error: Error) {
    guard let basicError = error as? GPBasicError else { return }

    switch basicError {
    case .missingLandmark:
        navigateToEnrollment()
    case .networkError:
        showRetryAlert("네트워크 연결을 확인해 주세요.")
    case .invalidSessionError, .sessionError:
        navigateToLogin()
    case .invalidDeviceIDError:
        logout()
    case .compareRecordNetwork:
        showAlert("인증에 성공했으나 기록 저장에 실패했습니다. 다시 시도해 주세요.")
    default:
        showAlert(basicError.errorDescription ?? "오류가 발생했습니다.")
    }
}
```

---

## 디버그 로그 포맷

모든 SDK 에러는 아래 표준 포맷으로 콘솔에 출력됩니다.

```
[GPBasicError] op=<operation>
 fn=<function name>
 <file>:<line>
 reason=<에러 설명>
 recovery=<권장 조치>
```

---

문의: **sdk-support@ghostpass.ai**
