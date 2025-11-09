# Save Slack Thread Command

Slack의 중요한 스레드를 Confluence 페이지로 저장합니다.

## 사용법
```
/save-slack-thread
```

사용자가 Slack 스레드 내용을 붙여넣으면 Confluence 페이지로 변환합니다.

## 수행 작업

1. 사용자에게 다음을 요청:
   - Slack 스레드 내용 (복사해서 붙여넣기)
   - 페이지 제목 (자동 생성 제안 가능)
   - 관련 Jira 이슈 키 (선택사항)

**저장 위치**: 자동으로 "AI 정보 모음 > From Slack" 폴더에 저장
   - Space: "POPUPSTUDI"
   - Parent Page ID: 917578 (From Slack 폴더)

2. Slack 스레드 분석:
   - 대화 참여자 식별
   - 주요 논의 주제 파악
   - 의사결정 사항 추출
   - 액션 아이템 정리

3. Confluence 페이지 구조화:

```markdown
# [페이지 제목]

> 원본: Slack 스레드 ([날짜])
> 참여자: [참여자 목록]
> 관련 이슈: [Jira 이슈 링크]

## 논의 배경
[스레드의 컨텍스트 요약]

## 주요 논의 내용
[대화 내용을 구조화하여 정리]

### [주제 1]
- [요약]

### [주제 2]
- [요약]

## 의사결정 사항
- ✅ [결정 1]
- ✅ [결정 2]

## 액션 아이템
- [ ] [할 일 1] (@담당자)
- [ ] [할 일 2] (@담당자)

## 원본 대화 내용
<details>
<summary>전체 대화 보기</summary>

[Slack 스레드 원본]

</details>
```

4. mcp-atlassian을 사용하여:
   - Confluence에 페이지 생성
   - Space: "POPUPSTUDI", Parent ID: 917578 (From Slack 폴더)에 저장
   - 관련 Jira 이슈와 링크 (제공된 경우)

5. 결과 출력:
```
✅ Slack 스레드가 Confluence에 저장되었습니다!

**제목**: [페이지 제목]
**저장 위치**: AI 정보 모음 > From Slack
**링크**: [Confluence 페이지 URL]

💡 다음 단계:
1. Confluence 페이지를 검토하세요
2. 필요하면 추가 내용을 작성하세요
3. 팀원들과 공유하세요
4. 원본 Slack 스레드에 Confluence 링크를 공유하는 것을 잊지 마세요!
```

## 팁

### Slack에서 스레드 복사하는 방법
1. 스레드에서 "..." 메뉴 클릭
2. "Copy link to thread" 선택하여 링크 복사
3. 또는 스레드의 모든 메시지를 선택하여 복사

### 효과적인 문서화
- 너무 긴 스레드는 핵심만 요약
- 민감한 정보는 제외
- 이미지나 파일은 별도로 Confluence에 업로드
