# POPUP STUDIO Claude Code Installer

Claude Code와 Atlassian MCP Server를 설치하고 설정하는 스크립트입니다.

## 파일 구조

```
installer_popup/
├── README.md
│
├── # Windows용 스크립트
├── install.ps1         # 비개발자용 (기본 설치)
├── install_dev.ps1     # 개발자용 (Docker 포함)
├── setup.ps1           # MCP 설정
│
├── # Mac용 스크립트
├── install.sh          # 비개발자용 (기본 설치)
├── install_dev.sh      # 개발자용 (Docker 포함)
└── setup.sh            # MCP 설정
```

## 설치 방법

### Windows

#### 1단계: 도구 설치

**비개발자:**
```powershell
powershell -ep bypass -File install.ps1
```

**개발자:**
```powershell
powershell -ep bypass -File install_dev.ps1
```
설치 완료 후 **재부팅** 필요. 재부팅 후 Docker Desktop 실행하고 라이선스 동의.

#### 2단계: MCP 설정
```powershell
powershell -ep bypass -File setup.ps1
```

---

### Mac

#### 1단계: 도구 설치

**비개발자:**
```bash
chmod +x install.sh && ./install.sh
```

**개발자:**
```bash
chmod +x install_dev.sh && ./install_dev.sh
```
설치 후 Docker Desktop 실행하고 라이선스 동의. (재부팅 불필요)

#### 2단계: MCP 설정
```bash
chmod +x setup.sh && ./setup.sh
```

---

## MCP 설정 안내

setup 스크립트 실행 중 선택/입력할 정보:

1. **직군 선택**
   - 1: 개발자
   - 2: 비개발자

2. **MCP Server 선택**
   - 1: Rovo MCP Server (추천, 간편 설정)
   - 2: mcp-atlassian (Docker 필요, 고급 기능)

3. **Atlassian 정보 입력** (mcp-atlassian 선택 시)
   - Confluence URL: `https://popupstudio.atlassian.net/wiki`
   - Confluence 이메일 / API 토큰
   - Jira URL: `https://popupstudio.atlassian.net`
   - Jira 이메일 / API 토큰
   - API 토큰 발급: https://id.atlassian.com/manage-profile/security/api-tokens

4. **사용 범위 선택** (mcp-atlassian 선택 시)
   - 1: Global (모든 프로젝트에서 사용)
   - 2: Local (현재 프로젝트에서만 사용)

## 테스트

```bash
claude
```

실행 후:
```
> Jira 프로젝트 목록 보여줘
> Confluence에서 회의록 찾아줘
```

## 비개발자 vs 개발자 비교

| 항목 | 비개발자 (install) | 개발자 (install_dev) |
|------|-------------------|---------------------|
| Node.js | ✅ | ✅ |
| Git | ✅ | ✅ |
| VS Code | ✅ | ✅ |
| Claude Code CLI | ✅ | ✅ |
| VS Code 확장 | ✅ | ✅ |
| WSL (Windows만) | ❌ | ✅ |
| Docker Desktop | ❌ | ✅ |
| 재부팅 필요 (Windows) | ❌ | ✅ |

## MCP Server 비교

| 항목 | Rovo MCP Server | mcp-atlassian |
|------|-----------------|---------------|
| 설정 시간 | 2분 | 15분 |
| 인증 방식 | OAuth (브라우저) | API 토큰 |
| Docker 필요 | ❌ | ✅ |
| Jira 연동 | ✅ | ✅ |
| Confluence 연동 | ✅ | ✅ |
| 프로젝트 필터링 | ❌ | ✅ |
| 읽기 전용 모드 | ❌ | ✅ |
| 추천 대상 | 비개발자 | 개발자 |
