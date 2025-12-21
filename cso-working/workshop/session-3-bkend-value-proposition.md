# Session 3: bKend Value Proposition
## 팀 워크샵 2024.12.15-16

---

# bKend는 무엇인가?

---

## 한 줄 정의

> **"Vibe Coding 시대의 백엔드 자동화 플랫폼"**

AI 빌더를 위한 Multi-tenant BaaS

---

## 제품 개요

| 항목 | 내용 |
|------|------|
| **제품명** | bKend (bkend.ai) |
| **기술 스택** | Node.js, AWS Lambda, MongoDB |
| **포지션** | AI-Native BaaS |
| **핵심 타겟** | AI 빌더, Vibe Coder, 1인 개발자 |

---

# 우리가 해결하는 문제

---

## Vibe Coding의 현실

### Vibe Coding이란?
- AI와 대화하며 코드 작성
- Cursor, Claude Code, GitHub Copilot 등 사용
- 프론트엔드는 빠르게 만들 수 있음

### 문제: 백엔드의 벽
- 프론트는 10분, 백엔드는 10일
- 인증, DB, API... 매번 반복
- AI가 만들어줘도 배포가 문제

---

## 현재 대안들의 한계

### Supabase / Firebase
- ✅ 빠른 시작
- ❌ Multi-tenancy 직접 구현 필요
- ❌ AI Agent 최적화 안됨

### Vercel / Railway
- ✅ 쉬운 배포
- ❌ 백엔드 로직은 직접 구현
- ❌ 여전히 개발 필요

### 직접 개발
- ✅ 완전한 컨트롤
- ❌ 시간 많이 소요
- ❌ 인프라 관리 부담

---

## bKend가 채우는 Gap

```
Vibe Coding으로        [ Gap ]        실제 서비스
프론트 완성     ←---------------→      운영
AI가 코드 생성                        백엔드 필요
빠른 프로토타입                       인증/DB/API
```

**bKend = Vibe Coding의 마지막 퍼즐**

---

# Target Customer

---

## Primary: AI 빌더 / Vibe Coder

### 페르소나 1: 1인 개발자 "성민"
- 32세, 프리랜서 개발자
- Pain Point: "프론트는 Cursor로 금방 만드는데, 백엔드 세팅이 매번 귀찮아"
- 현재 해결책: Supabase + 커스텀 로직
- bKend 사용 시: 원클릭으로 Multi-tenant 백엔드 생성

### 페르소나 2: 테크 스타트업 CTO "지원"
- 29세, 초기 스타트업 CTO (개발자 2명)
- Pain Point: "MVP 빨리 만들어야 하는데 백엔드에 시간 너무 쓰고 있어"
- 현재 해결책: Firebase + 노가다
- bKend 사용 시: 프로덕션 레디 백엔드 즉시 사용

---

## Secondary: AI Agent 개발자

### 페르소나 3: AI 프로덕트 매니저 "현우"
- 35세, AI 스타트업 PM
- Pain Point: "AI Agent가 사용할 백엔드 API가 필요한데 개발팀 리소스가 없어"
- 현재 해결책: 외주 또는 대기
- bKend 사용 시: AI Agent 전용 API 엔드포인트 즉시 생성

---

# Value Proposition

---

## 핵심 가치 제안

### 1. Multi-tenancy 기본 제공
- SaaS 구조 기본 탑재
- 테넌트별 데이터 격리
- 사용자 관리 자동화

### 2. AI Agent 최적화
- MCP 서버 기본 연동
- AI가 이해하기 쉬운 API 구조
- 자연어로 API 호출 가능

### 3. Zero-Config 배포
- 코드 없이 백엔드 생성
- 자동 스케일링
- 관리형 인프라

---

## 경쟁 제품 비교

| 기능 | Firebase | Supabase | Railway | **bKend** |
|------|----------|----------|---------|-----------|
| 빠른 시작 | ✅ | ✅ | ⚠️ | ✅ |
| Multi-tenancy | ❌ | ❌ | ❌ | ✅ |
| AI Agent 최적화 | ❌ | ❌ | ❌ | ✅ |
| 코드 없이 API | ⚠️ | ⚠️ | ❌ | ✅ |
| 한국어 지원 | ❌ | ❌ | ❌ | ✅ |

**bKend = BaaS + Multi-tenancy + AI-Native**

---

# 시장 기회

---

## TAM / SAM / SOM

| 구분 | 규모 | 설명 |
|------|------|------|
| **TAM** | $5-18B (2025) | 전체 BaaS 시장 |
| **SAM** | $0.75-1B | AI-Native 개발자 세그먼트 |
| **SOM** | $30-50M | 초기 타겟 (한국 + 아시아) |

### 왜 지금인가?
- Vibe Coding 트렌드 급성장
- Cursor 사용자 1M+ 돌파
- AI Agent 개발 수요 폭발

---

# 12/11 Closed Beta 현황

---

## 출시 범위

- ✅ Builder Console (빌더 관리 화면)
- ✅ 기본 인증 시스템
- ✅ 데이터베이스 자동 생성
- ✅ API 엔드포인트 생성
- ✅ End User 관리

## 수집할 피드백

- 온보딩 경험 (5분 내 첫 API 호출?)
- Multi-tenancy 이해도
- 실제 사용 케이스

---

# bKamp + bKend 시너지

---

## 통합 가치

```
bKamp (비개발자)          bKend (개발자)
     ↓                        ↓
AI Agent 사용      ←→      백엔드 제공
프론트엔드 생성    ←→      API 연동
     ↓                        ↓
         완전한 앱 개발 가능
```

### 시나리오
1. 기획자가 bKamp로 프론트 프로토타입 생성
2. 개발자가 bKend로 백엔드 연결
3. 둘이 합쳐서 실제 서비스 완성

---

# 토론 포인트

---

## 함께 논의할 질문들

1. **Multi-tenancy가 충분한 차별점인가?**
   - Supabase도 곧 지원할 수 있음
   - 더 강한 차별점은?

2. **AI-Native의 의미를 어떻게 구체화할까?**
   - MCP 연동만으로 충분한가?
   - AI Agent 전용 기능은?

3. **bKamp와의 통합 우선순위는?**
   - 각각 독립적으로 갈까?
   - 통합을 먼저 할까?

---

## bKend VP Canvas (함께 채우기)

| 항목 | 내용 (토론 후 결정) |
|------|---------------------|
| **Target Customer** | |
| **Problem** | |
| **Solution** | |
| **Unique Value** | |
| **Unfair Advantage** | |

---

# 세션 목표

이 세션이 끝나면:

1. ✅ bKend **Target Customer** 합의
2. ✅ bKend **핵심 Value Proposition** 합의
3. ✅ bKamp와의 **시너지 방향** 합의

---

# 다음 세션 예고

## Session 4: Q1 2025 목표 Alignment
- Q1 핵심 목표 설정
- 팀별 역할 분담
- 성공 지표 정의

---

*워크샵 자료 v1.0 - 2024.12.15-16*
