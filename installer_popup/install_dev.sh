#!/bin/bash

# Claude Code Installer for macOS (Developer Edition with Docker)
# Usage: chmod +x install_dev.sh && ./install_dev.sh

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Claude Code 설치 프로그램 (Docker)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 상태 출력 함수
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_installing() {
    echo -e "${YELLOW}→${NC} $1 설치 중..."
}

print_skip() {
    echo -e "${GREEN}✓${NC} $1 (이미 설치됨)"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Homebrew 설치 확인 및 설치
install_homebrew() {
    if command -v brew &> /dev/null; then
        print_skip "Homebrew"
    else
        print_installing "Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Apple Silicon Mac의 경우 PATH 추가
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        print_status "Homebrew 설치 완료"
    fi
}

# Node.js 설치 확인 및 설치
install_nodejs() {
    if command -v node &> /dev/null; then
        print_skip "Node.js ($(node --version))"
    else
        print_installing "Node.js"
        brew install node
        print_status "Node.js 설치 완료"
    fi
}

# Git 설치 확인 및 설치
install_git() {
    if command -v git &> /dev/null; then
        print_skip "Git ($(git --version | cut -d' ' -f3))"
    else
        print_installing "Git"
        brew install git
        print_status "Git 설치 완료"
    fi
}

# VS Code 설치 확인 및 설치
install_vscode() {
    if [ -d "/Applications/Visual Studio Code.app" ] || command -v code &> /dev/null; then
        print_skip "VS Code"
    else
        print_installing "VS Code"
        brew install --cask visual-studio-code
        print_status "VS Code 설치 완료"
    fi
}

# Claude Code CLI 설치
install_claude_cli() {
    print_installing "Claude Code CLI"
    npm install -g @anthropic-ai/claude-code
    print_status "Claude Code CLI 설치 완료"
}

# VS Code 확장 설치
install_vscode_extension() {
    print_installing "VS Code Claude 확장"

    if command -v code &> /dev/null; then
        code --install-extension anthropic.claude-code
        print_status "VS Code Claude 확장 설치 완료"
    else
        VSCODE_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        if [ -f "$VSCODE_PATH" ]; then
            "$VSCODE_PATH" --install-extension anthropic.claude-code
            print_status "VS Code Claude 확장 설치 완료"
        else
            print_warning "VS Code를 열고 Command Palette에서 'Shell Command: Install code command' 실행 후"
            echo "   다시 시도해주세요."
        fi
    fi
}

# Docker Desktop 설치
install_docker() {
    if [ -d "/Applications/Docker.app" ] || command -v docker &> /dev/null; then
        print_skip "Docker Desktop"
    else
        print_installing "Docker Desktop"
        brew install --cask docker
        print_status "Docker Desktop 설치 완료"
    fi
}

# 메인 설치 프로세스
main() {
    echo "설치를 시작합니다..."
    echo ""

    # Homebrew 설치 전 sudo 비밀번호 미리 요청
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}→${NC} Homebrew 설치를 위해 관리자 비밀번호가 필요합니다."
        sudo -v
        # sudo 타임아웃 방지
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi

    # 기본 도구 설치
    install_homebrew
    install_nodejs
    install_git
    install_vscode
    install_claude_cli
    install_vscode_extension

    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}   Docker 환경 설치${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""

    # Docker 설치
    install_docker

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   모든 설치가 완료되었습니다!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""

    # Docker가 새로 설치된 경우 안내
    if [ ! -d "/Applications/Docker.app" ] 2>/dev/null; then
        echo -e "${YELLOW}중요: Docker Desktop 설정이 필요합니다${NC}"
        echo ""
        echo "다음 단계:"
        echo "  1. Docker Desktop을 실행합니다"
        echo "  2. 라이선스에 동의합니다"
        echo "  3. Docker가 시작될 때까지 기다립니다"
        echo "  4. 그 후 MCP 설정 스크립트를 실행합니다"
        echo ""
    else
        echo "다음 단계:"
        echo "  1. Docker Desktop을 실행하고 라이선스에 동의합니다"
        echo "  2. VS Code를 실행합니다"
        echo "  3. 왼쪽 사이드바에서 Claude 아이콘을 클릭합니다"
        echo "  4. 로그인을 진행합니다"
        echo ""
        echo "또는 터미널에서 'claude' 명령어를 실행하세요."
        echo ""
    fi

    # 시작 가이드 열기
    read -p "시작 가이드 페이지를 열까요? (Y/n): " open_guide < /dev/tty
    if [[ "$open_guide" != "n" && "$open_guide" != "N" ]]; then
        open "https://bkamp.ai/ko/showcases/de04a7ec-50d7-4f8e-a741-f2cdb4753543"
    fi

    # Docker Desktop 열기
    read -p "Docker Desktop을 열까요? (Y/n): " open_docker < /dev/tty
    if [[ "$open_docker" != "n" && "$open_docker" != "N" ]]; then
        open -a "Docker"
    fi
}

# 스크립트 실행
main
