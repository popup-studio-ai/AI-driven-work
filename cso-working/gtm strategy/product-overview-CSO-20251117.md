# 제품 개요 (Product Overview)

**작성일**: 2024-11-17
**출처**: JIRA, Confluence, GitHub, CSO 인터뷰

---

## 제품 포트폴리오

### 1. Lili Agent

#### 제품 설명
- **정의**: 비개발자도 쉽게 사용할 수 있는 Claude Code 기반 AI Agent GUI Wrapper
- **기술 스택**: Flutter
- **핵심 가치**: AI Driven Work를 누구나 쉽게 접근하고 사용할 수 있게 만듦

#### 주요 기능
- 환경 설정 자동화
- 직관적인 채팅 인터페이스
- 터미널 통합 개발
- Firebase 연동
- Jira & Confluence 연동 (MCP-Atlassian)

#### 타겟 사용자
- AI를 활용하고 싶은 빌더들
- 바이브코딩을 하는 크리에이터들
- 개발 환경 설정에 어려움을 겪는 사람들
- PM, 디자이너, 마케터 등 비개발 직군

#### 개발 현황 (2024-11-17 기준)
- 상태: MVP 개발 중
- Epic: PS-220 (Lili Agent MVP 출시)
- 주요 Task: PS-221 (Lili Agent 개발)
- 계획:
  1. 사내 도입 및 테스트 (PS-222)
  2. 피드백 기반 고도화 (PS-223)
  3. 외부 출시 (PS-224)

---

### 2. bKend

#### 제품 설명
- **정의**: AI 기반 Multi-tenant Backend as a Service (BaaS) 플랫폼
- **핵심 가치**: 복잡한 백엔드 인프라 구축 없이 아이디어를 빠르게 실현
- **포지셔닝**: "바이브코딩을 위한 백엔드 자동화"

#### 주요 기능

**1. Organization & Project Management**
- 조직 멤버 초대 및 관리
- 역할 기반 권한 관리 (OWNER, ADMIN, MEMBER)
- 프로젝트 조직 이관
- 이메일 초대 시스템 (AWS SES)

**2. Database Management**
- 테이블 생성 및 스키마 관리
- 데이터 CRUD
- Field 관리
- 실시간 데이터 동기화

**3. Authentication & Users**
- Email/Password 인증
- OAuth (Google, GitHub)
- End User 관리
- 권한 관리

**4. Storage**
- 파일 업로드/다운로드
- Content File API
- 용량 관리

**5. Functions**
- 서버리스 함수 실행
- API 엔드포인트 자동 생성

**6. Monitoring & Analytics**
- Activity 추적
- 사용량 통계
- 성능 모니터링

#### 타겟 사용자
- AI를 활용하는 빌더들
- 백엔드 인프라가 필요한 스타트업/개인
- 바이브코딩으로 빠르게 프로토타입을 만들고 싶은 사람들
- 기술 창업자 (Tech Founders)
- 개발 리소스가 제한된 팀

#### 개발 현황 (2024-11-17 기준)
- 상태: 1차 개발 진행 중
- Epic: PS-227 (bkend 1차 개발 - 11/22 빌더톤 대응)
- 주요 작업:
  - BFF 서버 개발 및 프론트엔드 연동 (PS-2)
  - Builder Web Console IA & UX 개선
  - Database, Auth, Storage 페이지 고도화
  - API 배포 (Business, Activity, Content File, User 등)

#### 기술 스택
- Backend: Node.js, AWS Lambda, MongoDB Atlas
- Frontend: Next.js, React
- Infrastructure: AWS (CloudFront, S3, SES, CloudWatch)
- CI/CD: GitHub Actions

---

## 제품 간 시너지

### 사용 흐름
```
사용자 → Lili Agent (업무 수행) → bKend 호출 (백엔드 필요시)
```

**시나리오 예시:**
1. 사용자가 Lili Agent에서 "새로운 Todo 앱 만들어줘" 요청
2. Lili Agent가 프론트엔드 코드 생성
3. 데이터 저장 필요 시 bKend API 자동 연동
4. bKend에서 Database, Auth, Storage 제공
5. 즉시 배포 가능한 풀스택 앱 완성

### 통합 가치 제안
"아이디어부터 배포까지, AI가 함께하는 최단 경로"
- Lili: 개발 과정의 진입장벽 제거
- bKend: 인프라 구축의 복잡성 제거
- 결합: 비개발자도 몇 시간 만에 실제 동작하는 서비스 론칭 가능

---

## 시장 및 경쟁 환경

### 타겟 시장
- **1차 시장**: 한국 (국내 우선)
- **확장 시장**: 글로벌 (처음부터 글로벌 고려한 설계)
- **시장 규모**:
  - AI Agent 시장: $7.38B (2025) → $103.6B (2032 전망)
  - BaaS 시장: 고성장 중 (Supabase 시리즈 B $80M, 2023)

### 경쟁사 분석

#### bKend 경쟁사
**1. Supabase (주요 경쟁자)**
- 오픈소스 Firebase 대안
- PostgreSQL 기반
- 강점: 개발자 친화적, 강력한 커뮤니티
- 약점: AI 네이티브 아님, 복잡한 설정

**2. Firebase (Google)**
- 가장 대중적인 BaaS
- 강점: Google 생태계, 방대한 문서
- 약점: 가격, 벤더락인, NoSQL 제약

**3. AWS Amplify**
- AWS 통합 BaaS
- 강점: AWS 서비스 깊은 통합
- 약점: 높은 러닝커브, 복잡성

**4. 기타**: Appwrite, Nhost, PocketBase

#### Lili Agent 경쟁사
- **특정하기 어려운 이유**: Claude Code wrapper는 새로운 카테고리
- **잠재 경쟁자 후보**:
  - Cursor (AI 코드 에디터)
  - GitHub Copilot Workspace
  - Replit Agent
  - v0.dev (Vercel)
  - Bolt.new
- **차별점**: GUI 기반 래퍼, 비개발자 친화적, 통합 워크플로우

### 차별화 포인트

#### bKend
1. **AI-Native**: AI 기반 자동 설정 및 최적화
2. **바이브코딩 최적화**: 빠른 프로토타이핑에 특화
3. **통합 경험**: Lili Agent와 seamless 연동
4. **한국어 지원**: 국내 시장 우선 전략

#### Lili Agent
1. **Zero Setup**: 환경 설정 완전 자동화
2. **GUI 우선**: CLI 두려움 제거
3. **통합 워크플로우**: Jira, Confluence 기본 연동
4. **협업 친화**: 비개발자도 참여 가능한 개발 프로세스

---

## 비즈니스 모델

### 가격 전략 (초안)

#### 티어 구조

**1. Trial (14일 무료)**
- 모든 기능 체험
- 제한된 리소스
- 목적: 제품 이해 및 전환 유도

**2. Free Tier (제한적 무료)**
- 개인 프로젝트 1개
- 기본 AI 토큰 포함 (월 10,000 토큰)
- Storage: 500MB
- Database: 100MB
- End Users: 100명
- 목적: 취미 프로젝트, 학습자, 바이럴

**3. Personal ($19-29/월)**
- 프로젝트 5개
- AI 토큰: 월 100,000 토큰 포함
- Storage: 5GB
- Database: 1GB
- End Users: 1,000명
- 우선순위 지원
- 목적: 개인 빌더, 프리랜서

**4. Team ($99-149/월, 팀원당 추가)**
- 프로젝트 무제한
- AI 토큰: 월 500,000 토큰 포함
- Storage: 50GB
- Database: 10GB
- End Users: 10,000명
- 팀 협업 기능
- 역할 기반 권한
- 우선 지원 + Slack 연동
- 목적: 스타트업, 중소 팀

**5. Enterprise (커스텀 가격)**
- 모든 것 무제한
- 전용 인프라 옵션
- SLA 보장
- 전담 매니저
- 커스텀 통합
- 온프레미스 옵션
- 목적: 대기업, 규제 산업

#### 추가 과금 옵션
- **AI 토큰**: 기본 제공 초과 시 $0.01/1,000 토큰
- **Storage**: $0.05/GB
- **Database**: $0.10/GB
- **End Users**: $0.01/user (월별)
- **함수 실행**: $0.20/1M 실행
- **대역폭**: $0.10/GB

#### 할인 정책
- **연간 결제**: 20% 할인
- **얼리버드**: 론칭 후 3개월, 50% 할인
- **학생/비영리**: 50% 할인
- **레퍼럴**: 추천인/피추천인 모두 1개월 무료

### 수익 모델
1. **구독 수익** (MRR/ARR)
2. **사용량 기반 수익** (AI 토큰, Storage 등)
3. **엔터프라이즈 라이선스**
4. **(장기) 마켓플레이스 수수료** (템플릿, 플러그인)

### 목표 지표 (1월 론칭 기준)
- **베타 가입자**: 100-200명
- **론칭 1주차 가입**: 500-1,000명
- **론칭 1개월 Paid 전환**: 20-50명
- **초기 MRR 목표**: $1,000-3,000
- **CAC 목표**: <$50
- **예상 LTV**: >$500 (연간 구독 기준)

---

## 주요 성과 사례 (내부)

### AI Driven Work 도입 성과
- 팀 전체 생산성 향상
- Jira/Confluence 자동화로 업무 효율 개선
- Claude Code 활용한 개발 속도 증가

### 내부 사용 중인 기술
- Claude Code (AI Agent)
- MCP-Atlassian (Jira & Confluence 연동)
- GitHub (코드 관리)
- Slack (커뮤니케이션)

---

## 론칭 계획

### 마일스톤
- **2024년 11월 22일**: 빌더톤 대응 (bKend 1차 개발 완료)
- **2024년 12월 말**: 베타 테스터 모집 시작
- **2025년 1월 2주**: 소프트 론칭
- **2025년 1월 4주**: 공식 론칭

### 론칭 전략
1. **사내 우선**: POPUP STUDIO 내부 전 직원 사용
2. **Zero100 파트너**: Zero100 참가자들 베타 테스터
3. **커뮤니티 확산**: 기술 커뮤니티, 개발자 그룹
4. **미디어 노출**: 테크 미디어, 인플루언서
5. **글로벌 확장**: Product Hunt, Hacker News 등

---

## 브랜드 자산

### bKend
- **브랜드 컬러**: 오렌지 (#FF7023)
- **포지셔닝**: "바이브코딩을 위한 백엔드 자동화"
- **톤앤매너**: 전문적이면서도 접근하기 쉬운
- **웹사이트**: https://www.bkend.ai

### Lili Agent
- **브랜드 컬러**: 오렌지 (#FF7023)
- **포지셔닝**: "누구나 쉽게 사용하는 AI 에이전트"
- **톤앤매너**: 친근하고 도움이 되는
- **로고**: Lili Agent 전용 로고

---

## 참고 자료

### 내부 문서
- JIRA Epic: PS-220 (Lili Agent), PS-227 (bKend)
- Confluence: BKEND 마케팅 전략 및 세부 실행 계획
- GitHub:
  - popup-studio-ai/AI-driven-work
  - popup-studio-ai/bkend-business-api
  - popup-studio-ai/bkend-builder-console-web

### 외부 참고
- Supabase: https://supabase.com
- Firebase: https://firebase.google.com
- Cursor: https://cursor.sh
- Anthropic Claude: https://claude.ai

---

**Last Updated**: 2024-11-17
**Next Review**: 2024-11-24 (주간 업데이트)
