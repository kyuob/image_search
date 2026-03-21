import Foundation

struct ImageSearchRepository: ImageSearchRepositoryProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func searchImages(query: String) async throws -> [SearchImage] {
        let request = APIRequest<ImageSearchResponseDTO>(
            path: "/v2/search/image",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "size", value: "30")
            ]
        )

        let response = try await networkClient.send(request)
        return response.documents.map { $0.toEntity() }
    }
}

/*
 이미지 검색
 기본 정보
 메서드    URL    인증 방식
 GET    https://dapi.kakao.com/v2/search/image    REST API 키
 권한    사전 설정    카카오 로그인    동의항목
 -    REST API 키    -    -

 다음 검색 서비스에서 질의어로 이미지를 검색합니다. REST API 키를 헤더에 담아 GET으로 요청합니다. 원하는 검색어와 함께 결과 형식 파라미터를 선택적으로 추가할 수 있습니다. 응답 본문은 meta, documents로 구성된 JSON 객체입니다.

 요청
 헤더
 이름    설명    필수
 Authorization    Authorization: KakaoAK ${REST_API_KEY}
 인증 방식, 서비스 앱에서 REST API 키로 인증 요청    O
 쿼리 파라미터
 이름    타입    설명    필수
 query    String    검색을 원하는 질의어    O
 sort    String    결과 문서 정렬 방식, accuracy(정확도순) 또는 recency(최신순), 기본 값 accuracy    X
 page    Integer    결과 페이지 번호, 1~50 사이의 값, 기본 값 1    X
 size    Integer    한 페이지에 보여질 문서 수, 1~80 사이의 값, 기본 값 80    X
 응답
 본문
 이름    타입    설명
 meta    Meta    응답 관련 정보
 documents    Document[]    응답 결과
 Meta
 이름    타입    설명
 total_count    Integer    검색된 문서 수
 pageable_count    Integer    total_count 중 노출 가능 문서 수
 is_end    Boolean    현재 페이지가 마지막 페이지인지 여부, 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
 Document
 이름    타입    설명
 collection    String    컬렉션
 thumbnail_url    String    미리보기 이미지 URL
 image_url    String    이미지 URL
 width    Integer    이미지의 가로 길이
 height    Integer    이미지의 세로 길이
 display_sitename    String    출처
 doc_url    String    문서 URL
 datetime    Datetime    문서 작성시간, ISO 8601
 [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
 예제
 요청
 curl -v -G GET "https://dapi.kakao.com/v2/search/image" \
 --data-urlencode "query=설현" \
 -H "Authorization: KakaoAK ${REST_API_KEY}"
 응답
 HTTP/1.1 200 OK
 Content-Type: application/json;charset=UTF-8
 {
   "meta": {
     "total_count": 422583,
     "pageable_count": 3854,
     "is_end": false
   },
   "documents": [
     {
       "collection": "news",
       "thumbnail_url": "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
       "image_url": "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg",
       "width": 540,
       "height": 457,
       "display_sitename": "한국경제TV",
       "doc_url": "http://v.media.daum.net/v/20170621155930002",
       "datetime": "2017-06-21T15:59:30.000+09:00"
     },
     ...
   ]
 }
 
 */
