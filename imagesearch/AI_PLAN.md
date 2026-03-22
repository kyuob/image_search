# AI 활용 계획서

## 프로젝트

Image Search iOS 앱

---

## AI 활용 범위

VS Code 에서 앱 구조 설계를 위해 Codex 사용
Xcode 에서 코드 리뷰 및 개선을 위해 Codex 사용

---

## 1. 초기 구조 설계

- `Application / Core / Domain / Data / Presentation` 레이어 분리
- SwiftUI 단일 화면 구조에 맞춘 가벼운 DIContainer 사용
- 규모에 맞게 과한 패턴은 줄이고 필요한 책임만 분리

VS Code + Codex

---

## 2. 보일러플레이트 생성

반복적인 파일 생성과 기본 코드 뼈대를 만드는 데 AI를 활용했습니다.

- Repository Protocol / UseCase 기본 형식
- DTO, Entity, 네트워크 요청 객체 초안
- SwiftUI 화면 기본 구성

이후 실제 앱 요구사항에 맞게 네이밍, 상태 흐름, 화면 구성은 직접 수정

---

## 3. 동시성 및 구조 정리

Swift 6 Concurrency를 적극적으로 활용하기 위해 아래 항목들을 AI와 함께 검토

- `actor`를 어디에 적용할지
- 검색 디바운스와 이전 요청 취소 처리 방식
- 자체 이미지 로더에서 중복 요청을 줄이는 방식

최종 반영은 과제 요구사항과 코드 가독성을 기준으로 직접 정리

---

## 4. 마무리 점검

- 요구사항 누락 여부 점검
- 레이어 분리 과다 여부 확인
- 문서 정리 초안 작성 보조

Xcode + Codex

---

## 5. 과제 요구사항 구현 점검

과제에서 제시한 제약조건과 구현 요구사항을 기준으로 최종 상태를 점검

| # | 요구사항 | 구현 내용 | 상태 |
|---|---------|-----------|------|
| 1 | Language: Swift 6.0 이상 | Swift 6 기준으로 프로젝트 구성 | 구현 완료 |
| 2 | Deployment Target: iOS 17.0 이상 | iOS 17.0 이상 지원으로 설정 | 구현 완료 |
| 3 | Framework: SwiftUI | 전 화면을 SwiftUI 기반으로 구성 | 구현 완료 |
| 4 | Zero External Dependency | 외부 라이브러리 없이 구현 | 구현 완료 |
| 5 | Network: URLSession 직접 래핑한 Generic 네트워크 레이어 | `APIRequest<Response>` + `NetworkClient` 조합으로 구현 | 구현 완료 |
| 6 | Image Loading: 자체 Image Downloader 구현 | `ImageLoader`를 직접 구현하고 캐시 및 중복 요청 방지 처리 | 구현 완료 |
| 7 | DI: 자체 의존성 주입 구조 설계 | `DIContainer`, `AppEnvironment`로 직접 구성 | 구현 완료 |
| 8 | 형상관리 (Git): 작업 과정이 드러나는 커밋 히스토리 포함 | 단계별 작업 흐름이 드러나도록 문서 및 구조를 분리해 정리 | 구현 완료 |
| 9 | Kakao 이미지검색 API 사용 및 JSON 응답 처리 | Kakao 이미지 검색 API 호출 및 DTO 디코딩 처리 구현 | 구현 완료 |
| 10 | API Key는 개발자 본인이 직접 발급받아 사용 | `Info.plist`에서 API Key를 읽도록 구성 | 구현 완료 |
| 11 | 메인 화면 상단 검색어 필드 | 별도 검색 버튼 없이 입력 필드만 제공 | 구현 완료 |
| 12 | 검색 버튼 없음 | 검색 버튼 없이 자동 검색 흐름으로 구성 | 구현 완료 |
| 13 | 1초 이상 입력이 없을 경우 검색 수행 | `Task.sleep` 기반 1초 디바운스 검색 구현 | 구현 완료 |
| 14 | 검색 결과가 없거나 오류 발생 시 사용자 안내 | 빈 결과 및 오류 발생 시 alert / empty message 제공 | 구현 완료 |
| 15 | 하단 탭1: API 검색 결과 이미지 목록 | 검색 결과 전용 탭 구성 | 구현 완료 |
| 16 | 검색 결과 이미지 가로 폭은 화면 폭과 동일, 세로는 비율 유지 | 카드 너비는 화면 폭 기준, 세로는 이미지 비율에 맞게 조정 | 구현 완료 |
| 17 | 검색 결과에 북마크 버튼 UI 추가 | 카드 우측 상단 북마크 버튼 제공 | 구현 완료 |
| 18 | 북마크한 경우 체크 표기 노출 및 선택/해제 가능 | 북마크 배지 표시 및 토글 가능하도록 구현 | 구현 완료 |
| 19 | 하단 탭2: 북마크 이미지 목록 | 북마크 전용 탭 구성 | 구현 완료 |
| 20 | 사용자가 북마크한 이미지 목록 표기 | 로컬 저장된 북마크 목록 표시 | 구현 완료 |
| 21 | 북마크 표기 조건은 검색 결과 표기와 동일 | 동일 카드 UI와 동일 비율/북마크 표현 방식 사용 | 구현 완료 |

---

## 6. FIXME 탐지 및 개선 계획

구현 완료 후 AI 코드 리뷰를 진행했고, 요구 사항, 예외 및 에러 처리, 안정성 개선 목록을 정리

**식별된 FIXME 목록:**

| # | 파일 | 문제 유형 | 심각도 | 상태 |
|---|------|-----------|--------|------|
| 1 | `HomeViewModel.swift` | `selectRecentQuery(_:)` 호출 시 즉시 검색과 디바운스 검색이 겹쳐 같은 질의가 중복 요청될 수 있음 | 🟡 Medium | 수정 완료 |
| 2 | `APIConfiguration.swift` | API 키 누락 시 잘못된 Authorization 헤더로 요청이 진행될 수 있음 | 🔴 High | 수정 완료 |
| 3 | `ImageSearchResponseDTO.swift` | 결과 식별자를 단일 이미지 URL에만 의존하면 서로 다른 문서가 동일 결과로 취급될 수 있음 | 🔴 High | 수정 완료 |
| 4 | `HomeViewModel.swift` | 첫 화면 진입 시 준비 상태 표시가 없어 첫 입력 타이밍이 어색할 수 있음 | 🟡 Medium | 수정 완료 |
| 5 | `HomeView.swift` | 초기 화면 준비 중에도 사용자가 바로 터치할 수 있어 첫 상호작용 체감이 불안정할 수 있음 | 🟡 Medium | 수정 완료 |
| 6 | `HomeView.swift` | 첫 화면 준비가 끝난 뒤 검색창 자동 포커스가 없어 첫 입력 흐름이 한 번 더 끊길 수 있음 | 🟡 Medium | 수정 완료 |
| 7 | `HomeViewModel.swift`, `SearchResultListView.swift` | 앱 첫 진입 시 북마크를 미리 로드하지 않아 검색 결과 카드의 북마크 상태가 바로 반영되지 않을 수 있음 | 🟡 Medium | 미수정 |
| 8 | `BookmarkStore.swift` | 저장 데이터 디코딩 실패 시 조용히 빈 배열로 대체되어 북마크 손실처럼 보일 수 있음 | 🟡 Medium | 미수정 |
| 9 | `NetworkClient.swift` | `DecodingError` 상세 정보를 버리고 단일 `decodingFailed`로만 처리해 장애 분석이 어려움 | 🟡 Medium | 미수정 |
| 10 | `SearchImageCard.swift` | 카드가 `thumbnailURL`이 아닌 원본 `imageURL`을 직접 로드해 외부 호스트 품질에 영향을 크게 받을 수 있음 | 🟢 Low | 미수정 |
| 11 | `ImageSearchRepository.swift` | API 메뉴얼 전문 주석이 코드 안에 그대로 남아 있어 파일 가독성과 유지보수성이 떨어질 수 있음 | 🟢 Low | 미수정 |

---

## 개발 환경

- Xcode 26.3
- Swift 6
- iOS 17.0+
- SwiftUI
- URLSession 기반 네트워크 통신
- 외부 라이브러리 사용 없음
