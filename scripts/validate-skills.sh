#!/usr/bin/env bash
# validate-skills.sh — CI script for SKILL.md frontmatter + referenced paths.
# Exit 0 = all pass. Exit 1 = at least one failure.
#
# Requirements: python3 (stdlib only), curl, grep, sed.
# Usage: ./scripts/validate-skills.sh [--check-paths]

set -euo pipefail

CHECK_PATHS=false
[[ "${1:-}" == "--check-paths" ]] && CHECK_PATHS=true

SKILLS_DIR="skills"
KNOWN_KEYS="name description when_to_use allowed-tools disable-model-invocation paths"
VALID_TOOLS="Read Write Edit Grep Glob Bash WebFetch MCP LSP Fetch"
ERRORS=0

# ─── helpers ──────────────────────────────────────────────────────────────────

fail() { echo "❌ $1" >&2; ERRORS=$((ERRORS + 1)); }
warn() { echo "⚠️  $1" >&2; }
pass() { echo "✅ $1"; }

# ─── extract frontmatter ──────────────────────────────────────────────────────

extract_frontmatter() {
  local file="$1"
  awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$file"
}

# ─── main ─────────────────────────────────────────────────────────────────────

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_file="${skill_dir}SKILL.md"
  skill_name=$(basename "$skill_dir")

  if [[ ! -f "$skill_file" ]]; then
    fail "$skill_name: SKILL.md not found"
    continue
  fi

  echo ""
  echo "─── $skill_name ───"

  fm=$(extract_frontmatter "$skill_file")

  # 1. name present and matches directory
  name_val=$(echo "$fm" | grep '^name:' | sed 's/^name:[[:space:]]*//' || true)
  if [[ -z "$name_val" ]]; then
    fail "$skill_name: missing 'name' in frontmatter"
  elif [[ "$name_val" != "$skill_name" ]]; then
    fail "$skill_name: 'name' ($name_val) does not match directory ($skill_name)"
  else
    pass "name: $name_val"
  fi

  # 2. description present and non-empty
  desc_val=$(echo "$fm" | grep '^description:' | sed 's/^description:[[:space:]]*//')
  if [[ -z "$desc_val" ]]; then
    fail "$skill_name: missing or empty 'description'"
  else
    pass "description present"
  fi

  # 3. description + when_to_use under 1536 chars
  wtu_val=$(echo "$fm" | grep '^when_to_use:' | sed 's/^when_to_use:[[:space:]]*//' || true)
  combined_len=${#desc_val}
  if [[ -n "$wtu_val" ]]; then
    combined_len=$((combined_len + ${#wtu_val}))
  fi
  if [[ $combined_len -gt 1536 ]]; then
    fail "$skill_name: combined description + when_to_use = ${combined_len} chars (cap: 1536)"
  else
    pass "listing chars: ${combined_len}/1536"
  fi

  # 4. allowed-tools values are valid
  tools_val=$(echo "$fm" | grep '^allowed-tools:' | sed 's/^allowed-tools:[[:space:]]*//')
  if [[ -n "$tools_val" ]]; then
    IFS=',' read -ra tools <<< "$tools_val"
    for tool in "${tools[@]}"; do
      tool=$(echo "$tool" | xargs)  # trim whitespace
      if ! echo "$VALID_TOOLS" | grep -qw "$tool"; then
        fail "$skill_name: unknown tool '$tool' (valid: $VALID_TOOLS)"
      fi
    done
    pass "allowed-tools valid"
  else
    warn "$skill_name: no allowed-tools specified"
  fi

  # 5. only known frontmatter keys
  fm_keys=$(echo "$fm" | grep -E '^[a-zA-Z_-]+:' | sed 's/:.*//' | sort -u)
  while IFS= read -r key; do
    if ! echo "$KNOWN_KEYS" | grep -qw "$key"; then
      fail "$skill_name: unknown frontmatter key '$key' (known: $KNOWN_KEYS)"
    fi
  done <<< "$fm_keys"

  # 6. disable-model-invocation is boolean
  disable_val=$(echo "$fm" | grep '^disable-model-invocation:' | sed 's/^disable-model-invocation:[[:space:]]*//' || true)
  if [[ -n "$disable_val" ]] && [[ "$disable_val" != "true" ]] && [[ "$disable_val" != "false" ]]; then
    fail "$skill_name: disable-model-invocation must be true or false, got '$disable_val'"
  fi

  # 7. referenced src/ paths exist in the main repo (optional, --check-paths)
  if $CHECK_PATHS; then
    # extract src/... paths from SKILL.md body (skip frontmatter)
    body=$(awk 'BEGIN{n=0} /^---$/{n++; next} n>=2{print}' "$skill_file")
    refs=$(echo "$body" | grep -oE 'src/[a-zA-Z0-9_./-]+' | sort -u || true)
    if [[ -n "$refs" ]]; then
      echo "  Checking referenced paths against main repo..."
      MAIN_REPO="../react-principles"
      while IFS= read -r ref; do
        # strip trailing punctuation (backticks, parens)
        ref_clean=$(echo "$ref" | sed 's/[`),.]$//')
        # skip glob patterns
        if echo "$ref_clean" | grep -q '[*?]'; then
          continue
        fi
        # skip template placeholders
        if echo "$ref_clean" | grep -q '<'; then
          continue
        fi
        if [[ -e "$MAIN_REPO/$ref_clean" ]]; then
          pass "  path exists: $ref_clean"
        else
          warn "  path not found (may be valid in user's project): $ref_clean"
        fi
      done <<< "$refs"
    fi
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $ERRORS -gt 0 ]]; then
  echo "❌ $ERRORS error(s) found"
  exit 1
else
  echo "✅ All skills valid"
  exit 0
fi
