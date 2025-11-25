# Sync Slashpage to Jira

Slashpage의 "🐛 버그 리포트"와 "새로운 기능 제안" 채널의 내용을 BKEND 프로젝트에 자동으로 티켓 생성합니다.

## 수행 작업

### 1. Slashpage 데이터 수집

두 채널에서 데이터를 수집합니다:

#### 🐛 버그 리포트
- **페이지 URL**: https://slashpage.com/bkend/dk58wg2egjzp32nqevxz
- **API URL**: https://slashpage.com/api/page/dk58wg2egjzp32nqevxz/channel/items?channelViewId=qp7my9&limit=50
- **Jira 이슈 타입**: Bug

```bash
curl -s "https://slashpage.com/api/page/dk58wg2egjzp32nqevxz/channel/items?channelViewId=qp7my9&limit=50" -H "Accept: application/json"
```

추출 정보:
- `user.nickname`: 작성자
- `note.title`: 버그 제목
- `note.content.snapshot.blockMap[].value.tokens[].text`: 버그 상세 설명
- `createdAt`: 작성 시간
- `note.customField`: 버그 타입, 심각도, OS 등
- `id`: 버그 리포트 고유 ID

#### 💡 새로운 기능 제안
- **페이지 URL**: https://slashpage.com/bkend/xjqy1g2v9qxy7m6vd54z
- **API URL**: https://slashpage.com/api/page/xjqy1g2v9qxy7m6vd54z/channel/items?channelViewId=qm3mrw&limit=50
- **Jira 이슈 타입**: Task

```bash
curl -s "https://slashpage.com/api/page/xjqy1g2v9qxy7m6vd54z/channel/items?channelViewId=qm3mrw&limit=50" -H "Accept: application/json"
```

추출 정보:
- `user.nickname`: 작성자
- `note.content.snapshot.blockMap[].value.tokens[].text`: 피드백 내용
- `createdAt`: 작성 시간
- `note.reactionSummary`: 공감/반응 수
- `id`: 피드백 고유 ID

**중요**: WebFetch는 캐시 문제가 있으므로, Bash tool로 curl을 사용하여 Slashpage API를 직접 호출해야 합니다.

### 2. Jira 중복 확인

각 채널별로 기존 BKEND 프로젝트 티켓 중 중복 확인:

**버그 리포트:**
```
project = BKEND AND description ~ "slashpage.com/bkend/dk58wg2egjzp32nqevxz"
```

**피드백:**
```
project = BKEND AND description ~ "slashpage.com/bkend/xjqy1g2v9qxy7m6vd54z"
```

- 각 항목의 제목/내용이 기존 티켓 description과 일치하는지 확인
- 중복이면 스킵, 새로운 항목만 티켓 생성

### 3. BKEND 프로젝트에 티켓 생성

**프로젝트**: BKEND
**백로그**: https://popupstudio.atlassian.net/jira/software/projects/BKEND/boards/35/backlog

#### 버그 티켓 템플릿
```
## 버그 설명
[버그 상세 설명]

## 재현 방법
[재현 단계 - 버그 내용에서 추출]

## 출처
- 채널: Slashpage - 🐛 버그 리포트
- 제보자: [작성자명]
- 제보일: [날짜]
- 링크: https://slashpage.com/bkend/dk58wg2egjzp32nqevxz

## 환경
- OS: [운영체제]
- 버그 타입: [카테고리]
- 심각도: [우선순위]
```

#### 피드백 티켓 템플릿
```
## 사용자 요청
[피드백 내용]

## 출처
- 채널: Slashpage - 새로운 기능 제안
- 작성자: [작성자명]
- 작성일: [날짜]
- 공감: [반응 수]
- 링크: https://slashpage.com/bkend/xjqy1g2v9qxy7m6vd54z

## 완료 기준
- [ ] 기능 구현 완료
- [ ] 테스트 완료
```

### 4. 결과 출력

채널별로 구분하여 다음 정보 표시:

**🐛 버그 리포트**
- 총 버그 리포트 수
- 신규 생성된 티켓 수
- 중복으로 스킵된 티켓 수
- 각 신규 티켓의 키, 제목, 링크, 제보자, 제보일

**💡 새로운 기능 제안**
- 총 피드백 수
- 신규 생성된 티켓 수
- 중복으로 스킵된 티켓 수
- 각 신규 티켓의 키, 제목, 링크, 작성자, 작성일

## 참고사항

### API 응답 구조

**버그 리포트:**
```json
{
  "status": "success",
  "data": {
    "list": [
      {
        "id": "버그리포트ID",
        "user": {
          "nickname": "작성자명"
        },
        "note": {
          "title": "버그 제목",
          "content": {
            "snapshot": {
              "blockMap": {
                "blockId": {
                  "value": {
                    "tokens": [
                      {"text": "버그 상세 내용"}
                    ]
                  }
                }
              }
            }
          },
          "customField": {
            "01kax6g0gpmgpqgxprzgw7a2zx": ["버그타입ID"],
            "01kax6psrwxgb26cade92p277b": 3,
            "01kax6r6h6asc3js74d04efpcz": ["OS_ID"]
          }
        },
        "createdAt": "2025-11-25T11:27:27.000Z"
      }
    ]
  }
}
```

**피드백:**
```json
{
  "status": "success",
  "data": {
    "list": [
      {
        "id": "피드백ID",
        "user": {
          "nickname": "작성자명"
        },
        "note": {
          "content": {
            "snapshot": {
              "blockMap": {
                "blockId": {
                  "value": {
                    "tokens": [
                      {"text": "피드백 내용"}
                    ]
                  }
                }
              }
            }
          },
          "reactionSummary": {}
        },
        "createdAt": "2025-11-25T08:19:39.000Z"
      }
    ]
  }
}
```

### 커스텀 필드 매핑 (버그 리포트)

- **버그 타입** (01kax6g0gpmgpqgxprzgw7a2zx): 카테고리 필드
  - 01kax6gxsgk97fv1xkrk6bq1ap: 로그인/계정
  - 01kax6hespypmm19y28zgc3n4a: 조직(Organization) 관리
  - 01kax6ka8xfng1efm12rrk7axb: 프로젝트(Project) 관리
  - 01kax6mpbsjzs8t4yxr69tncs6: mcp 서버
  - 01kax6n84n853w429swas2yptt: 서비스 운영
  - 01kax6nnfhsndepc3e34dm1eta: 기타

- **심각도** (01kax6psrwxgb26cade92p277b): 숫자 등급 (1-5)

- **OS** (01kax6r6h6asc3js74d04efpcz): 운영체제 카테고리
  - 01kax6rk6zj9hvcxyjyc9mazd1: WindowOS
  - 01kax6rpr0e5e0py16ejgdajm7: MacOS
  - 01kax6rth2mse0gk0nang9mbs0: 기타

### Jira 우선순위 매핑 (버그)

Slashpage 심각도를 Jira Priority로 매핑:
- 5 (매우 높음) → Highest
- 4 (높음) → High
- 3 (보통) → Medium
- 2 (낮음) → Low
- 1 (매우 낮음) → Lowest

### 주의사항

1. **API 호출**: WebFetch 대신 반드시 Bash + curl 사용
2. **내용 추출**: blockMap의 모든 블록의 tokens를 순회하여 전체 텍스트 조합
3. **날짜 변환**: ISO 형식을 한국 시간(KST)으로 변환하여 표시
4. **customField**: ID 값을 사람이 읽을 수 있는 형태로 변환
5. **버그 제목**: title 필드가 있으므로 Jira summary로 사용
6. **피드백 제목**: title이 없으므로 내용의 첫 줄이나 요약을 summary로 사용
7. **reactionSummary**: 빈 객체 `{}`이면 공감 0개로 처리
