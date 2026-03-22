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

## 5. FIXME 탐지 및 개선 계획

구현 완료 후 AI 코드 리뷰를 진행했고, 요구 사항, 예외 및 에러 처리, 안정성 개선 목록을 정리

**식별된 FIXME 목록:**

| # | 파일 | 문제 유형 | 심각도 | 상태 |
|---|------|-----------|--------|------|
| 1 | `HomeViewModel.swift` | `selectRecentQuery(_:)` 호출 시 즉시 검색과 디바운스 검색이 겹쳐 같은 질의가 중복 요청될 수 있음 | 🟡 Medium | 수정 완료 |
| 2 | `APIConfiguration.swift` | API 키 누락 시 `assertionFailure` 후 빈 문자열 헤더로 요청이 계속 진행되어 설정 오류와 네트워크 오류 구분이 어려움 | 🔴 High | 미수정 |
| 3 | `ImageSearchResponseDTO.swift` | `id`를 `imageURL.absoluteString` 하나에만 의존해 서로 다른 문서가 동일 결과로 취급될 수 있음 | 🔴 High | 수정 완료 |
| 4 | `HomeViewModel.swift` | 앱 시작 시 최근 검색어와 북마크를 동시에 즉시 로드해 첫 상호작용 시 체감 지연 가능성이 있음 | 🟡 Medium | 수정 완료 |
| 5 | `BookmarkStore.swift` | 저장 데이터 디코딩 실패 시 조용히 빈 배열로 대체되어 북마크 손실처럼 보일 수 있음 | 🟡 Medium | 미수정 |
| 6 | `NetworkClient.swift` | `DecodingError` 상세 정보를 버리고 단일 `decodingFailed`로만 처리해 장애 분석이 어려움 | 🟡 Medium | 미수정 |

---

## 개발 환경

- Xcode 26.3
- Swift 6
- iOS 17.0+
- SwiftUI
- URLSession 기반 네트워크 통신
- 외부 라이브러리 사용 없음

