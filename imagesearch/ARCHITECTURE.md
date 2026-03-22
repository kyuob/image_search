# Image Search 앱 설명

## 프로젝트 개요

Kakao 이미지 검색 API를 사용해 이미지를 검색하고, 북마크한 이미지를 별도 탭에서 확인할 수 있는 iOS 앱입니다.

- Language: Swift 6
- Deployment Target: iOS 17.0
- UI Framework: SwiftUI
- External Dependency: 없음

검색어 입력 후 1초 동안 추가 입력이 없으면 자동으로 검색을 수행합니다. 검색 결과와 북마크 목록은 동일한 카드 UI로 보여주며, 북마크 상태를 바로 토글할 수 있게 구성했습니다.

---

## 실행 환경

- Xcode 26.3
- iOS 17.0+
- Swift Concurrency 기반 구현

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
├── Domain
│   ├── Entities
│   ├── Repositories
│   └── UseCases
├── Data
│   ├── DTO
│   ├── Repositories
│   └── Storage
└── Presentation
    ├── Common
    └── Home
```

---

## 아키텍처

Clean Architecture 흐름을 기준으로 아래처럼 구성했습니다.

```text
Presentation (SwiftUI View, ViewModel)
        ↓
Domain (Entity, Repository Protocol, UseCase)
        ↓
Data (Repository 구현, DTO, Bookmark 저장소)
        ↓
Core (NetworkClient, ImageLoader)
```

### Application
- `DIContainer`: 네트워크, 저장소, 유스케이스, 이미지 로더를 조립합니다.
- `AppEnvironment`: 화면 진입에 필요한 의존성을 묶어서 전달합니다.

### Core
- `NetworkClient`: `URLSession`을 직접 감싼 제네릭 네트워크 레이어입니다.
- `ImageLoader`: 외부 라이브러리 없이 이미지 다운로드와 메모리 캐시를 처리합니다.

### Domain
- `SearchImage`: 화면과 저장소가 공통으로 사용하는 엔티티입니다.
- `ImageSearchUseCase`, `BookmarkUseCase`: 화면이 직접 Data 레이어 구현을 모르도록 중간 역할을 둡니다.

### Data
- `ImageSearchRepository`: Kakao 이미지 검색 API 호출을 담당합니다.
- `BookmarkStore`: `UserDefaults` 기반 로컬 북마크 저장소입니다.

### Presentation
- `HomeViewModel`: 검색 디바운스, 로딩, 에러, 북마크 상태를 관리합니다.
- `HomeView`: 검색창 + 세그먼트 탭 + 결과 목록 화면입니다.

---

## 주요 구현 포인트

### 1. 1초 검색 디바운스

검색 버튼 없이 입력이 멈춘 뒤 1초 후 자동 검색되도록 `Task.sleep` 기반 디바운스를 적용했습니다.

### 2. Swift Concurrency 적극 활용

- `NetworkClient`를 `actor`로 구성해 네트워크 요청 경계를 단순화
- `ImageLoader`를 `actor`로 구성해 이미지 캐시와 중복 요청 방지
- `BookmarkStore`를 `actor`로 구성해 북마크 저장/조회 직렬화
- ViewModel에서 검색 Task 취소와 재시작 처리

### 3. 제네릭 네트워크 레이어

`APIRequest<Response>`와 `NetworkClient.send(_:)` 조합으로 응답 타입별 디코딩을 공통 처리했습니다.

### 4. 자체 이미지 로더

외부 이미지 라이브러리 없이 직접 다운로드하고, 동일 URL 재요청 시 진행 중 Task를 재사용하도록 구현했습니다.

### 5. 결과/북마크 동일 UI

과제 요구사항에 맞게 검색 결과 목록과 북마크 목록 모두 같은 카드 UI와 비율 계산 방식을 사용했습니다.

### 6. API 키 분리

Kakao REST API 키는 코드에 직접 두지 않고 `Config/AppSecrets.xcconfig`에 분리하고, 런타임에는 Info.plist 값을 통해 읽도록 구성했습니다.

---

## 화면 동작

1. 상단 검색창에 검색어 입력
2. 1초 동안 입력이 멈추면 Kakao 이미지 검색 API 요청
3. 검색 결과를 세로 스크롤 목록으로 표시
4. 각 이미지 우측 상단 북마크 버튼으로 추가/해제
5. 하단 세그먼트에서 북마크 탭으로 전환해 저장 목록 확인

---

## 고려한 부분

- 검색어가 비어 있으면 API 호출하지 않음
- 검색 결과가 없거나 실패한 경우 사용자에게 안내
- 이미지 원본 비율을 유지하며 화면 폭 기준으로 표시
- 북마크 상태는 앱 재실행 후에도 유지

---

## 보완 가능 포인트

- 페이지네이션 추가
- 검색 정렬 옵션(정확도순/최신순) 제공
- 북마크 저장소를 파일/DB 기반으로 확장
- 테스트 코드 보강
