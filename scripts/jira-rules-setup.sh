#!/bin/bash

# Jira Rules Setup Script
# AI-driven-work 프로젝트의 Jira 관련 기능을 다른 프로젝트에 추가합니다.
#
# Usage:
#   ./scripts/jira-rules-setup.sh <target-project-path> [--dry-run]
#
# Examples:
#   ./scripts/jira-rules-setup.sh ~/projects/my-web-app
#   ./scripts/jira-rules-setup.sh /path/to/project --dry-run

set -e

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 현재 스크립트의 디렉토리 (AI-driven-work 프로젝트 루트)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 소스 경로
SOURCE_COMMANDS_DIR="$SOURCE_PROJECT_DIR/.claude/commands"
SOURCE_INSTRUCTIONS_DIR="$SOURCE_PROJECT_DIR/.claude/instructions"
SOURCE_JIRA_RULES="$SOURCE_INSTRUCTIONS_DIR/jira-rules.md"

# 백업 디렉토리
BACKUP_DIR=""

# Dry-run 모드
DRY_RUN=false

# ============================================================
# 헬퍼 함수들
# ============================================================

# 사용법 표시
show_usage() {
    echo ""
    echo "Usage: $0 <target-project-path> [--dry-run]"
    echo ""
    echo "Examples:"
    echo "  $0 ~/projects/my-web-app"
    echo "  $0 /path/to/project --dry-run"
    echo ""
    exit 1
}

# 에러 메시지 출력 및 종료
error_exit() {
    echo -e "${RED}❌ 오류: $1${NC}" >&2
    exit 1
}

# 백업 생성
create_backup() {
    local target_file="$1"

    if [ ! -f "$target_file" ]; then
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${CYAN}[DRY-RUN]${NC} 백업 생성: $target_file"
        return 0
    fi

    local backup_file="${BACKUP_DIR}/$(basename "$target_file").backup"
    cp "$target_file" "$backup_file"
    echo -e "  💾 백업 생성: $(basename "$target_file")"
}

# 파일 복사 (충돌 처리 포함)
copy_file_with_conflict_handling() {
    local source_file="$1"
    local target_file="$2"
    local file_type="$3"  # "command" or "instruction"

    if [ ! -f "$source_file" ]; then
        echo -e "  ${YELLOW}⚠️  소스 파일이 존재하지 않습니다: $(basename "$source_file")${NC}"
        return 1
    fi

    # 타겟 파일이 이미 존재하는 경우
    if [ -f "$target_file" ]; then
        echo -e "  ${YELLOW}⚠️  $(basename "$target_file") 이미 존재합니다.${NC}"

        if [ "$DRY_RUN" = true ]; then
            echo -e "  ${CYAN}[DRY-RUN]${NC} 사용자에게 선택을 물어볼 예정"
            return 0
        fi

        echo -e "     ${CYAN}(o)${NC}덮어쓰기 / ${CYAN}(s)${NC}건너뛰기 / ${CYAN}(r)${NC}이름변경 / ${CYAN}(d)${NC}차이점 보기"
        read -p "     선택: " choice

        case "$choice" in
            o|O)
                create_backup "$target_file"
                cp "$source_file" "$target_file"
                echo -e "  ${GREEN}✅ $(basename "$target_file") 덮어쓰기 완료${NC}"
                return 0
                ;;
            s|S)
                echo -e "  ${BLUE}⏭️  $(basename "$target_file") 건너뜀${NC}"
                return 0
                ;;
            r|R)
                read -p "     새 파일명 (확장자 제외): " new_name
                local new_target="${target_file%.*}-${new_name}.${target_file##*.}"
                cp "$source_file" "$new_target"
                echo -e "  ${GREEN}✅ $(basename "$new_target") 생성 완료${NC}"
                return 0
                ;;
            d|D)
                echo ""
                echo "=========================================="
                echo "차이점:"
                echo "=========================================="
                diff "$target_file" "$source_file" || true
                echo "=========================================="
                echo ""
                # 재귀 호출로 다시 선택하게 함
                copy_file_with_conflict_handling "$source_file" "$target_file" "$file_type"
                return $?
                ;;
            *)
                echo -e "  ${BLUE}⏭️  잘못된 입력. 건너뜀${NC}"
                return 0
                ;;
        esac
    else
        # 타겟 파일이 없는 경우 - 그냥 복사
        if [ "$DRY_RUN" = true ]; then
            echo -e "  ${CYAN}[DRY-RUN]${NC} 복사: $(basename "$source_file") → $(basename "$target_file")"
        else
            cp "$source_file" "$target_file"
            echo -e "  ${GREEN}✅ $(basename "$target_file") 복사 완료${NC}"
        fi
        return 0
    fi
}

# instructions 파일에 jira-rules.md 참조 추가
add_jira_rules_reference() {
    local instruction_file="$1"
    local relative_path=".claude/instructions/jira-rules.md"

    # 이미 참조가 있는지 확인
    if grep -q "jira-rules.md" "$instruction_file" 2>/dev/null; then
        echo -e "  ${BLUE}ℹ️  $(basename "$instruction_file"): 이미 jira-rules.md 참조 존재${NC}"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${CYAN}[DRY-RUN]${NC} 참조 추가 예정: $(basename "$instruction_file")"
        return 0
    fi

    # 백업 생성
    create_backup "$instruction_file"

    # 파일 시작 부분에 참조 추가
    local temp_file="${instruction_file}.tmp"

    cat > "$temp_file" <<EOF
---

> **📋 Additional Instructions**: This project also follows Jira workflow rules.
> See: \`$relative_path\`

---

EOF

    cat "$instruction_file" >> "$temp_file"
    mv "$temp_file" "$instruction_file"

    echo -e "  ${GREEN}✅ $(basename "$instruction_file"): jira-rules.md 참조 추가 완료${NC}"
}

# ============================================================
# 메인 로직
# ============================================================

echo ""
echo "=========================================="
echo -e "${BLUE}🎯 Jira Rules Setup${NC}"
echo "=========================================="
echo ""

# 파라미터 확인
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ 타겟 프로젝트 경로를 입력해주세요.${NC}"
    show_usage
fi

TARGET_PROJECT_DIR="$1"

# Dry-run 옵션 확인
if [ $# -ge 2 ] && [ "$2" = "--dry-run" ]; then
    DRY_RUN=true
    echo -e "${CYAN}🔍 DRY-RUN 모드: 실제 변경 없이 미리보기만 수행합니다.${NC}"
    echo ""
fi

# 타겟 경로 절대 경로로 변환
TARGET_PROJECT_DIR="$(cd "$TARGET_PROJECT_DIR" 2>/dev/null && pwd)" || error_exit "타겟 디렉토리가 존재하지 않습니다: $1"

# 타겟 경로
TARGET_COMMANDS_DIR="$TARGET_PROJECT_DIR/.claude/commands"
TARGET_INSTRUCTIONS_DIR="$TARGET_PROJECT_DIR/.claude/instructions"
TARGET_JIRA_RULES="$TARGET_INSTRUCTIONS_DIR/jira-rules.md"

echo -e "${CYAN}소스 프로젝트:${NC} $SOURCE_PROJECT_DIR"
echo -e "${CYAN}타겟 프로젝트:${NC} $TARGET_PROJECT_DIR"
echo ""

# 소스 디렉토리 확인
if [ ! -d "$SOURCE_COMMANDS_DIR" ] || [ ! -d "$SOURCE_INSTRUCTIONS_DIR" ]; then
    error_exit "소스 프로젝트에 .claude 디렉토리가 없습니다. AI-driven-work 프로젝트에서 실행하세요."
fi

# 백업 디렉토리 생성
if [ "$DRY_RUN" = false ]; then
    BACKUP_DIR="$TARGET_PROJECT_DIR/.claude/.backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    echo -e "${GREEN}📦 백업 디렉토리 생성: $BACKUP_DIR${NC}"
    echo ""
fi

# ============================================================
# 1단계: Slash Commands 복사
# ============================================================
echo "=========================================="
echo -e "${BLUE}[1/4] Slash Commands 복사${NC}"
echo "=========================================="
echo ""

# 타겟 commands 디렉토리 생성
if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}[DRY-RUN]${NC} 디렉토리 생성: $TARGET_COMMANDS_DIR"
else
    mkdir -p "$TARGET_COMMANDS_DIR"
    echo -e "${GREEN}✅ 디렉토리 생성: $TARGET_COMMANDS_DIR${NC}"
fi
echo ""

# 각 command 파일 복사 (소스 디렉토리의 모든 .md 파일 자동 감지)
echo -e "${CYAN}소스 디렉토리에서 command 파일 검색 중...${NC}"
echo ""

COMMAND_COUNT=0
while IFS= read -r -d '' source_file; do
    cmd_file="$(basename "$source_file")"
    target_file="$TARGET_COMMANDS_DIR/$cmd_file"
    copy_file_with_conflict_handling "$source_file" "$target_file" "command"
    ((COMMAND_COUNT++))
done < <(find "$SOURCE_COMMANDS_DIR" -maxdepth 1 -type f -name "*.md" -print0 2>/dev/null)

if [ $COMMAND_COUNT -eq 0 ]; then
    echo -e "${YELLOW}⚠️  소스 디렉토리에 command 파일이 없습니다.${NC}"
else
    echo -e "${GREEN}✅ 총 ${COMMAND_COUNT}개의 command 파일 처리 완료${NC}"
fi

echo ""

# ============================================================
# 2단계: Jira 지침 복사
# ============================================================
echo "=========================================="
echo -e "${BLUE}[2/4] Jira 지침 복사${NC}"
echo "=========================================="
echo ""

# 타겟 instructions 디렉토리 생성
if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}[DRY-RUN]${NC} 디렉토리 생성: $TARGET_INSTRUCTIONS_DIR"
else
    mkdir -p "$TARGET_INSTRUCTIONS_DIR"
    echo -e "${GREEN}✅ 디렉토리 생성: $TARGET_INSTRUCTIONS_DIR${NC}"
fi
echo ""

# jira-rules.md 복사
copy_file_with_conflict_handling "$SOURCE_JIRA_RULES" "$TARGET_JIRA_RULES" "instruction"

echo ""

# ============================================================
# 3단계: 기존 instructions 파일에 참조 추가
# ============================================================
echo "=========================================="
echo -e "${BLUE}[3/4] 기존 Instructions 파일 확인${NC}"
echo "=========================================="
echo ""

# 타겟에 있는 다른 instruction 파일들 찾기
if [ -d "$TARGET_INSTRUCTIONS_DIR" ]; then
    OTHER_INSTRUCTIONS=()

    while IFS= read -r -d '' file; do
        # jira-rules.md는 제외
        if [ "$(basename "$file")" != "jira-rules.md" ]; then
            OTHER_INSTRUCTIONS+=("$file")
        fi
    done < <(find "$TARGET_INSTRUCTIONS_DIR" -maxdepth 1 -type f -name "*.md" -print0 2>/dev/null)

    if [ ${#OTHER_INSTRUCTIONS[@]} -eq 0 ]; then
        echo -e "${BLUE}ℹ️  다른 instruction 파일이 없습니다.${NC}"
    else
        echo -e "${CYAN}발견된 instruction 파일: ${#OTHER_INSTRUCTIONS[@]}개${NC}"
        echo ""

        for inst_file in "${OTHER_INSTRUCTIONS[@]}"; do
            echo -e "  📄 $(basename "$inst_file")"
            add_jira_rules_reference "$inst_file"
        done
    fi
else
    echo -e "${BLUE}ℹ️  instructions 디렉토리가 없습니다.${NC}"
fi

echo ""

# ============================================================
# 4단계: 완료 메시지
# ============================================================
echo "=========================================="
echo -e "${GREEN}✨ [4/4] 설정 완료! ✨${NC}"
echo "=========================================="
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${CYAN}🔍 DRY-RUN 모드였습니다. 실제 변경은 이루어지지 않았습니다.${NC}"
    echo ""
    echo "실제로 적용하려면 --dry-run 옵션 없이 다시 실행하세요:"
    echo -e "  ${YELLOW}$0 $TARGET_PROJECT_DIR${NC}"
else
    echo -e "${YELLOW}📝 다음 단계:${NC}"
    echo ""
    echo "1. 타겟 프로젝트로 이동:"
    echo -e "   ${CYAN}cd $TARGET_PROJECT_DIR${NC}"
    echo ""
    echo "2. Claude Code 실행:"
    echo -e "   ${CYAN}claude${NC}"
    echo ""
    echo "3. Jira slash command 테스트:"
    echo -e "   ${CYAN}/daily-standup${NC}"
    echo ""
    echo "4. Jira 관련 작업 시도:"
    echo -e "   ${CYAN}Jira에서 미할당 이슈 보여줘${NC}"
    echo ""

    if [ -n "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}💾 백업 위치:${NC}"
        echo -e "   $BACKUP_DIR"
        echo ""
        echo -e "${YELLOW}⚠️  문제가 발생한 경우 백업에서 복구할 수 있습니다.${NC}"
        echo ""
    fi
fi

echo "=========================================="
echo -e "${GREEN}🎉 완료! 즐거운 작업 되세요! 🎉${NC}"
echo "=========================================="
echo ""
