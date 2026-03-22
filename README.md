# Image Search iOS App

---

## 프로젝트 개요

Kakao 이미지 검색 API를 사용해 이미지를 검색하고, 북마크한 이미지를 별도 탭에서 다시 확인할 수 있는 SwiftUI 기반 iOS 앱입니다.

- Clean Architecture 스타일 구조 분리
- Swift 6 Concurrency 기반 비동기 처리
- 이미지 검색 기능과 검색 결과 북마크 기능

---

## 실행 환경

Xcode 26.3
Swift 6
iOS 17.0+
SwiftUI

---

## 프로젝트 구조

```text
imagesearch/
├── Application
│   ├── AppEnvironment.swift
│   └── DIContainer.swift
├── Core
│   ├── ImageLoader
│   └── Network
├── Data
│   ├── DTO
│   ├── Repositories
│   └── Storage
├── Domain
│   ├── Entities
│   ├── Repositories
│   └── UseCases
├── Presentation
│   ├── Common
│   └── Home
├── AI_PLAN.md
└── ARCHITECTURE.md
```

---

## 주요 기능

- 검색어 입력 후 1초 동안 추가 입력이 없으면 자동 검색
- 검색 결과 / 북마크 하단 탭 전환
- 이미지 비율 유지 카드 UI
- 북마크 추가 / 해제 및 앱 재실행 후 유지
- 최근 검색어 3개 표시
- 카드 메타 정보 표시
  - 출처
  - 해상도
  - 날짜
  - 원문 링크

---

## 아키텍처

Clean Architecture + SwiftUI + Swift Concurrency

```text
Presentation (View, ViewModel)
       ↓
Domain (Entity, Repository Protocol, UseCase)
       ↓
Data (Repository 구현, DTO, Storage)
       ↓
Core (NetworkClient, ImageLoader)
```

| 레이어 | 역할 |
|--------|------|
| Application | DI 조립, 화면 진입 환경 구성 |
| Core | 네트워크 요청, 이미지 로딩, 공통 처리 |
| Domain | 엔티티, 유스케이스, 저장소 인터페이스 |
| Data | API 응답 매핑, 저장소 구현, 북마크 로컬 저장 |
| Presentation | 화면 상태 관리, 검색/북마크 UI |

---

## 핵심 구현 포인트

### 1. Swift Concurrency 기반 검색 흐름

- `Task.sleep` 기반 1초 디바운스
- 이전 검색 작업 취소
- `async/await` 기반 API 호출

### 2. actor 활용

- `NetworkClient`
- `ImageLoader`
- `BookmarkStore`

공유 상태가 있는 객체는 `actor`로 감싸서 동시성 경계를 단순하게 유지했습니다.

### 3. 외부 라이브러리 없는 이미지 로딩

`URLSession`과 메모리 캐시만으로 이미지 로더를 구현했습니다.
동일 URL 요청은 진행 중인 작업을 재사용하도록 구성했습니다.

### 4. UX

- 최근 검색어 표시
- 검색 결과 카드 메타 정보 강화
- 이미지 로딩 실패 시 재시도 UI 제공

---

## 화면 흐름

1. 검색창에 검색어 입력
2. 입력이 멈추면 자동 검색
3. 검색 결과 목록 표시
4. 카드에서 북마크 토글
5. 하단 탭에서 북마크 목록 확인

---

## 참고 문서

- [AI 활용 계획서 → imagesearch/AI_PLAN.md](./imagesearch/AI_PLAN.md)
- [아키텍처 문서 → imagesearch/ARCHITECTURE.md](./imagesearch/ARCHITECTURE.md)
