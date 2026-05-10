#!/usr/bin/env bash
# =====================================================================
#  MAKE MULTI CLI  🚀  v3.3
#  Epic project scaffolding tool for devs
# =====================================================================

ROOT="$(pwd)/projects"
HISTORY_LOG="$(pwd)/make-history.log"
TEMPLATES_DIR="$(pwd)/templates"
BACKUPS_DIR="$(pwd)/backups"

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
    echo -e "${DARK_CYAN}               make gen - linux(beta)${RESET}"
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
# PROJECT TEMPLATES (new_template)
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

> Created with **Make Multi CLI** v3.2 🚀

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
# EDITOR (nano)
# -------------------------
editor_project() {
    local name="$1"
    local file="${2:-}"
    if [[ -z "$name" ]]; then write_error "Usage: editor <name> [file]"; return; fi
    local target="${ROOT}/${name}"
    if [[ ! -d "$target" ]]; then write_error "Project '$name' not found"; return; fi

    if ! command -v nano &>/dev/null; then write_error "nano not found in PATH"; return; fi

    if [[ -n "$file" ]]; then
        local filepath="${target}/${file}"
        if [[ ! -f "$filepath" ]]; then
            write_warn "File '${file}' not found — creating new file"
        fi
        nano "$filepath"
        write_history "EDITOR" "${name}/${file}"
        write_success "Closed editor for '${file}' in '${name}'"
    else
        echo ""
        write_color "  📂  Files in '${name}'" "$CYAN"
        write_color "  ────────────────────────────────────────" "$DARK_GRAY"
        local files=()
        local i=1
        while IFS= read -r f; do
            local rel="${f#$target/}"
            echo -e "  ${DARK_GRAY}${i})${RESET}  📄 ${WHITE}${rel}${RESET}"
            files+=("$rel")
            ((i++))
        done < <(find "$target" -type f | sort)

        if [[ ${#files[@]} -eq 0 ]]; then
            write_warn "No files in project '${name}'"
            return
        fi

        echo ""
        printf "  ${CYAN}Select file (number or name):${RESET} "
        read -r choice

        local selected=""
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#files[@]} )); then
            selected="${files[$((choice-1))]}"
        else
            selected="$choice"
        fi

        local filepath="${target}/${selected}"
        if [[ ! -f "$filepath" ]]; then
            write_error "File '${selected}' not found"
            return
        fi

        nano "$filepath"
        write_history "EDITOR" "${name}/${selected}"
        write_success "Closed editor for '${selected}' in '${name}'"
    fi
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
                CREATED)         color="$GREEN";     icon="✅" ;;
                DELETED)         color="$RED";       icon="🗑 " ;;
                RENAMED)         color="$YELLOW";    icon="✏ " ;;
                CLONED)          color="$CYAN";      icon="📋" ;;
                EXPORTED)        color="$DARK_CYAN"; icon="📤" ;;
                GIT_INIT)        color="$BLUE";      icon="🔧" ;;
                TAG_ADDED)       color="$MAGENTA";   icon="🏷 " ;;
                TAG_REMOVED)     color="$MAGENTA";   icon="🏷 " ;;
                NOTE)            color="$WHITE";     icon="📝" ;;
                NOTE_CLEARED)    color="$DARK_GRAY"; icon="📝" ;;
                EDITOR)          color="$CYAN";      icon="✏️ " ;;
                TMPL_SAVED)      color="$GREEN";     icon="💾" ;;
                TMPL_DELETED)    color="$RED";       icon="🗑 " ;;
                BACKUP_CREATED)  color="$BLUE";      icon="📦" ;;
                BACKUP_RESTORED) color="$YELLOW";    icon="♻️ " ;;
                *)               color="$WHITE";     icon="  " ;;
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

# =====================================================================
#  TEMPLATE-TALLENNUS
#  Komennot:
#    template save <project-name> [template-name]
#    template list
#    template use  <template-name> <new-project-name>
#    template info <template-name>
#    template delete <template-name>
# =====================================================================

manage_templates() {
    local subcmd="${1:-list}"
    local arg1="${2:-}"
    local arg2="${3:-}"

    case "$subcmd" in
        save)   template_save   "$arg1" "$arg2" ;;
        list)   template_list ;;
        use)    template_use    "$arg1" "$arg2" ;;
        info)   template_info   "$arg1" ;;
        delete) template_delete "$arg1" ;;
        *)
            write_error "Tuntematon template-alakomento '${subcmd}'"
            write_info  "Käyttö: template save|list|use|info|delete"
            ;;
    esac
}

# -------------------------
# template save <project> [nimi]
# -------------------------
template_save() {
    local project="${1:-}"
    local tname="${2:-$1}"
    if [[ -z "$project" ]]; then
        write_error "Käyttö: template save <project-name> [template-name]"
        return
    fi

    local src="${ROOT}/${project}"
    if [[ ! -d "$src" ]]; then write_error "Projektia '${project}' ei löydy"; return; fi

    mkdir -p "$TEMPLATES_DIR"
    local dst="${TEMPLATES_DIR}/${tname}"

    if [[ -d "$dst" ]]; then
        write_warn "Template '${tname}' on jo olemassa. Ylikirjoita? (y/n)"
        printf "  > "
        read -r confirm
        [[ "$confirm" != "y" && "$confirm" != "yes" ]] && write_info "Peruutettu" && return
        rm -rf "$dst"
    fi

    cp -r "$src" "$dst"

    # Kirjoita template-metadata
    local lang="unknown"
    if [[ -f "${src}/meta.json" ]]; then
        lang=$(python3 -c "import json; d=json.load(open('${src}/meta.json')); print(d.get('lang','unknown'))" 2>/dev/null)
    fi
    local saved_at
    saved_at=$(date '+%Y-%m-%d %H:%M:%S')

    cat > "${dst}/.template-meta.json" <<EOF
{
  "template_name": "${tname}",
  "source_project": "${project}",
  "lang": "${lang}",
  "saved_at": "${saved_at}"
}
EOF

    write_history "TMPL_SAVED" "${tname}  (from ${project})"
    write_success "Template '${tname}' tallennettu"
    write_color "     📁  ${dst}" "$DARK_GRAY"
}

# -------------------------
# template list
# -------------------------
template_list() {
    mkdir -p "$TEMPLATES_DIR"
    echo ""
    write_color "  🗂️   TEMPLATES" "$YELLOW"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    local count=0
    while IFS= read -r -d '' dir; do
        local tname
        tname=$(basename "$dir")
        local tmeta="${dir}/.template-meta.json"
        local lang="?" saved_at="" source=""
        if [[ -f "$tmeta" ]]; then
            lang=$(python3     -c "import json; d=json.load(open('${tmeta}')); print(d.get('lang','?'))"           2>/dev/null)
            saved_at=$(python3 -c "import json; d=json.load(open('${tmeta}')); print(d.get('saved_at',''))"        2>/dev/null)
            source=$(python3   -c "import json; d=json.load(open('${tmeta}')); print(d.get('source_project',''))"  2>/dev/null)
        fi
        local icon color
        icon=$(get_lang_icon "$lang")
        color=$(get_lang_color "$lang")
        echo -ne "  ${icon}  "
        echo -e "${color}${tname}${RESET}   ${DARK_GRAY}${lang}  |  saved ${saved_at}  (from: ${source})${RESET}"
        ((count++))
    done < <(find "$TEMPLATES_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null | sort -z)

    if [[ $count -eq 0 ]]; then
        write_warn "Ei tallennettuja templateja."
        write_info "Luo template komennolla: template save <project-name>"
    fi
    echo ""
}

# -------------------------
# template use <template-name> <new-project-name>
# -------------------------
template_use() {
    local tname="${1:-}"
    local newname="${2:-}"
    if [[ -z "$tname" || -z "$newname" ]]; then
        write_error "Käyttö: template use <template-name> <new-project-name>"
        return
    fi

    local tsrc="${TEMPLATES_DIR}/${tname}"
    if [[ ! -d "$tsrc" ]]; then
        write_error "Templatea '${tname}' ei löydy — listaa: template list"
        return
    fi

    ensure_root
    local dst="${ROOT}/${newname}"
    if [[ -d "$dst" ]]; then write_error "Projekti '${newname}' on jo olemassa"; return; fi

    cp -r "$tsrc" "$dst"
    # Poista template-meta uudesta projektista
    rm -f "${dst}/.template-meta.json"

    # Luo/päivitä meta.json uudelle projektille
    local lang="unknown"
    if [[ -f "${tsrc}/.template-meta.json" ]]; then
        lang=$(python3 -c "import json; d=json.load(open('${tsrc}/.template-meta.json')); print(d.get('lang','unknown'))" 2>/dev/null)
    fi
    local created
    created=$(date '+%Y-%m-%d %H:%M:%S')

    cat > "${dst}/meta.json" <<EOF
{
  "name": "${newname}",
  "lang": "${lang}",
  "created": "${created}",
  "tags": [],
  "note": "Created from template: ${tname}"
}
EOF

    # Korvaa mahdolliset vanhat projektin nimet uusilla tiedostoissa
    # (README, package.json)
    local old_name
    old_name=$(python3 -c "
import json, os
p='${tsrc}/.template-meta.json'
if os.path.exists(p):
    print(json.load(open(p)).get('source_project',''))
" 2>/dev/null)

    if [[ -n "$old_name" && "$old_name" != "$newname" ]]; then
        for f in "${dst}/README.md" "${dst}/package.json"; do
            [[ -f "$f" ]] && sed -i "s/${old_name}/${newname}/g" "$f"
        done
    fi

    write_history "CREATED" "${lang}/${newname}  (from template: ${tname})"
    write_success "Projekti '${newname}' luotu templatesta '${tname}'"
    write_color "     📁  ${dst}" "$DARK_GRAY"
}

# -------------------------
# template info <template-name>
# -------------------------
template_info() {
    local tname="${1:-}"
    if [[ -z "$tname" ]]; then write_error "Käyttö: template info <template-name>"; return; fi

    local tdir="${TEMPLATES_DIR}/${tname}"
    if [[ ! -d "$tdir" ]]; then write_error "Templatea '${tname}' ei löydy"; return; fi

    local tmeta="${tdir}/.template-meta.json"
    local lang="?" saved_at="" source=""
    if [[ -f "$tmeta" ]]; then
        lang=$(python3     -c "import json; d=json.load(open('${tmeta}')); print(d.get('lang','?'))"          2>/dev/null)
        saved_at=$(python3 -c "import json; d=json.load(open('${tmeta}')); print(d.get('saved_at',''))"       2>/dev/null)
        source=$(python3   -c "import json; d=json.load(open('${tmeta}')); print(d.get('source_project',''))" 2>/dev/null)
    fi

    local files
    files=$(find "$tdir" -type f ! -name '.template-meta.json' | wc -l)
    local size_kb
    size_kb=$(du -sk "$tdir" 2>/dev/null | awk '{print $1}')
    local color
    color=$(get_lang_color "$lang")

    echo ""
    write_color "  📋  Template: ${tname}" "$CYAN"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"
    echo -ne "  🔧  Language: "; echo -e "${color}${lang}${RESET}"
    write_color "  🗓️   Saved:    ${saved_at}" "$WHITE"
    write_color "  📂  Source:   ${source}" "$WHITE"
    write_color "  📄  Files:    ${files}" "$WHITE"
    write_color "  💾  Size:     ${size_kb} KB" "$WHITE"
    echo ""
    write_color "  Files:" "$DARK_GRAY"
    find "$tdir" -type f ! -name '.template-meta.json' | while read -r f; do
        local rel="${f#$tdir/}"
        write_color "    • ${rel}" "$DARK_GRAY"
    done
    echo ""
    write_info "Luo projekti tästä: template use ${tname} <projektin-nimi>"
    echo ""
}

# -------------------------
# template delete <template-name>
# -------------------------
template_delete() {
    local tname="${1:-}"
    if [[ -z "$tname" ]]; then write_error "Käyttö: template delete <template-name>"; return; fi

    local tdir="${TEMPLATES_DIR}/${tname}"
    if [[ ! -d "$tdir" ]]; then write_error "Templatea '${tname}' ei löydy"; return; fi

    write_warn "Poistetaanko template '${tname}'? (y/n)"
    printf "  > "
    read -r confirm
    if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        rm -rf "$tdir"
        write_history "TMPL_DELETED" "$tname"
        write_success "Template '${tname}' poistettu"
    else
        write_info "Peruutettu"
    fi
}

# =====================================================================
#  BACKUP & RESTORE
#  Komennot:
#    backup              — varmuuskopioi kaikki projektit aikaleimalla
#    backup list         — listaa varmuuskopiot
#    restore <tiedosto>  — palauta varmuuskopiosta
# =====================================================================

manage_backup() {
    local subcmd="${1:-create}"
    local arg1="${2:-}"

    case "$subcmd" in
        list)         backup_list ;;
        ""|create)    backup_create ;;
        *)
            # Jos annetaan suoraan tiedostonimi, tulkitaan restore
            write_error "Käyttö: backup [list]  tai  restore <backup-tiedosto>"
            ;;
    esac
}

# -------------------------
# backup (luo)
# -------------------------
backup_create() {
    if ! command -v zip &>/dev/null; then write_error "zip ei löydy PATH:sta"; return; fi

    ensure_root
    mkdir -p "$BACKUPS_DIR"

    local ts
    ts=$(date '+%Y%m%d_%H%M%S')
    local zip_name="backup_${ts}.zip"
    local zip_path="${BACKUPS_DIR}/${zip_name}"

    # Laske projektien määrä
    local count
    count=$(find "$ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)

    if [[ $count -eq 0 ]]; then
        write_warn "Ei projekteja varmuuskopioitavaksi"
        return
    fi

    write_info "Varmuuskopioidaan ${count} projekti(a)..."

    (cd "$(dirname "$ROOT")" && zip -r "$zip_path" "$(basename "$ROOT")" -x "*.DS_Store" -x "*/node_modules/*" -x "*/.git/*" -x "*/target/*" -x "*/venv/*") && {
        local size_kb
        size_kb=$(du -sk "$zip_path" 2>/dev/null | awk '{print $1}')
        write_history "BACKUP_CREATED" "${zip_name}  (${count} projektia, ${size_kb} KB)"
        write_success "Varmuuskopio luotu: ${zip_name}"
        write_color "     📦  ${zip_path}  (${size_kb} KB)" "$DARK_GRAY"
    } || write_error "Varmuuskopiointi epäonnistui"
}

# -------------------------
# backup list
# -------------------------
backup_list() {
    mkdir -p "$BACKUPS_DIR"
    echo ""
    write_color "  📦  VARMUUSKOPIOT" "$YELLOW"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    local count=0
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        local fname
        fname=$(basename "$f")
        local size_kb
        size_kb=$(du -sk "$f" 2>/dev/null | awk '{print $1}')
        local mtime
        mtime=$(date -r "$f" '+%Y-%m-%d %H:%M' 2>/dev/null || stat -c '%y' "$f" 2>/dev/null | cut -d'.' -f1)
        echo -e "  📦  ${WHITE}${fname}${RESET}  ${DARK_GRAY}${mtime}  ${size_kb} KB${RESET}"
        ((count++))
    done < <(find "$BACKUPS_DIR" -maxdepth 1 -name "*.zip" 2>/dev/null | sort -r)

    if [[ $count -eq 0 ]]; then
        write_warn "Ei varmuuskopioita — luo komennolla: backup"
    else
        echo ""
        write_info "Palauta komennolla: restore <tiedostonimi>"
    fi
    echo ""
}

# -------------------------
# restore <tiedosto>
# -------------------------
restore_backup() {
    local arg="${1:-}"
    if [[ -z "$arg" ]]; then
        write_error "Käyttö: restore <backup-tiedostonimi>"
        write_info  "Listaa varmuuskopiot: backup list"
        return
    fi

    # Salli pelkkä tiedostonimi tai koko polku
    local zip_path
    if [[ -f "$arg" ]]; then
        zip_path="$arg"
    elif [[ -f "${BACKUPS_DIR}/${arg}" ]]; then
        zip_path="${BACKUPS_DIR}/${arg}"
    else
        write_error "Varmuuskopiota '${arg}' ei löydy"
        write_info  "Listaa varmuuskopiot: backup list"
        return
    fi

    if ! command -v unzip &>/dev/null; then write_error "unzip ei löydy PATH:sta"; return; fi

    echo ""
    write_warn "VAROITUS: Tämä ylikirjoittaa nykyiset projektit!"
    write_color "  Varmuuskopio: $(basename "$zip_path")" "$WHITE"
    write_warn "Jatketaanko? (y/n)"
    printf "  > "
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
        write_info "Peruutettu"
        return
    fi

    # Tee automaattinen varmuuskopio nykyisistä ennen palautusta
    local current_count
    current_count=$(find "$ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [[ $current_count -gt 0 ]]; then
        write_info "Luodaan automaattinen varmuuskopio nykyisistä projekteista ennen palautusta..."
        backup_create
    fi

    write_info "Palautetaan varmuuskopiosta..."
    local parent
    parent=$(dirname "$ROOT")

    # Pura zip väliaikaiseen hakemistoon ja kopioi projects/ päälle
    local tmp_dir
    tmp_dir=$(mktemp -d)
    unzip -q "$zip_path" -d "$tmp_dir" && {
        # Etsi projects-kansio puretusta sisällöstä
        local extracted_projects
        extracted_projects=$(find "$tmp_dir" -maxdepth 2 -type d -name "$(basename "$ROOT")" | head -1)

        if [[ -z "$extracted_projects" ]]; then
            write_error "Varmuuskopiossa ei löydy projects-kansiota"
            rm -rf "$tmp_dir"
            return
        fi

        rm -rf "$ROOT"
        cp -r "$extracted_projects" "$ROOT"
        rm -rf "$tmp_dir"

        local restored_count
        restored_count=$(find "$ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        write_history "BACKUP_RESTORED" "$(basename "$zip_path")  (${restored_count} projektia)"
        write_success "Palautettu: ${restored_count} projekti(a)"
        write_color "     ♻️   $(basename "$zip_path")" "$DARK_GRAY"
    } || {
        write_error "Purkaminen epäonnistui"
        rm -rf "$tmp_dir"
    }
}

# =====================================================================
#  STATUS  —  nopea kokonaiskuva kaikesta
# =====================================================================
show_status() {
    ensure_root
    echo ""
    write_color "  ⚡  STATUS" "$CYAN"
    write_color "  ────────────────────────────────────────" "$DARK_GRAY"

    # Laske projektit per kieli
    declare -A lang_count
    local total=0
    local git_clean=0 git_dirty=0 git_none=0

    while IFS= read -r -d '' dir; do
        local meta="${dir}/meta.json"
        local lang="unknown"
        [[ -f "$meta" ]] && lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','unknown'))" 2>/dev/null)
        lang_count["$lang"]=$(( ${lang_count["$lang"]:-0} + 1 ))
        ((total++))

        # Git-tila
        if [[ -d "${dir}/.git" ]]; then
            local dirty
            dirty=$(git -C "$dir" status --porcelain 2>/dev/null)
            if [[ -z "$dirty" ]]; then ((git_clean++)); else ((git_dirty++)); fi
        else
            ((git_none++))
        fi
    done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    # Projektit yhteensä
    write_color "  📦  Projekteja yhteensä:  ${total}" "$WHITE"
    echo ""

    # Per kieli
    write_color "  Kielet:" "$DARK_GRAY"
    for lang in "${!lang_count[@]}"; do
        local icon color
        icon=$(get_lang_icon "$lang")
        color=$(get_lang_color "$lang")
        printf "     ${icon}  "
        echo -e "${color}${lang}${RESET}  ${DARK_GRAY}×${lang_count[$lang]}${RESET}"
    done | sort
    echo ""

    # Git-tilat
    write_color "  Git:" "$DARK_GRAY"
    [[ $git_clean -gt 0 ]] && write_color "     ✅  Puhdas:       ${git_clean}" "$GREEN"
    [[ $git_dirty -gt 0 ]] && write_color "     ⚠️   Muutoksia:    ${git_dirty}" "$YELLOW"
    [[ $git_none  -gt 0 ]] && write_color "     ○   Ei git-repoa: ${git_none}"  "$DARK_GRAY"
    echo ""

    # Templatet ja varmuuskopiot
    local tmpl_count backup_count
    tmpl_count=$(find "$TEMPLATES_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    backup_count=$(find "$BACKUPS_DIR" -maxdepth 1 -name "*.zip" 2>/dev/null | wc -l)
    write_color "  🗂️   Templateja:      ${tmpl_count}" "$WHITE"
    write_color "  📦  Varmuuskopioita: ${backup_count}" "$WHITE"
    echo ""

    # Viimeisin toiminto historiasta
    if [[ -f "$HISTORY_LOG" ]]; then
        local last
        last=$(tail -1 "$HISTORY_LOG")
        write_color "  🕐  Viimeisin toiminto:" "$DARK_GRAY"
        write_color "     ${last}" "$DARK_GRAY"
    fi
    echo ""
}

# =====================================================================
#  DEPS --all  —  asenna riippuvuudet kaikille projekteille
# =====================================================================
install_deps() {
    local name="$1"

    # deps --all
    if [[ "$name" == "--all" || "$name" == "-a" ]]; then
        ensure_root
        local count=0 ok=0 skip=0
        echo ""
        write_color "  📦  Asennetaan riippuvuudet kaikille projekteille..." "$CYAN"
        write_color "  ────────────────────────────────────────" "$DARK_GRAY"

        while IFS= read -r -d '' dir; do
            local pname meta lang
            pname=$(basename "$dir")
            meta="${dir}/meta.json"
            [[ ! -f "$meta" ]] && ((skip++)) && continue
            lang=$(python3 -c "import json; d=json.load(open('${meta}')); print(d.get('lang','?'))" 2>/dev/null)

            local needs_install=false
            case "$lang" in
                node|react|ts|bun) [[ -f "${dir}/package.json" ]] && needs_install=true ;;
                python)            [[ -f "${dir}/requirements.txt" ]] && needs_install=true ;;
                go)                [[ -f "${dir}/go.mod" ]] && needs_install=true ;;
                rust)              [[ -f "${dir}/Cargo.toml" ]] && needs_install=true ;;
            esac

            if [[ "$needs_install" == true ]]; then
                local icon color
                icon=$(get_lang_icon "$lang"); color=$(get_lang_color "$lang")
                echo -ne "  ${icon}  "; echo -e "${color}${pname}${RESET}"
                pushd "$dir" > /dev/null
                case "$lang" in
                    node|react|ts|bun)
                        if command -v bun &>/dev/null; then bun install -q 2>/dev/null
                        else npm install --silent 2>/dev/null; fi ;;
                    python) pip install -q -r requirements.txt 2>/dev/null ;;
                    go)     go mod tidy 2>/dev/null ;;
                    rust)   cargo build -q 2>/dev/null ;;
                esac
                popd > /dev/null
                ((ok++))
            else
                ((skip++))
            fi
            ((count++))
        done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

        echo ""
        write_success "Valmis: ${ok} projektia asennettu, ${skip} ohitettu"
        return
    fi

    # Yksittäinen projekti (alkuperäinen toiminta)
    if [[ -z "$name" ]]; then write_error "Usage: deps <name>  tai  deps --all"; return; fi
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
# HELP
# -------------------------
show_help() {
    echo ""
    write_color "  ┌─────────────────────────────────────────┐" "$DARK_CYAN"
    write_color "  │        MAKE MULTI CLI  🚀  v1.3.3       │" "$CYAN"
    write_color "  └─────────────────────────────────────────┘" "$DARK_CYAN"
    echo ""
    write_color "  COMMANDS" "$YELLOW"
    write_color "  ─────────────────────────────────────────" "$DARK_GRAY"
    write_color "  project <lang> <name>       Create a new project" "$WHITE"
    write_color "  clone   <name> <new>        Clone a project" "$WHITE"
    write_color "  search  <keyword>           Search by name, lang or tag" "$WHITE"
    write_color "  recent                      Show recently modified projects" "$WHITE"
    write_color "  export  <name>              Export project as .zip" "$WHITE"
    write_color "  list                        List all projects" "$WHITE"
    write_color "  info    <name>              Show project details" "$WHITE"
    write_color "  open    <name>              Show project files" "$WHITE"
    write_color "  editor  <name> [file]       Open file in nano editor" "$WHITE"
    write_color "  edit    <name>              Open in VS Code" "$WHITE"
    write_color "  run     <name>              Run the project" "$WHITE"
    write_color "  rename  <old>  <new>        Rename a project" "$WHITE"
    write_color "  delete  <name>              Delete a project" "$WHITE"
    write_color "  init    <name>              Git init + first commit" "$WHITE"
    write_color "  deps    <name>              Install dependencies" "$WHITE"
    write_color "  deps    --all               Install deps for all projects" "$WHITE"
    write_color "  status                      Quick overview of all projects" "$WHITE"
    echo ""
    write_color "  notes   <name> [text]       Set/view project note" "$WHITE"
    write_color "  tag     <name> <tag>        Add tag  (e.g. work, hobby)" "$WHITE"
    write_color "  tag     <name> -<tag>       Remove tag" "$WHITE"
    write_color "  history [filter]            Show operation log" "$WHITE"
    write_color "  history clear               Clear the log" "$WHITE"
    echo ""
    write_color "  TEMPLATES" "$YELLOW"
    write_color "  ─────────────────────────────────────────" "$DARK_GRAY"
    write_color "  template save <project> [nimi]  Tallenna projekti templateksi" "$WHITE"
    write_color "  template list                   Listaa kaikki templatet" "$WHITE"
    write_color "  template use  <tmpl> <nimi>     Luo uusi projekti templatesta" "$WHITE"
    write_color "  template info <tmpl>            Näytä templaten tiedot" "$WHITE"
    write_color "  template delete <tmpl>          Poista template" "$WHITE"
    echo ""
    write_color "  BACKUP & RESTORE" "$YELLOW"
    write_color "  ─────────────────────────────────────────" "$DARK_GRAY"
    write_color "  backup                      Varmuuskopioi kaikki projektit" "$WHITE"
    write_color "  backup list                 Listaa varmuuskopiot" "$WHITE"
    write_color "  restore <tiedosto>          Palauta varmuuskopiosta" "$WHITE"
    echo ""
    write_color "  help                        Show this help" "$WHITE"
    write_color "  exit                        Quit" "$WHITE"
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
    write_color "  ║        MAKE MULTI CLI  🚀  v1.3.3        ║" "$CYAN"
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
    arg3="${parts[3]:-}"
    rest="${parts[*]:2}"

    case "$cmd" in
        project)  new_template    "$arg1" "$arg2" ;;
        clone)    clone_project   "$arg1" "$arg2" ;;
        search)   search_projects "$arg1" ;;
        recent)   show_recent 5 ;;
        export)   export_project  "$arg1" ;;
        list)     list_projects ;;
        info)     info_project    "$arg1" ;;
        open)     open_project    "$arg1" ;;
        editor)   editor_project  "$arg1" "$arg2" ;;
        edit)     edit_project    "$arg1" ;;
        run)      run_project     "$arg1" ;;
        rename)   rename_project  "$arg1" "$arg2" ;;
        delete)   delete_project  "$arg1" ;;
        init)     init_git        "$arg1" ;;
        deps)     install_deps    "$arg1" ;;
        status)   show_status ;;
        notes)    set_note        "$arg1" "$rest" ;;
        tag)      set_tag         "$arg1" "$arg2" ;;
        template) manage_templates "$arg1" "$arg2" "$arg3" ;;
        backup)   manage_backup   "$arg1" ;;
        restore)  restore_backup  "$arg1" ;;
        history)
            if [[ "$arg1" == "clear" ]]; then clear_history
            else show_history "$arg1"
            fi
            ;;
        help)     show_help ;;
        exit|quit)
            echo ""
            write_color "  👋  Bye!" "$CYAN"
            echo ""
            exit 0
            ;;
        "")       ;;
        *)        write_error "Unknown command '${cmd}' — type 'help' for usage" ;;
    esac
done
