#!/bin/bash

CHECKSTYLE_VERSION="10.12.3"
JAR_NAME="checkstyle-${CHECKSTYLE_VERSION}-all.jar"
CONFIG_NAME="custom_checks.xml"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="checkstyle-reports"
TEXT_REPORT_FILE="${REPORT_DIR}/checkstyle_report_codebase_$TIMESTAMP.txt"
XML_REPORT_FILE="temp_checkstyle.xml"

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[INFO] Starting Checkstyle analysis...${NC}"

# Create reports directory if not exists
mkdir -p "$REPORT_DIR"

# Download Checkstyle jar if not present
if [ ! -f "$JAR_NAME" ]; then
  echo -e "${YELLOW}[INFO] Downloading Checkstyle ${CHECKSTYLE_VERSION}...${NC}"
  curl -L -o "$JAR_NAME" "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${CHECKSTYLE_VERSION}/${JAR_NAME}"
fi

# Validate config file
if [ ! -f "$CONFIG_NAME" ]; then
  echo -e "${RED}[ERROR] Configuration file '$CONFIG_NAME' not found. Please place it in the project root.${NC}"
  exit 1
fi

# Validate src directory
if [ ! -d "src" ]; then
  echo -e "${RED}[ERROR] 'src/' directory not found. Please run this script from your project root.${NC}"
  exit 1
fi

# Run Checkstyle and generate reports
echo -e "${YELLOW}[INFO] Running Checkstyle scan using config: $CONFIG_NAME...${NC}"
java -jar "$JAR_NAME" -c "$CONFIG_NAME" -f plain -o "$TEXT_REPORT_FILE" src/

# Count violations and compute score
VIOLATION_COUNT=$(grep -c '^\[ERROR\]' "$TEXT_REPORT_FILE")
SCORE=$((100 - VIOLATION_COUNT))
if [ "$SCORE" -lt 0 ]; then SCORE=0; fi

# Prepend score to the text report
sed -i "1s/^/Code Quality Score: $SCORE\nViolation Count: $VIOLATION_COUNT\n\n/" "$TEXT_REPORT_FILE"

# Report result
echo ""
if [ "$VIOLATION_COUNT" -gt 0 ]; then
  echo -e "${YELLOW}[INFO] Issues found. Report saved to:${NC} $TEXT_REPORT_FILE"
  echo -e "${YELLOW}[INFO] Code Quality Score:${NC} $SCORE (based on $VIOLATION_COUNT violations)"

  if [ "$SCORE" -lt 85 ]; then
    echo -e "${RED}[FAIL] Code quality score is below threshold (85). Consider clearing these issues in the repository.${NC}"
  else
    echo -e "${GREEN}[PASS] Code quality score meets the minimum threshold (85).${NC}"
  fi

  if grep -q "CyclomaticComplexityCheck" "$TEXT_REPORT_FILE"; then
    echo -e "${YELLOW}[WARN] High cyclomatic complexity found: consider simplifying methods.${NC}"
  fi
  if grep -q "ClassFanOutComplexityCheck" "$TEXT_REPORT_FILE"; then
    echo -e "${YELLOW}[WARN] High class fan-out: reduce dependencies where possible.${NC}"
  fi
  if grep -q "MethodLengthCheck" "$TEXT_REPORT_FILE"; then
    echo -e "${YELLOW}[WARN] Long methods found: consider splitting into smaller ones.${NC}"
  fi
else
  echo -e "${GREEN}[SUCCESS] No Checkstyle violations found! Clean codebase.${NC}"
  echo -e "${GREEN}[INFO] Code Quality Score: 100${NC}"
fi
