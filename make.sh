#!/usr/bin/env bash
# =====================================================================
#  MAKE MULTI CLI  🚀  v3.1
#  Epic project scaffolding tool for devs
# =====================================================================

ROOT="$(pwd)/projects"
HISTORY_LOG="$(pwd)/make-history.log"

# -------------------------
# COLORS
# -------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DARK_CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
DARK_GRAY='\033[0;90m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'
BG_CYAN='\033[46m'
FG_BLACK='\033[30m'

write_color()  { echo -e "${2}${1}${RESET}"; }
write_success(){ echo -e "${GREEN}  ✅  ${1}${RESET}"; }
write_error()  { echo -e "${RED}  ❌  ${1}${RESET}"; }
write_info()   { echo -e "${CYAN}  ℹ️   ${1}${RESET}"; }
write_warn()   { echo -e "${YELLOW}  ⚠️   ${1}${RESET}"; }

# -------------------------
# LANG ICONS + COLORS
# -------------------------
get_lang_icon() {
    case "$1" in
        node)   echo "🟩" ;;
        python) echo "🐍" ;;
        react)  echo "⚛️ " ;;
        go)     echo "🐹" ;;
        rust)   echo "🦀" ;;
        ts)     echo "🔷" ;;
        bun)    echo "🍞" ;;
        *)      echo "📁" ;;
    esac
}

get_lang_color() {
    case "$1" in
        node)   echo "$GREEN" ;;
        python) echo "$YELLOW" ;;
        react)  echo "$CYAN" ;;
        go)     echo "$BLUE" ;;
        rust)   echo "$RED" ;;
        ts)     echo "$DARK_CYAN" ;;
        bun)    echo "$MAGENTA" ;;
        *)      echo "$WHITE" ;;
    esac
}

# -------------------------
# SPLASH SCREEN
# -------------------------
show_splash() {
    clear
    echo ""
    echo -e "${CYAN}  ███╗   ███╗ █████╗ ██╗  ██╗███████╗${RESET}"
    echo -e "${CYAN}  ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝${RESET}"
    echo -e "${CYAN}  ██╔████╔██║███████║█████╔╝ █████╗  ${RESET}"
    echo -e "${CYAN}  ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝  ${RESET}"
    echo -e "${CYAN}  ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗${RESET}"
    echo ""
    echo -e "${DARK_CYAN}               make gen${RESET}"
    echo ""

    local messages=(
        "Initializing core engine"
        "Loading project templates"
        "Syncing workspace"
        "Compiling CLI modules"
        "Injecting dev tools"
        "Finalizing environment"
    )

    local width=30

    for ((i=0; i<=width; i++)); do
        local percent=$(( i * 100 / width ))
        local bar=""
        for ((j=0; j<i; j++)); do bar="${bar}█"; done
        for ((j=i; j<width; j++)); do bar="${bar}░"; done

        if (( i % 5 == 0 )); then
            local msg="${messages[$((RANDOM % ${#messages[@]}))]}"
            echo -e "${DARK_GRAY}  ⚙  ${msg}...${RESET}"
        fi

        printf "\r${CYAN}  Loading [${bar}] ${percent}%%   ${RESET}"
        sleep 0.05
    done

    echo ""
    echo ""
    echo -e "${GREEN}  ✔ Ready to generate projects.${RESET}"
    echo ""
    sleep 0.5
}

# -------------------------
# ROOT MANAGEMENT
# -------------------------
ensure_root() {
    mkdir -p "$ROOT"
}

# -------------------------
# HISTORY LOGGING
# -------------------------
write_history() {
    local action="$1"
    local detail="${2:-}"
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${ts}]  ${action}  ${detail}" >> "$HISTORY_LOG"
}

# -------------------------
# GITIGNORE TEMPLATES
# -------------------------
get_gitignore() {
    case "$1" in
        node)   printf "node_modules/\n.env\ndist/\n.DS_Store\n*.log" ;;
        python) printf "__pycache__/\n*.pyc\n.env\nvenv/\n.DS_Store\ndist/\n*.egg-info/" ;;
        react)  printf "node_modules/\n.env\ndist/\nbuild/\n.DS_Store\n*.log" ;;
        go)     printf "*.exe\n*.out\nvendor/\n.DS_Store" ;;
        rust)   printf "target/\nCargo.lock\n.DS_Store" ;;
        ts)     printf "node_modules/\ndist/\n.env\n.DS_Store\n*.log" ;;
        bun)    printf "node_modules/\n.env\ndist/\n.DS_Store\n*.log" ;;
        *)      printf ".DS_Store\n*.log" ;;
    esac
}

# -------------------------
# TEMPLATES
# -------------------------
new_template() {
    local lang="$1"
    local name="$2"
    if [[ -z "$lang" || -z "$name" ]]; then write_error "Usage: project <lang> <name>"; return; fi
    ensure_root
    local target="${ROOT}/${name}"

    if [[ -d "$target" ]]; then write_error "Project '$name' already exists"; return; fi
    mkdir -p "$target"

    local run_cmd=""
    case "$lang" in
        node)   run_cmd='```bash\nnode index.js\n```' ;;
        python) run_cmd='```bash\npython main.py\n```' ;;
        react)  run_cmd='```bash\nnpm install\nnpm run dev\n```' ;;
        go)     run_cmd='```bash\ngo run main.go\n```' ;;
        rust)   run_cmd='```bash\ncargo run\n```' ;;
        ts)     run_cmd='```bash\nnpm install\nnpx ts-node index.ts\n```' ;;
        bun)    run_cmd='```bash\nbun run index.ts\n```' ;;
    esac

    cat > "${target}/README.md" <<EOF
# ${name}

> Created with **Make Multi CLI** v3.1 🚀

## Language
\`${lang}\`

## Getting Started

$(printf "$run_cmd")
EOF

    get_gitignore "$lang" > "${target}/.gitignore"

    case "$lang" in
        node)
            echo "console.log('Node project ${name}');" > "${target}/index.js"
            cat > "${target}/package.json" <<EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "type": "module",
  "scripts": { "start": "node index.js" }
}
EOF
            ;;
        python)
            echo "print('Python project ${name}')" > "${target}/main.py"
            printf "# Add your dependencies here\n# e.g. requests==2.31.0\n" > "${target}/requirements.txt"
            ;;
        react)
            cat > "${target}/App.jsx" <<EOF
import React from 'react';
export default function App() {
  return <div><h1>${name}</h1></div>;
}
EOF
            cat > "${target}/package.json" <<EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": { "react": "^18.0.0", "react-dom": "^18.0.0" },
  "devDependencies": { "vite": "^5.0.0", "@vitejs/plugin-react": "^4.0.0" }
}
EOF
            ;;
        go)
            cat > "${target}/main.go" <<EOF
package main
import "fmt"
func main() { fmt.Println("Go project ${name}") }
EOF
            ;;
        rust)
            echo 'fn main() { println!("Rust project '"${name}"'"); }' > "${target}/main.rs"
            ;;
        ts)
            cat > "${target}/index.ts" <<EOF
const greet = (name: string): void => { console.log(\`TypeScript project \${name}\`); };
greet("${name}");
EOF
            cat > "${target}/package.json" <<EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "scripts": { "start": "ts-node index.ts", "build": "tsc" },
  "devDependencies": { "typescript": "^5.0.0", "ts-node": "^10.0.0", "@types/node": "^20.0.0" }
}
EOF
            cat > "${target}/tsconfig.json" <<EOF
{
  "compilerOptions": { "target": "ES2020", "module": "commonjs", "strict": true, "outDir": "dist" }
}
EOF
            ;;
        bun)
            echo 'console.log("Bun project '"${name}"'");' > "${target}/index.ts"
            cat > "${target}/package.json" <<EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "scripts": { "start": "bun run index.ts" }
}
EOF
            ;;
        *)
            write_error "Unknown language: $lang"
            rm -rf "$target"
            return
            ;;
    esac

    local created
    created=$(date '+%Y-%m-%d %H:%M:%S')
    cat > "${target}/meta.json" <<EOF
{
  "name": "${name}",
  "lang": "${lang}",
  "created": "${created}",
  "tags": [],
  "note": ""
}
EOF

    write_history "CREATED" "${lang}/${name}"
    write_success "Created ${lang} project: ${name}"
    write_color "     📁  ${target}" "$DARK_GRAY"
}

# -------------------------
# CLONE
# -------------------------
clone_project() {
    local src="$1" dst="$2"
    if [[ -z "$src" || -z "$dst" ]]; then write_error "Usage: clone <name> <newname>"; return; fi
    local src_path="${ROOT}/${src}"
    local dst_path="${ROOT}/${dst}"

    if [[ ! -d "$src_path" ]]; then write_error "Project '$src' not found"; return; fi
    if [[ -d "$dst_path" ]]; then write_error "Project '$dst' already exists"; return; fi

    cp -r "$src_path" "$dst_path"

    local meta="${dst_path}/meta.json"
    if [[ -f "$meta" ]]; then
        local created
        created=$(date '+%Y-%m-%d %H:%M:%S')
        local tmp
        tmp=$(mktemp)
        python3 -c "
import json, sys
with open('${meta}') as f: d = json.load(f)
d['name'] = '${dst}'
d['created'] = '${created}'
print(json.dumps(d, indent=2))
" > "$tmp" && mv "$tmp" "$meta"
    fi

    write_history "CLONED" "${src} → ${dst}"
    write_success "Cloned '${src}' → '${dst}'"
    write_color "     📁  ${dst_path}" "$DARK_GRAY"
}

# -------------------------
# SEARCH
# -------------------------
search_projects() {
    local keyword="$1"
    if [[ -z "$keyword" ]]; then write_error "Usage: search <keyword>"; return; fi
    ensure_root

    local found=0
    echo ""
    write_color "  🔍  Results for '${keyword}'" "$CYAN"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    while IFS= read -r -d '' dir; do
        local pname
        pname=$(basename "$dir")
        local meta="${dir}/meta.json"
        local lang="?" tags=""
        if [[ -f "$meta" ]]; then
            lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)
            tags=$(python3 -c "import json; d=json.load(open('${meta}')); print(' '.join(d.get('tags',[])))" 2>/dev/null)
        fi
        if [[ "$pname" == *"$keyword"* || "$lang" == *"$keyword"* || "$tags" == *"$keyword"* ]]; then
            local icon color
            icon=$(get_lang_icon "$lang")
            color=$(get_lang_color "$lang")
            echo -ne "     ${icon}  "
            echo -e "${color}${pname}${RESET}  ${DARK_GRAY}${tags}${RESET}"
            ((found++))
        fi
    done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    if [[ $found -eq 0 ]]; then
        write_warn "No projects matching '${keyword}'"
    fi
    echo ""
}

# -------------------------
# RECENT
# -------------------------
show_recent() {
    local count="${1:-3}"
    ensure_root
    echo ""
    write_color "  🕐  Recently modified" "$DARK_GRAY"

    while IFS= read -r dir; do
        [[ -z "$dir" ]] && continue
        local pname
        pname=$(basename "$dir")
        local meta="${dir}/meta.json"
        local lang="?"
        if [[ -f "$meta" ]]; then
            lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)
        fi
        local icon color
        icon=$(get_lang_icon "$lang")
        color=$(get_lang_color "$lang")
        local ago
        ago=$(date -r "$dir" '+%m-%d %H:%M' 2>/dev/null || stat -c '%y' "$dir" 2>/dev/null | cut -d' ' -f1,2 | cut -c1-11)
        echo -ne "     ${icon}  "
        echo -e "${color}${pname}${RESET}  ${DARK_GRAY}${ago}${RESET}"
    done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' 2>/dev/null \
        | sort -rn | head -n "$count" | awk '{print $2}')
    echo ""
}

# -------------------------
# EXPORT (ZIP)
# -------------------------
export_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: export <name>"; return; fi
    local target="${ROOT}/${name}"
    local zip_path="$(pwd)/${name}.zip"

    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi
    [[ -f "$zip_path" ]] && rm -f "$zip_path"

    if command -v zip &>/dev/null; then
        (cd "$ROOT" && zip -r "$zip_path" "$name" -x "*.DS_Store") && \
            write_history "EXPORTED" "${name} → ${zip_path}" && \
            write_success "Exported '${name}' → ${zip_path}" || \
            write_error "Export failed"
    else
        write_error "zip not found in PATH"
    fi
}

# -------------------------
# LIST
# -------------------------
list_projects() {
    ensure_root
    echo ""
    write_color "  📦  PROJECTS" "$YELLOW"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    local count=0
    while IFS= read -r -d '' dir; do
        local pname
        pname=$(basename "$dir")
        local meta="${dir}/meta.json"
        local lang="?" created="" tags=""
        if [[ -f "$meta" ]]; then
            lang=$(python3    -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))"    2>/dev/null)
            created=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('created',''))"  2>/dev/null)
            tags=$(python3    -c "import json; d=json.load(open('${meta}')); print(' '.join(['#'+t for t in d.get('tags',[])]))" 2>/dev/null)
        fi
        local icon color
        icon=$(get_lang_icon "$lang")
        color=$(get_lang_color "$lang")
        echo -ne "  ${icon}  "
        echo -e "${color}${pname}${RESET}   ${DARK_GRAY}${lang}  |  ${created}  ${tags}${RESET}"
        ((count++))
    done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null | sort -z)

    [[ $count -eq 0 ]] && write_warn "No projects yet."
    echo ""
}

# -------------------------
# INFO
# -------------------------
info_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: info <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    local files
    files=$(find "$target" -type f | wc -l)
    local size_kb
    size_kb=$(du -sk "$target" 2>/dev/null | awk '{print $1}')
    local created
    created=$(stat -c '%y' "$target" 2>/dev/null | cut -d'.' -f1 || \
              stat -f '%SB' "$target" 2>/dev/null)

    echo ""
    write_color "  📋  ${name}" "$CYAN"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"
    write_color "  📁  Path:     ${target}" "$WHITE"
    write_color "  🗓️   Created:  ${created}" "$WHITE"
    write_color "  📄  Files:    ${files}" "$WHITE"
    write_color "  💾  Size:     ${size_kb} KB" "$WHITE"

    local meta="${target}/meta.json"
    if [[ -f "$meta" ]]; then
        local lang tags note
        lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)
        tags=$(python3 -c "import json; d=json.load(open('${meta}')); print(' '.join(['#'+t for t in d.get('tags',[])]))" 2>/dev/null)
        note=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('note',''))" 2>/dev/null)
        local color
        color=$(get_lang_color "$lang")
        echo -ne "  🔧  Language: "
        echo -e "${color}${lang}${RESET}"
        [[ -n "$tags" ]] && write_color "  🏷️   Tags:     ${tags}" "$DARK_CYAN"
        [[ -n "$note" ]] && write_color "  📝  Note:     ${note}" "$WHITE"
    fi

    echo ""
    write_color "  Files:" "$DARK_GRAY"
    find "$target" -type f | while read -r f; do
        local rel="${f#$target/}"
        write_color "    • ${rel}" "$DARK_GRAY"
    done
    echo ""
}

# -------------------------
# OPEN
# -------------------------
open_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: open <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    echo ""
    write_color "  📂  ${name}" "$CYAN"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"
    find "$target" | sort | while read -r item; do
        local rel="${item#$target/}"
        [[ "$rel" == "$target" || -z "$rel" ]] && continue
        if [[ -d "$item" ]]; then
            write_color "  📁 ${rel}/" "$YELLOW"
        else
            write_color "  📄 ${rel}" "$WHITE"
        fi
    done
    echo ""
}

# -------------------------
# RUN
# -------------------------
run_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: run <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    local meta="${target}/meta.json"
    if [[ ! -f "$meta" ]]; then write_error "No meta.json found — can't detect language"; return; fi

    local lang
    lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)
    write_info "Running ${lang} project '${name}'..."
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    pushd "$target" > /dev/null
    case "$lang" in
        node)   node index.js ;;
        python) python3 main.py ;;
        react)  write_info "React: run 'npm run dev' manually in ${target}" ;;
        go)     go run main.go ;;
        rust)
            rustc main.rs -o main_out && ./main_out
            rm -f main_out
            ;;
        ts)     npx ts-node index.ts ;;
        bun)    bun run index.ts ;;
        *)      write_error "Don't know how to run lang: ${lang}" ;;
    esac
    popd > /dev/null
}

# -------------------------
# EDIT (VS Code)
# -------------------------
edit_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: edit <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    if command -v code &>/dev/null; then
        code "$target"
        write_success "Opened '${name}' in VS Code"
    else
        write_error "VS Code (code) not found in PATH"
    fi
}

# -------------------------
# RENAME
# -------------------------
rename_project() {
    local old_name="$1" new_name="$2"
    if [[ -z "$old_name" || -z "$new_name" ]]; then write_error "Usage: rename <old> <new>"; return; fi
    local old_path="${ROOT}/${old_name}"
    local new_path="${ROOT}/${new_name}"

    if [[ ! -d "$old_path" ]]; then write_error "Project '$old_name' not found"; return; fi
    if [[ -d "$new_path" ]]; then   write_error "Project '$new_name' already exists"; return; fi

    mv "$old_path" "$new_path"
    local meta="${new_path}/meta.json"
    if [[ -f "$meta" ]]; then
        local tmp
        tmp=$(mktemp)
        python3 -c "
import json
with open('${meta}') as f: d = json.load(f)
d['name'] = '${new_name}'
print(json.dumps(d, indent=2))
" > "$tmp" && mv "$tmp" "$meta"
    fi
    write_history "RENAMED" "${old_name} → ${new_name}"
    write_success "Renamed '${old_name}' → '${new_name}'"
}

# -------------------------
# DELETE
# -------------------------
delete_project() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: delete <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    write_warn "Are you sure you want to delete '${name}'? (y/n)"
    printf "  > "
    read -r confirm
    if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        rm -rf "$target"
        write_history "DELETED" "$name"
        write_success "Deleted project: ${name}"
    else
        write_info "Cancelled"
    fi
}

# -------------------------
# GIT INIT
# -------------------------
init_git() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: init <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi
    if ! command -v git &>/dev/null; then write_error "git not found in PATH"; return; fi

    pushd "$target" > /dev/null
    git init -q
    git add .
    git commit -q -m "init: scaffold ${name}"
    popd > /dev/null
    write_history "GIT_INIT" "$name"
    write_success "Git repo initialized in '${name}' with initial commit"
}

# -------------------------
# INSTALL DEPS
# -------------------------
install_deps() {
    local name="$1"
    if [[ -z "$name" ]]; then write_error "Usage: deps <name>"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    local meta="${target}/meta.json"
    if [[ ! -f "$meta" ]]; then write_error "No meta.json — can't detect language"; return; fi

    local lang
    lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)

    pushd "$target" > /dev/null
    case "$lang" in
        node|react|ts|bun)
            if command -v bun &>/dev/null; then
                write_info "Installing with bun..."; bun install
            else
                write_info "Installing with npm..."; npm install
            fi
            ;;
        python)
            if [[ -f "requirements.txt" ]]; then
                write_info "Installing Python deps..."; pip install -r requirements.txt
            else
                write_warn "No requirements.txt found"
            fi
            ;;
        go)   write_info "Tidying Go modules..."; go mod tidy ;;
        rust) write_info "Building with cargo..."; cargo build ;;
        *)    write_warn "No dep install defined for lang: ${lang}" ;;
    esac
    write_success "Dependencies installed for '${name}'"
    popd > /dev/null
}

# -------------------------
# NOTES
# -------------------------
set_note() {
    local name="$1" note="${2:-}"
    if [[ -z "$name" ]]; then write_error "Usage: notes <name> [teksti]"; return; fi
    local meta="${ROOT}/${name}/meta.json"
    if [[ ! -f "$meta" ]]; then write_error "Project '$name' not found"; return; fi

    local current
    current=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('note',''))" 2>/dev/null)

    if [[ -z "$note" ]]; then
        echo ""
        write_color "  📝  Note for '${name}'" "$CYAN"
        [[ -n "$current" ]] && write_color "  Current: ${current}" "$DARK_GRAY"
        write_color "  (Enter to keep current, '-' to clear)" "$DARK_GRAY"
        printf "  ❯ "
        read -r note
        [[ -z "$note" ]] && write_info "Unchanged" && return
        [[ "$note" == "-" ]] && note=""
    fi

    local tmp
    tmp=$(mktemp)
    python3 -c "
import json
with open('${meta}') as f: d = json.load(f)
d['note'] = '''${note}'''
print(json.dumps(d, indent=2))
" > "$tmp" && mv "$tmp" "$meta"

    if [[ -n "$note" ]]; then
        write_history "NOTE" "${name}  ← ${note}"
        write_success "Note saved for '${name}'"
        write_color "     📝  ${note}" "$DARK_GRAY"
    else
        write_history "NOTE_CLEARED" "$name"
        write_success "Note cleared for '${name}'"
    fi
}

# -------------------------
# TAGS
# -------------------------
set_tag() {
    local name="$1" tag="${2:-}"
    if [[ -z "$name" ]]; then write_error "Usage: tag <name> <tag>  tai  tag <name> -<tag> (poista)"; return; fi
    local meta="${ROOT}/${name}/meta.json"
    if [[ ! -f "$meta" ]]; then write_error "Project '$name' not found"; return; fi

    if [[ -z "$tag" ]]; then
        echo ""
        write_color "  🏷️   Tags for '${name}'" "$CYAN"
        local tags
        tags=$(python3 -c "import json; d=json.load(open('${meta}')); print(' '.join(['#'+t for t in d.get('tags',[])]))" 2>/dev/null)
        [[ -z "$tags" ]] && write_warn "  No tags yet." || write_color "  ${tags}" "$DARK_CYAN"
        echo ""
        return
    fi

    # Remove tag
    if [[ "$tag" == -* ]]; then
        local remove="${tag#-}"
        local tmp
        tmp=$(mktemp)
        python3 -c "
import json
with open('${meta}') as f: d = json.load(f)
tags = d.get('tags', [])
if '${remove}' in tags:
    tags.remove('${remove}')
    d['tags'] = tags
    print(json.dumps(d, indent=2))
else:
    import sys; sys.exit(1)
" > "$tmp" && mv "$tmp" "$meta" && \
            write_history "TAG_REMOVED" "${name}  #${remove}" && \
            write_success "Removed tag '#${remove}' from '${name}'" || \
            write_warn "Tag '#${remove}' not found on '${name}'"
        return
    fi

    # Add tag
    tag="${tag#\#}"
    local tmp
    tmp=$(mktemp)
    python3 -c "
import json
with open('${meta}') as f: d = json.load(f)
tags = d.get('tags', [])
if '${tag}' in tags:
    import sys; sys.exit(1)
tags.append('${tag}')
d['tags'] = tags
print(json.dumps(d, indent=2))
" > "$tmp" && mv "$tmp" "$meta" && \
        write_history "TAG_ADDED" "${name}  #${tag}" && \
        write_success "Added tag '#${tag}' to '${name}'" || \
        write_warn "Tag '#${tag}' already set on '${name}'"
}

# -------------------------
# HISTORY
# -------------------------
show_history() {
    local filter="${1:-}"
    if [[ ! -f "$HISTORY_LOG" ]]; then write_warn "No history yet."; return; fi

    echo ""
    write_color "  📜  History${filter:+ — '$filter'}" "$CYAN"
    write_color "  ──────────────────────────────────────────────────" "$DARK_GRAY"

    local lines
    if [[ -n "$filter" ]]; then
        lines=$(grep -i "$filter" "$HISTORY_LOG" | tail -30 | tac 2>/dev/null || \
                grep -i "$filter" "$HISTORY_LOG" | tail -30 | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}')
    else
        lines=$(tail -30 "$HISTORY_LOG" | tac 2>/dev/null || \
                tail -30 "$HISTORY_LOG" | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}')
    fi

    if [[ -z "$lines" ]]; then
        write_warn "No history${filter:+ matching '$filter'}"
        return
    fi

    while IFS= read -r line; do
        if [[ "$line" =~ ^\[(.+)\][[:space:]]+([A-Z_]+)[[:space:]]*(.*) ]]; then
            local ts="${BASH_REMATCH[1]}"
            local action="${BASH_REMATCH[2]}"
            local detail="${BASH_REMATCH[3]}"
            local color icon
            case "$action" in
                CREATED)      color="$GREEN";   icon="✅" ;;
                DELETED)      color="$RED";     icon="🗑 " ;;
                RENAMED)      color="$YELLOW";  icon="✏ " ;;
                CLONED)       color="$CYAN";    icon="📋" ;;
                EXPORTED)     color="$DARK_CYAN"; icon="📤" ;;
                GIT_INIT)     color="$BLUE";    icon="🔧" ;;
                TAG_ADDED)    color="$MAGENTA"; icon="🏷 " ;;
                TAG_REMOVED)  color="$MAGENTA"; icon="🏷 " ;;
                NOTE)         color="$WHITE";   icon="📝" ;;
                NOTE_CLEARED) color="$DARK_GRAY"; icon="📝" ;;
                *)            color="$WHITE";   icon="  " ;;
            esac
            echo -ne "  ${icon}  "
            echo -ne "${DARK_GRAY}${ts}  ${RESET}"
            echo -ne "${color}${action}${RESET}"
            [[ -n "$detail" ]] && echo -e "  ${DARK_GRAY}${detail}${RESET}" || echo ""
        else
            write_color "  ${line}" "$DARK_GRAY"
        fi
    done <<< "$lines"

    echo ""
    write_color "  📁  ${HISTORY_LOG}" "$DARK_GRAY"
    echo ""
}

clear_history() {
    if [[ ! -f "$HISTORY_LOG" ]]; then write_warn "No history file found."; return; fi
    write_warn "Clear entire history? (y/n)"
    printf "  > "
    read -r confirm
    if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        rm -f "$HISTORY_LOG"
        write_success "History cleared"
    else
        write_info "Cancelled"
    fi
}

# -------------------------
# HELP
# -------------------------
show_help() {
    echo ""
    write_color "  ┌─────────────────────────────────────────┐" "$DARK_CYAN"
    write_color "  │        MAKE MULTI CLI  🚀  v3.1          │" "$CYAN"
    write_color "  └─────────────────────────────────────────┘" "$DARK_CYAN"
    echo ""
    write_color "  COMMANDS" "$YELLOW"
    write_color "  ─────────────────────────────────────────" "$DARK_GRAY"
    write_color "  project <lang> <name>   Create a new project" "$WHITE"
    write_color "  clone   <name> <new>    Clone a project" "$WHITE"
    write_color "  search  <keyword>       Search by name, lang or tag" "$WHITE"
    write_color "  recent                  Show recently modified projects" "$WHITE"
    write_color "  export  <name>          Export project as .zip" "$WHITE"
    write_color "  list                    List all projects" "$WHITE"
    write_color "  info    <name>          Show project details" "$WHITE"
    write_color "  open    <name>          Show project files" "$WHITE"
    write_color "  edit    <name>          Open in VS Code" "$WHITE"
    write_color "  run     <name>          Run the project" "$WHITE"
    write_color "  rename  <old>  <new>    Rename a project" "$WHITE"
    write_color "  delete  <name>          Delete a project" "$WHITE"
    write_color "  init    <name>          Git init + first commit" "$WHITE"
    write_color "  deps    <name>          Install dependencies" "$WHITE"
    echo ""
    write_color "  notes   <name> [text]   Set/view project note" "$WHITE"
    write_color "  tag     <name> <tag>    Add tag  (e.g. work, hobby)" "$WHITE"
    write_color "  tag     <name> -<tag>   Remove tag" "$WHITE"
    write_color "  history [filter]        Show operation log" "$WHITE"
    write_color "  history clear           Clear the log" "$WHITE"
    echo ""
    write_color "  help                    Show this help" "$WHITE"
    write_color "  exit                    Quit" "$WHITE"
    echo ""
    write_color "  LANGUAGES" "$YELLOW"
    write_color "  ─────────────────────────────────────────" "$DARK_GRAY"
    echo -e "  ${GREEN}🟩 node  ${RESET}${CYAN}⚛️  react  ${RESET}${DARK_CYAN}🔷 ts  ${RESET}${MAGENTA}🍞 bun${RESET}"
    echo -e "  ${YELLOW}🐍 python  ${RESET}${BLUE}🐹 go  ${RESET}${RED}🦀 rust${RESET}"
    echo ""
}

# -------------------------
# BANNER
# -------------------------
show_banner() {
    clear
    echo ""
    write_color "  ╔══════════════════════════════════════════╗" "$CYAN"
    write_color "  ║                                          ║" "$CYAN"
    write_color "  ║        MAKE MULTI CLI  🚀  v3.1          ║" "$CYAN"
    write_color "  ║   scaffold · run · manage · ship fast    ║" "$DARK_CYAN"
    write_color "  ║                                          ║" "$CYAN"
    write_color "  ╚══════════════════════════════════════════╝" "$CYAN"
    echo ""
    show_recent
    write_color "  Type 'help' to see all commands." "$DARK_GRAY"
    echo ""
}

# =====================================================================
#  MAIN
# =====================================================================

show_splash
show_banner

while true; do
    echo ""
    printf "  \033[0;36mmake\033[0m \033[0;90m❯\033[0m "
    read -r user_input

    # Parse input
    read -ra parts <<< "$user_input"
    cmd="${parts[0],,}"
    arg1="${parts[1]:-}"
    arg2="${parts[2]:-}"
    rest="${parts[*]:2}"

    case "$cmd" in
        project) new_template   "$arg1" "$arg2" ;;
        clone)   clone_project  "$arg1" "$arg2" ;;
        search)  search_projects "$arg1" ;;
        recent)  show_recent 5 ;;
        export)  export_project "$arg1" ;;
        list)    list_projects ;;
        info)    info_project   "$arg1" ;;
        open)    open_project   "$arg1" ;;
        edit)    edit_project   "$arg1" ;;
        run)     run_project    "$arg1" ;;
        rename)  rename_project "$arg1" "$arg2" ;;
        delete)  delete_project "$arg1" ;;
        init)    init_git       "$arg1" ;;
        deps)    install_deps   "$arg1" ;;
        notes)   set_note       "$arg1" "$rest" ;;
        tag)     set_tag        "$arg1" "$arg2" ;;
        history)
            if [[ "$arg1" == "clear" ]]; then clear_history
            else show_history "$arg1"
            fi
            ;;
        help)    show_help ;;
        exit|quit)
            echo ""
            write_color "  👋  Bye!" "$CYAN"
            echo ""
            exit 0
            ;;
        "")      ;;
        *)       write_error "Unknown command '${cmd}' — type 'help' for usage" ;;
    esac
done
