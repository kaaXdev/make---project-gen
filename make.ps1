# =====================================================================
#  MAKE MULTI CLI  🚀  v3.1
#  Epic project scaffolding tool for devs
# =====================================================================

$ROOT        = Join-Path $PWD "projects"
$HISTORY_LOG = Join-Path $PWD "make-history.log"

# -------------------------
# COLORS
# -------------------------
function Write-Color($text, $color = "White") {
    Write-Host $text -ForegroundColor $color
}
function Write-Success($text) { Write-Color "  ✅  $text" "Green" }
function Write-Error($text)   { Write-Color "  ❌  $text" "Red" }
function Write-Info($text)    { Write-Color "  ℹ️   $text" "Cyan" }
function Write-Warn($text)    { Write-Color "  ⚠️   $text" "Yellow" }

# -------------------------
# LANG COLORS + ICONS
# -------------------------
function Get-LangIcon($lang) {
    switch ($lang) {
        "node"   { return "🟩" }
        "python" { return "🐍" }
        "react"  { return "⚛️ " }
        "go"     { return "🐹" }
        "rust"   { return "🦀" }
        "ts"     { return "🔷" }
        "bun"    { return "🍞" }
        default  { return "📁" }
    }
}

function Get-LangColor($lang) {
    switch ($lang) {
        "node"   { return "Green" }
        "python" { return "Yellow" }
        "react"  { return "Cyan" }
        "go"     { return "Blue" }
        "rust"   { return "Red" }
        "ts"     { return "DarkCyan" }
        "bun"    { return "Magenta" }
        default  { return "White" }
    }
}

# -------------------------
# ROOT MANAGEMENT
# -------------------------
function Ensure-Root {
    if (!(Test-Path $ROOT)) {
        New-Item -ItemType Directory -Path $ROOT | Out-Null
    }
}

# -------------------------
# HISTORY LOGGING
# -------------------------
function Write-History($action, $detail = "") {
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts]  $action  $detail".TrimEnd()
    Add-Content -Path $HISTORY_LOG -Value $line
}

# -------------------------
# GITIGNORE TEMPLATES
# -------------------------
function Get-GitIgnore($lang) {
    switch ($lang) {
        "node"   { return "node_modules/`n.env`ndist/`n.DS_Store`n*.log" }
        "python" { return "__pycache__/`n*.pyc`n.env`nvenv/`n.DS_Store`ndist/`n*.egg-info/" }
        "react"  { return "node_modules/`n.env`ndist/`nbuild/`n.DS_Store`n*.log" }
        "go"     { return "*.exe`n*.out`nvendor/`n.DS_Store" }
        "rust"   { return "target/`nCargo.lock`n.DS_Store" }
        "ts"     { return "node_modules/`ndist/`n.env`n.DS_Store`n*.log" }
        "bun"    { return "node_modules/`n.env`ndist/`n.DS_Store`n*.log" }
        default  { return ".DS_Store`n*.log" }
    }
}

# -------------------------
# TEMPLATES
# -------------------------
function New-Template($lang, $name) {
    if (!$lang -or !$name) { Write-Error "Usage: project <lang> <name>"; return }
    Ensure-Root
    $target = Join-Path $ROOT $name

    if (Test-Path $target) { Write-Error "Project '$name' already exists"; return }
    New-Item -ItemType Directory -Path $target | Out-Null

    @"
# $name

> Created with **Make Multi CLI** v3.1 🚀

## Language
``$lang``

## Getting Started

$(switch ($lang) {
    "node"   { "``````bash`nnode index.js`n``````" }
    "python" { "``````bash`npython main.py`n``````" }
    "react"  { "``````bash`nnpm install`nnpm run dev`n``````" }
    "go"     { "``````bash`ngo run main.go`n``````" }
    "rust"   { "``````bash`ncargo run`n``````" }
    "ts"     { "``````bash`nnpm install`nnpx ts-node index.ts`n``````" }
    "bun"    { "``````bash`nbun run index.ts`n``````" }
})
"@ | Set-Content "$target/README.md"

    Get-GitIgnore $lang | Set-Content "$target/.gitignore"

    switch ($lang) {
        "node" {
            "console.log('Node project $name');" | Set-Content "$target/index.js"
            @"
{
  "name": "$name",
  "version": "1.0.0",
  "type": "module",
  "scripts": { "start": "node index.js" }
}
"@ | Set-Content "$target/package.json"
        }
        "python" {
            "print('Python project $name')" | Set-Content "$target/main.py"
            "# Add your dependencies here`n# e.g. requests==2.31.0" | Set-Content "$target/requirements.txt"
        }
        "react" {
            @"
import React from 'react';
export default function App() {
  return <div><h1>$name</h1></div>;
}
"@ | Set-Content "$target/App.jsx"
            @"
{
  "name": "$name",
  "version": "1.0.0",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": { "react": "^18.0.0", "react-dom": "^18.0.0" },
  "devDependencies": { "vite": "^5.0.0", "@vitejs/plugin-react": "^4.0.0" }
}
"@ | Set-Content "$target/package.json"
        }
        "go" {
            @"
package main
import "fmt"
func main() { fmt.Println("Go project $name") }
"@ | Set-Content "$target/main.go"
        }
        "rust" {
            @"
fn main() { println!("Rust project $name"); }
"@ | Set-Content "$target/main.rs"
        }
        "ts" {
            @"
const greet = (name: string): void => { console.log(`TypeScript project ${name}`); };
greet("$name");
"@ | Set-Content "$target/index.ts"
            @"
{
  "name": "$name",
  "version": "1.0.0",
  "scripts": { "start": "ts-node index.ts", "build": "tsc" },
  "devDependencies": { "typescript": "^5.0.0", "ts-node": "^10.0.0", "@types/node": "^20.0.0" }
}
"@ | Set-Content "$target/package.json"
            @"
{
  "compilerOptions": { "target": "ES2020", "module": "commonjs", "strict": true, "outDir": "dist" }
}
"@ | Set-Content "$target/tsconfig.json"
        }
        "bun" {
            'console.log("Bun project $name");' | Set-Content "$target/index.ts"
            @"
{
  "name": "$name",
  "version": "1.0.0",
  "scripts": { "start": "bun run index.ts" }
}
"@ | Set-Content "$target/package.json"
        }
        default {
            Write-Error "Unknown language: $lang"
            Remove-Item $target -Recurse -Force
            return
        }
    }

    @"
{
  "name": "$name",
  "lang": "$lang",
  "created": "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
  "tags": [],
  "note": ""
}
"@ | Set-Content "$target/meta.json"

    Write-History "CREATED" "$lang/$name"
    Write-Success "Created $lang project: $name"
    Write-Color "     📁  $target" "DarkGray"
}

# -------------------------
# CLONE
# -------------------------
function Clone-Project($src, $dst) {
    if (!$src -or !$dst) { Write-Error "Usage: clone <name> <newname>"; return }
    $srcPath = Join-Path $ROOT $src
    $dstPath = Join-Path $ROOT $dst

    if (!(Test-Path $srcPath)) { Write-Error "Project '$src' not found"; return }
    if (Test-Path $dstPath)    { Write-Error "Project '$dst' already exists"; return }

    Copy-Item $srcPath $dstPath -Recurse

    $meta = Join-Path $dstPath "meta.json"
    if (Test-Path $meta) {
        $data         = Get-Content $meta | ConvertFrom-Json
        $data.name    = $dst
        $data.created = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        $data | ConvertTo-Json | Set-Content $meta
    }

    Write-History "CLONED" "$src → $dst"
    Write-Success "Cloned '$src' → '$dst'"
    Write-Color "     📁  $dstPath" "DarkGray"
}

# -------------------------
# SEARCH  (name, lang, tags)
# -------------------------
function Search-Projects($keyword) {
    if (!$keyword) { Write-Error "Usage: search <keyword>"; return }
    Ensure-Root
    $projects = @(Get-ChildItem $ROOT -Directory)
    $results  = @()

    foreach ($p in $projects) {
        $meta = Join-Path $p.FullName "meta.json"
        $lang = "?"; $tags = @()
        if (Test-Path $meta) {
            $data = Get-Content $meta | ConvertFrom-Json
            $lang = $data.lang
            if ($data.PSObject.Properties["tags"]) { $tags = @($data.tags) }
        }
        $tagMatch = $tags | Where-Object { $_ -like "*$keyword*" }
        if ($p.Name -like "*$keyword*" -or $lang -like "*$keyword*" -or $tagMatch) {
            $results += @{ name = $p.Name; lang = $lang; tags = $tags }
        }
    }

    if ($results.Count -eq 0) {
        Write-Warn "No projects matching '$keyword'"
        return
    }

    Write-Host ""
    Write-Color "  🔍  Results for '$keyword'  ($($results.Count))" "Cyan"
    Write-Color "  $('─' * 40)" "DarkGray"
    foreach ($r in $results) {
        $icon  = Get-LangIcon $r.lang
        $color = Get-LangColor $r.lang
        Write-Host -NoNewline "     $icon  "
        Write-Host -NoNewline $r.name -ForegroundColor $color
        if ($r.tags.Count -gt 0) {
            Write-Host "  $(($r.tags | ForEach-Object { "#$_" }) -join ' ')" -ForegroundColor DarkGray
        } else { Write-Host "" }
    }
    Write-Host ""
}

# -------------------------
# RECENT
# -------------------------
function Show-Recent($count = 3) {
    Ensure-Root
    $projects = Get-ChildItem $ROOT -Directory |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First $count

    if (!$projects) { return }

    Write-Host ""
    Write-Color "  🕐  Recently modified" "DarkGray"
    foreach ($p in $projects) {
        $meta = Join-Path $p.FullName "meta.json"
        $lang = "?"
        if (Test-Path $meta) { $lang = (Get-Content $meta | ConvertFrom-Json).lang }
        $icon  = Get-LangIcon $lang
        $color = Get-LangColor $lang
        $ago   = $p.LastWriteTime.ToString("MM-dd HH:mm")
        Write-Host -NoNewline "     $icon  "
        Write-Host -NoNewline $p.Name -ForegroundColor $color
        Write-Host "  $ago" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# -------------------------
# EXPORT (ZIP)
# -------------------------
function Export-Project($name) {
    if (!$name) { Write-Error "Usage: export <name>"; return }
    $target  = Join-Path $ROOT $name
    $zipPath = Join-Path $PWD "$name.zip"

    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }
    if (Test-Path $zipPath)   { Remove-Item $zipPath -Force }

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($target, $zipPath)
        Write-History "EXPORTED" "$name → $zipPath"
        Write-Success "Exported '$name' → $zipPath"
    } catch {
        Write-Error "Export failed: $_"
    }
}

# -------------------------
# DELETE
# -------------------------
function Delete-Project($name) {
    if (!$name) { Write-Error "Usage: delete <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    Write-Warn "Are you sure you want to delete '$name'? (y/n)"
    $confirm = Read-Host "  >"
    if ($confirm -eq "y" -or $confirm -eq "yes") {
        Remove-Item $target -Recurse -Force
        Write-History "DELETED" "$name"
        Write-Success "Deleted project: $name"
    } else { Write-Info "Cancelled" }
}

# -------------------------
# RENAME
# -------------------------
function Rename-Project($oldName, $newName) {
    if (!$oldName -or !$newName) { Write-Error "Usage: rename <old> <new>"; return }
    $oldPath = Join-Path $ROOT $oldName
    $newPath = Join-Path $ROOT $newName

    if (!(Test-Path $oldPath)) { Write-Error "Project '$oldName' not found"; return }
    if (Test-Path $newPath)    { Write-Error "Project '$newName' already exists"; return }

    Rename-Item $oldPath $newName
    $meta = Join-Path $newPath "meta.json"
    if (Test-Path $meta) {
        $data      = Get-Content $meta | ConvertFrom-Json
        $data.name = $newName
        $data | ConvertTo-Json | Set-Content $meta
    }
    Write-History "RENAMED" "$oldName → $newName"
    Write-Success "Renamed '$oldName' → '$newName'"
}

# -------------------------
# EDIT
# -------------------------
function Edit-Project($name) {
    if (!$name) { Write-Error "Usage: edit <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process "code" $target
        Write-Success "Opened '$name' in VS Code"
    } else {
        Start-Process $target
        Write-Info "Opened '$name' in file explorer"
    }
}

# -------------------------
# LIST
# -------------------------
function List-Projects {
    Ensure-Root
    $projects = Get-ChildItem $ROOT -Directory
    if ($projects.Count -eq 0) { Write-Warn "No projects yet. Create one with: project <lang> <name>"; return }

    Write-Host ""
    Write-Color "  📦  Projects ($($projects.Count))" "Cyan"
    Write-Color "  $('─' * 40)" "DarkGray"

    foreach ($p in $projects) {
        $meta = Join-Path $p.FullName "meta.json"
        $lang = "?"; $created = ""; $tags = @()
        if (Test-Path $meta) {
            $data    = Get-Content $meta | ConvertFrom-Json
            $lang    = $data.lang
            $created = $data.created
            if ($data.PSObject.Properties["tags"]) { $tags = @($data.tags) }
        }
        $icon  = Get-LangIcon $lang
        $color = Get-LangColor $lang
        Write-Host -NoNewline "  $icon  "
        Write-Host -NoNewline $p.Name -ForegroundColor $color
        $tagStr = if ($tags.Count -gt 0) { "  $(($tags | ForEach-Object { "#$_" }) -join ' ')" } else { "" }
        Write-Host "   $lang  |  $created$tagStr" -ForegroundColor DarkGray
    }
    Write-Host ""
}

# -------------------------
# INFO
# -------------------------
function Info-Project($name) {
    if (!$name) { Write-Error "Usage: info <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    $files   = Get-ChildItem $target -Recurse -File
    $size    = ($files | Measure-Object -Property Length -Sum).Sum
    $sizeKB  = [math]::Round($size / 1KB, 2)
    $created = (Get-Item $target).CreationTime.ToString("yyyy-MM-dd HH:mm:ss")

    Write-Host ""
    Write-Color "  📋  $name" "Cyan"
    Write-Color "  $('─' * 40)" "DarkGray"
    Write-Color "  📁  Path:     $target" "White"
    Write-Color "  🗓️   Created:  $created" "White"
    Write-Color "  📄  Files:    $($files.Count)" "White"
    Write-Color "  💾  Size:     $sizeKB KB" "White"

    $meta = Join-Path $target "meta.json"
    if (Test-Path $meta) {
        $data = Get-Content $meta | ConvertFrom-Json
        $lang = $data.lang
        Write-Host -NoNewline "  🔧  Language: "
        Write-Host $lang -ForegroundColor (Get-LangColor $lang)

        if ($data.PSObject.Properties["tags"] -and @($data.tags).Count -gt 0) {
            $tagStr = ($data.tags | ForEach-Object { "#$_" }) -join "  "
            Write-Color "  🏷️   Tags:     $tagStr" "DarkCyan"
        }
        if ($data.PSObject.Properties["note"] -and $data.note) {
            Write-Color "  📝  Note:     $($data.note)" "White"
        }
    }

    Write-Host ""
    Write-Color "  Files:" "DarkGray"
    foreach ($f in $files) {
        $rel = $f.FullName.Replace($target, "").TrimStart("\", "/")
        Write-Color "    • $rel" "DarkGray"
    }
    Write-Host ""
}

# -------------------------
# OPEN
# -------------------------
function Open-Project($name) {
    if (!$name) { Write-Error "Usage: open <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    Write-Host ""
    Write-Color "  📂  $name" "Cyan"
    Write-Color "  $('─' * 40)" "DarkGray"
    Get-ChildItem $target -Recurse | ForEach-Object {
        $rel = $_.FullName.Replace($target, "").TrimStart("\", "/")
        if ($_.PSIsContainer) { Write-Color "  📁 $rel/" "Yellow" }
        else                  { Write-Color "  📄 $rel" "White" }
    }
    Write-Host ""
}

# -------------------------
# RUN
# -------------------------
function Run-Project($name) {
    if (!$name) { Write-Error "Usage: run <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    $meta = Join-Path $target "meta.json"
    if (!(Test-Path $meta)) { Write-Error "No meta.json found — can't detect language"; return }

    $lang = (Get-Content $meta | ConvertFrom-Json).lang
    Write-Info "Running $lang project '$name'..."
    Write-Color "  $('─' * 40)" "DarkGray"

    Push-Location $target
    try {
        switch ($lang) {
            "node"   { node index.js }
            "python" { python main.py }
            "react"  { Write-Info "React: run 'npm run dev' manually in $target" }
            "go"     { go run main.go }
            "rust"   { rustc main.rs -o main_out; if ($LASTEXITCODE -eq 0) { ./main_out } }
            "ts"     { npx ts-node index.ts }
            "bun"    { bun run index.ts }
            default  { Write-Error "Don't know how to run lang: $lang" }
        }
    } catch { Write-Error "Run failed: $_" }
    Pop-Location
}

# -------------------------
# GIT INIT
# -------------------------
function Init-Git($name) {
    if (!$name) { Write-Error "Usage: init <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }
    if (!(Get-Command git -ErrorAction SilentlyContinue)) { Write-Error "git not found in PATH"; return }

    Push-Location $target
    git init | Out-Null
    git add . | Out-Null
    git commit -m "init: scaffold $name" | Out-Null
    Pop-Location
    Write-History "GIT_INIT" "$name"
    Write-Success "Git repo initialized in '$name' with initial commit"
}

# -------------------------
# INSTALL DEPS
# -------------------------
function Install-Deps($name) {
    if (!$name) { Write-Error "Usage: deps <name>"; return }
    $target = Join-Path $ROOT $name
    if (!(Test-Path $target)) { Write-Error "Project '$name' not found"; return }

    $meta = Join-Path $target "meta.json"
    if (!(Test-Path $meta)) { Write-Error "No meta.json — can't detect language"; return }

    $lang = (Get-Content $meta | ConvertFrom-Json).lang
    Push-Location $target
    try {
        switch ($lang) {
            { $_ -in "node","react","ts","bun" } {
                if (Get-Command bun -ErrorAction SilentlyContinue) {
                    Write-Info "Installing with bun..."; bun install
                } else {
                    Write-Info "Installing with npm..."; npm install
                }
            }
            "python" {
                if (Test-Path "requirements.txt") { Write-Info "Installing Python deps..."; pip install -r requirements.txt }
                else { Write-Warn "No requirements.txt found" }
            }
            "go"   { Write-Info "Tidying Go modules..."; go mod tidy }
            "rust" { Write-Info "Building with cargo..."; cargo build }
            default { Write-Warn "No dep install defined for lang: $lang" }
        }
        Write-Success "Dependencies installed for '$name'"
    } catch { Write-Error "Install failed: $_" }
    Pop-Location
}

# =====================================================================
#  NOTES  —  lyhyt muistiinpano projektille
# =====================================================================

function Set-Note($name, $note) {
    if (!$name) { Write-Error "Usage: notes <name> [teksti]"; return }
    $meta = Join-Path $ROOT $name "meta.json"
    if (!(Test-Path $meta)) { Write-Error "Project '$name' not found"; return }

    $data = Get-Content $meta | ConvertFrom-Json

    # Jos note-kenttää ei vielä ole, lisätään se
    if (!$data.PSObject.Properties["note"]) {
        $data | Add-Member -NotePropertyName "note" -NotePropertyValue ""
    }

    if (!$note) {
        # Interaktiivinen syöttö
        Write-Host ""
        Write-Color "  📝  Note for '$name'" "Cyan"
        if ($data.note) { Write-Color "  Current: $($data.note)" "DarkGray" }
        Write-Color "  (Enter to keep current, '-' to clear)" "DarkGray"
        Write-Host -NoNewline "  ❯ "
        $note = Read-Host
        if ($note -eq "") { Write-Info "Unchanged"; return }
        if ($note -eq "-") { $note = "" }
    }

    $data.note = $note
    $data | ConvertTo-Json | Set-Content $meta

    if ($note) {
        Write-History "NOTE" "$name  ← $note"
        Write-Success "Note saved for '$name'"
        Write-Color "     📝  $note" "DarkGray"
    } else {
        Write-History "NOTE_CLEARED" "$name"
        Write-Success "Note cleared for '$name'"
    }
}

# =====================================================================
#  TAGS  —  lisää / poista / listaa tageja
# =====================================================================

function Set-Tag($name, $tag) {
    if (!$name) { Write-Error "Usage: tag <name> <tag>   tai   tag <name> -<tag> (poista)"; return }
    $meta = Join-Path $ROOT $name "meta.json"
    if (!(Test-Path $meta)) { Write-Error "Project '$name' not found"; return }

    $data = Get-Content $meta | ConvertFrom-Json

    if (!$data.PSObject.Properties["tags"]) {
        $data | Add-Member -NotePropertyName "tags" -NotePropertyValue @()
    }

    $tags = @($data.tags)

    # Ei tagia annettu — näytä nykyiset
    if (!$tag) {
        Write-Host ""
        Write-Color "  🏷️   Tags for '$name'" "Cyan"
        if ($tags.Count -eq 0) { Write-Warn "  No tags yet." }
        else { Write-Color "  $(($tags | ForEach-Object { "#$_" }) -join '  ')" "DarkCyan" }
        Write-Host ""
        return
    }

    # Poistaminen: -tagname
    if ($tag.StartsWith("-")) {
        $remove = $tag.Substring(1)
        if ($tags -contains $remove) {
            $tags   = @($tags | Where-Object { $_ -ne $remove })
            $data.tags = $tags
            $data | ConvertTo-Json | Set-Content $meta
            Write-History "TAG_REMOVED" "$name  #$remove"
            Write-Success "Removed tag '#$remove' from '$name'"
        } else {
            Write-Warn "Tag '#$remove' not found on '$name'"
        }
        return
    }

    # Lisääminen
    $tag = $tag.TrimStart("#")
    if ($tags -contains $tag) {
        Write-Warn "Tag '#$tag' already set on '$name'"
        return
    }
    $tags      = @($tags) + $tag
    $data.tags = $tags
    $data | ConvertTo-Json | Set-Content $meta
    Write-History "TAG_ADDED" "$name  #$tag"
    Write-Success "Added tag '#$tag' to '$name'"
    Write-Color "     🏷️   $(($tags | ForEach-Object { "#$_" }) -join '  ')" "DarkCyan"
}

# =====================================================================
#  HISTORY  —  operaatioloki
# =====================================================================

function Show-History($filter = "") {
    if (!(Test-Path $HISTORY_LOG)) {
        Write-Warn "No history yet."
        return
    }

    $lines = Get-Content $HISTORY_LOG
    if ($filter) { $lines = $lines | Where-Object { $_ -like "*$filter*" } }

    if (!$lines -or $lines.Count -eq 0) {
        Write-Warn "No history matching '$filter'"
        return
    }

    # Viimeiset 30 rivi uusin ensin
    $lines = @($lines)[-[math]::Min(30, $lines.Count)..-1] | Sort-Object -Descending

    Write-Host ""
    Write-Color "  📜  History$(if ($filter) { " — '$filter'" })" "Cyan"
    Write-Color "  $('─' * 50)" "DarkGray"

    foreach ($line in $lines) {
        # Parsitaan formaatti: [yyyy-MM-dd HH:mm:ss]  ACTION  detail
        if ($line -match '^\[(.+?)\]\s+(\w+)\s*(.*)$') {
            $ts     = $matches[1]
            $action = $matches[2]
            $detail = $matches[3]

            $color = switch ($action) {
                "CREATED"      { "Green" }
                "DELETED"      { "Red" }
                "RENAMED"      { "Yellow" }
                "CLONED"       { "Cyan" }
                "EXPORTED"     { "DarkCyan" }
                "GIT_INIT"     { "Blue" }
                "TAG_ADDED"    { "Magenta" }
                "TAG_REMOVED"  { "DarkMagenta" }
                "NOTE"         { "White" }
                "NOTE_CLEARED" { "DarkGray" }
                default        { "White" }
            }

            $icon = switch ($action) {
                "CREATED"      { "✅" }
                "DELETED"      { "🗑 " }
                "RENAMED"      { "✏ " }
                "CLONED"       { "📋" }
                "EXPORTED"     { "📤" }
                "GIT_INIT"     { "🔧" }
                "TAG_ADDED"    { "🏷 " }
                "TAG_REMOVED"  { "🏷 " }
                "NOTE"         { "📝" }
                "NOTE_CLEARED" { "📝" }
                default        { "  " }
            }

            Write-Host -NoNewline "  $icon  "
            Write-Host -NoNewline "$ts  " -ForegroundColor DarkGray
            Write-Host -NoNewline "$action" -ForegroundColor $color
            if ($detail) { Write-Host "  $detail" -ForegroundColor DarkGray }
            else         { Write-Host "" }
        } else {
            Write-Color "  $line" "DarkGray"
        }
    }
    Write-Host ""
    Write-Color "  📁  $HISTORY_LOG" "DarkGray"
    Write-Host ""
}

function Clear-History {
    if (!(Test-Path $HISTORY_LOG)) { Write-Warn "No history file found."; return }
    Write-Warn "Clear entire history? (y/n)"
    $confirm = Read-Host "  >"
    if ($confirm -eq "y" -or $confirm -eq "yes") {
        Remove-Item $HISTORY_LOG -Force
        Write-Success "History cleared"
    } else { Write-Info "Cancelled" }
}

# -------------------------
# HELP
# -------------------------
function Help {
    Write-Host ""
    Write-Color "  ┌─────────────────────────────────────────┐" "DarkCyan"
    Write-Color "  │        MAKE MULTI CLI  🚀  v1.2          │" "Cyan"
    Write-Color "  └─────────────────────────────────────────┘" "DarkCyan"
    Write-Host ""
    Write-Color "  COMMANDS" "Yellow"
    Write-Color "  ─────────────────────────────────────────" "DarkGray"
    Write-Color "  project <lang> <name>   Create a new project" "White"
    Write-Color "  clone   <name> <new>    Clone a project" "White"
    Write-Color "  search  <keyword>       Search by name, lang or tag" "White"
    Write-Color "  recent                  Show recently modified projects" "White"
    Write-Color "  export  <name>          Export project as .zip" "White"
    Write-Color "  list                    List all projects" "White"
    Write-Color "  info    <name>          Show project details" "White"
    Write-Color "  open    <name>          Show project files" "White"
    Write-Color "  edit    <name>          Open in VS Code" "White"
    Write-Color "  run     <name>          Run the project" "White"
    Write-Color "  rename  <old>  <new>    Rename a project" "White"
    Write-Color "  delete  <name>          Delete a project" "White"
    Write-Color "  init    <name>          Git init + first commit" "White"
    Write-Color "  deps    <name>          Install dependencies" "White"
    Write-Host ""
    Write-Color "  notes   <name> [teksti] Set/view project note" "White"
    Write-Color "  tag     <name> <tag>    Add tag  (e.g. work, hobby)" "White"
    Write-Color "  tag     <name> -<tag>   Remove tag" "White"
    Write-Color "  history [filter]        Show operation log" "White"
    Write-Color "  history clear           Clear the log" "White"
    Write-Host ""
    Write-Color "  ui                      Arrow-key navigation 🎮" "White"
    Write-Color "  help                    Show this help" "White"
    Write-Color "  exit                    Quit" "White"
    Write-Host ""
    Write-Color "  LANGUAGES" "Yellow"
    Write-Color "  ─────────────────────────────────────────" "DarkGray"
    Write-Host -NoNewline "  "
    Write-Host -NoNewline "🟩 node  " -ForegroundColor Green
    Write-Host -NoNewline "⚛️  react  " -ForegroundColor Cyan
    Write-Host -NoNewline "🔷 ts  " -ForegroundColor DarkCyan
    Write-Host "🍞 bun" -ForegroundColor Magenta
    Write-Host -NoNewline "  "
    Write-Host -NoNewline "🐍 python  " -ForegroundColor Yellow
    Write-Host -NoNewline "🐹 go  " -ForegroundColor Blue
    Write-Host "🦀 rust" -ForegroundColor Red
    Write-Host ""
}

# -------------------------
# BANNER
# -------------------------
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Color "  ╔══════════════════════════════════════════╗" "Cyan"
    Write-Color "  ║                                          ║" "Cyan"
    Write-Color "  ║        MAKE MULTI CLI  🚀  v1.2          ║" "Cyan"
    Write-Color "  ║   scaffold · run · manage · ship fast    ║" "DarkCyan"
    Write-Color "  ║                                          ║" "Cyan"
    Write-Color "  ╚══════════════════════════════════════════╝" "Cyan"
    Write-Host ""
    Show-Recent
    Write-Color "  Type 'help' to see all commands." "DarkGray"
    Write-Host ""
}

# =====================================================================
#  UI MODE  —  arrow-key navigation
# =====================================================================

function Read-ArrowKey {
    $key = [Console]::ReadKey($true)
    if ($key.Key -eq "UpArrow")    { return "UP" }
    if ($key.Key -eq "DownArrow")  { return "DOWN" }
    if ($key.Key -eq "LeftArrow")  { return "LEFT" }
    if ($key.Key -eq "RightArrow") { return "RIGHT" }
    if ($key.Key -eq "Enter")      { return "ENTER" }
    if ($key.Key -eq "Escape")     { return "ESC" }
    if ($key.Key -eq "Backspace")  { return "BACK" }
    return $null
}

function Show-UIHeader {
    Write-Host ""
    Write-Color "  ╔══════════════════════════════════════════╗" "Cyan"
    Write-Color "  ║        MAKE MULTI CLI  🚀  — UI MODE     ║" "Cyan"
    Write-Color "  ╚══════════════════════════════════════════╝" "Cyan"
    Write-Color "  ↑↓ navigate   Enter select   Esc back/exit" "DarkGray"
    Write-Host ""
}

# Build a fixed-width preview panel for a project
function Get-ProjectPreview($name) {
    $target = Join-Path $ROOT $name
    $meta   = Join-Path $target "meta.json"
    $lang   = "?"; $created = ""; $files = @(); $tags = @(); $note = ""

    if (Test-Path $meta) {
        $data    = Get-Content $meta | ConvertFrom-Json
        $lang    = $data.lang
        $created = $data.created
        if ($data.PSObject.Properties["tags"]) { $tags = @($data.tags) }
        if ($data.PSObject.Properties["note"]) { $note = $data.note }
    }
    if (Test-Path $target) {
        $files = @(Get-ChildItem $target -Recurse -File | ForEach-Object {
            $_.FullName.Replace($target, "").TrimStart("\", "/")
        })
        $size   = (Get-ChildItem $target -Recurse -File | Measure-Object -Property Length -Sum).Sum
        $sizeKB = [math]::Round($size / 1KB, 2)
    }

    $icon  = Get-LangIcon $lang
    $color = Get-LangColor $lang
    $W     = 28

    Write-Color "  ┌$('─' * $W)┐" "DarkGray"

    $title = " $icon $name"
    $pad   = $W - $title.Length - 1
    if ($pad -lt 0) { $pad = 0 }
    Write-Host -NoNewline "  │"
    Write-Host -NoNewline $title -ForegroundColor $color
    Write-Host "$((' ' * $pad))│" -ForegroundColor DarkGray

    Write-Color "  ├$('─' * $W)┤" "DarkGray"

    $langLine = " lang:    $lang"
    $lpad = $W - $langLine.Length - 1
    if ($lpad -lt 0) { $lpad = 0 }
    Write-Host -NoNewline "  │"
    Write-Host -NoNewline $langLine -ForegroundColor $color
    Write-Host "$((' ' * $lpad))│" -ForegroundColor DarkGray

    foreach ($line in @(" created: $created", " files:   $($files.Count)", " size:    $sizeKB KB")) {
        $lp = $W - $line.Length - 1
        if ($lp -lt 0) { $lp = 0; $line = $line.Substring(0, $W-1) }
        Write-Host "  │$line$((' ' * $lp))│" -ForegroundColor DarkGray
    }

    # Tags
    if ($tags.Count -gt 0) {
        $tagLine = " tags:   $(($tags | ForEach-Object { "#$_" }) -join ' ')"
        $tlp = $W - $tagLine.Length - 1
        if ($tlp -lt 0) { $tagLine = $tagLine.Substring(0, $W - 4) + "..."; $tlp = 1 }
        Write-Host -NoNewline "  │"
        Write-Host -NoNewline $tagLine -ForegroundColor DarkCyan
        Write-Host "$((' ' * $tlp))│" -ForegroundColor DarkGray
    }

    # Note
    if ($note) {
        $noteLine = " 📝 $note"
        $nlp = $W - $noteLine.Length - 1
        if ($nlp -lt 0) { $noteLine = $noteLine.Substring(0, $W - 4) + "..."; $nlp = 1 }
        Write-Host -NoNewline "  │"
        Write-Host -NoNewline $noteLine -ForegroundColor White
        Write-Host "$((' ' * $nlp))│" -ForegroundColor DarkGray
    }

    Write-Color "  ├$('─' * $W)┤" "DarkGray"
    Write-Color "  │ Files:$((' ' * ($W - 7)))│" "DarkGray"

    $maxFiles = 5
    $shown    = [math]::Min($files.Count, $maxFiles)
    for ($i = 0; $i -lt $shown; $i++) {
        $f   = $files[$i]
        $fl  = " • $f"
        if ($fl.Length -gt $W - 1) { $fl = $fl.Substring(0, $W - 4) + "..." }
        $fp  = $W - $fl.Length - 1
        if ($fp -lt 0) { $fp = 0 }
        Write-Host "  │$fl$((' ' * $fp))│" -ForegroundColor DarkGray
    }
    if ($files.Count -gt $maxFiles) {
        $more  = " + $($files.Count - $maxFiles) more..."
        $morep = $W - $more.Length - 1
        if ($morep -lt 0) { $morep = 0 }
        Write-Host "  │$more$((' ' * $morep))│" -ForegroundColor DarkGray
    }

    Write-Color "  └$('─' * $W)┘" "DarkGray"
}

# -------------------------
# UI: NEW PROJECT WIZARD
# -------------------------
function Show-NewProject-UI {
    $langs     = @("node","python","react","go","rust","ts","bun")
    $langSel   = 0

    while ($true) {
        Clear-Host
        Show-UIHeader
        Write-Color "  NEW PROJECT — Step 1: Choose language" "Yellow"
        Write-Color "  $('─' * 44)" "DarkGray"
        Write-Host ""

        for ($i = 0; $i -lt $langs.Count; $i++) {
            $l     = $langs[$i]
            $icon  = Get-LangIcon $l
            $color = Get-LangColor $l
            if ($i -eq $langSel) {
                Write-Host -NoNewline "  "
                Write-Host " ❯ $icon  $l  " -ForegroundColor Black -BackgroundColor Cyan
            } else {
                Write-Host -NoNewline "     $icon  "
                Write-Host $l -ForegroundColor $color
            }
        }

        Write-Host ""
        Write-Color "  ↑↓ choose   Enter confirm   Esc cancel" "DarkGray"
        $key = Read-ArrowKey

        switch ($key) {
            "UP"    { if ($langSel -gt 0) { $langSel-- } else { $langSel = $langs.Count - 1 } }
            "DOWN"  { if ($langSel -lt $langs.Count - 1) { $langSel++ } else { $langSel = 0 } }
            "ESC"   { return $null }
            "ENTER" { break }
        }
        if ($key -eq "ENTER") { break }
    }

    $chosenLang = $langs[$langSel]

    Clear-Host
    Show-UIHeader
    Write-Color "  NEW PROJECT — Step 2: Enter project name" "Yellow"
    Write-Color "  $('─' * 44)" "DarkGray"
    Write-Host ""
    $icon  = Get-LangIcon $chosenLang
    $color = Get-LangColor $chosenLang
    Write-Host -NoNewline "  Language: $icon "
    Write-Host $chosenLang -ForegroundColor $color
    Write-Host ""
    Write-Color "  Project name:" "White"
    Write-Host -NoNewline "  ❯ "
    $chosenName = Read-Host

    if (!$chosenName) { Write-Warn "Cancelled"; return $null }

    Clear-Host
    Show-UIHeader
    New-Template $chosenLang $chosenName
    Write-Host ""
    Write-Color "  Press Enter to continue..." "DarkGray"
    Read-ArrowKey | Out-Null
    return "REFRESH"
}

# -------------------------
# UI: PROJECT LIST
# -------------------------
function Show-ProjectList-UI {
    Ensure-Root
    $selected = 0

    while ($true) {
        $projects = @(Get-ChildItem $ROOT -Directory)
        if ($selected -ge $projects.Count -and $projects.Count -gt 0) {
            $selected = $projects.Count - 1
        }

        Clear-Host
        Show-UIHeader
        Write-Color "  📦  PROJECTS  ($($projects.Count))" "Yellow"
        Write-Color "  $('─' * 44)" "DarkGray"
        Write-Host ""

        if ($projects.Count -eq 0) {
            Write-Warn "  No projects yet."
            Write-Host ""
        } else {
            for ($i = 0; $i -lt $projects.Count; $i++) {
                $p    = $projects[$i]
                $meta = Join-Path $p.FullName "meta.json"
                $lang = "?"; $date = ""
                if (Test-Path $meta) {
                    $data = Get-Content $meta | ConvertFrom-Json
                    $lang = $data.lang; $date = $data.created
                }
                $icon  = Get-LangIcon $lang
                $color = Get-LangColor $lang

                if ($i -eq $selected) {
                    Write-Host -NoNewline "  "
                    Write-Host -NoNewline " ❯ $icon  " -ForegroundColor Black -BackgroundColor Cyan
                    Write-Host $p.Name -ForegroundColor Black -BackgroundColor Cyan
                } else {
                    Write-Host -NoNewline "     $icon  "
                    Write-Host $p.Name -ForegroundColor $color
                }
            }

            Write-Host ""
            Write-Color "  $('─' * 44)" "DarkGray"
            Get-ProjectPreview $projects[$selected].Name
        }

        Write-Host ""
        Write-Color "  ↑↓ navigate   Enter open   N new project   Esc exit" "DarkGray"

        $rawKey = [Console]::ReadKey($true)

        if ($rawKey.KeyChar -eq 'n' -or $rawKey.KeyChar -eq 'N') {
            Show-NewProject-UI | Out-Null
            continue
        }

        $key = $null
        if ($rawKey.Key -eq "UpArrow")   { $key = "UP" }
        if ($rawKey.Key -eq "DownArrow") { $key = "DOWN" }
        if ($rawKey.Key -eq "Enter")     { $key = "ENTER" }
        if ($rawKey.Key -eq "Escape")    { $key = "ESC" }

        switch ($key) {
            "UP"    {
                if ($projects.Count -gt 0) {
                    if ($selected -gt 0) { $selected-- } else { $selected = $projects.Count - 1 }
                }
            }
            "DOWN"  {
                if ($projects.Count -gt 0) {
                    if ($selected -lt $projects.Count - 1) { $selected++ } else { $selected = 0 }
                }
            }
            "ENTER" {
                if ($projects.Count -gt 0) {
                    Show-ProjectActions-UI $projects[$selected].Name | Out-Null
                }
            }
            "ESC"   { return }
        }
    }
}

# -------------------------
# UI: PROJECT ACTIONS
# -------------------------
function Show-ProjectActions-UI($name) {
    $actions = @(
        @{ label = "▶  Run";            cmd = "run"    }
        @{ label = "✏  Edit (VS Code)"; cmd = "edit"   }
        @{ label = "📋  Info";           cmd = "info"   }
        @{ label = "📂  Open files";     cmd = "open"   }
        @{ label = "📦  Install deps";   cmd = "deps"   }
        @{ label = "🔧  Git init";       cmd = "init"   }
        @{ label = "📤  Export (zip)";   cmd = "export" }
        @{ label = "📝  Note";           cmd = "note"   }
        @{ label = "🏷   Tag";           cmd = "tag"    }
        @{ label = "✏  Rename";         cmd = "rename" }
        @{ label = "🗑  Delete";         cmd = "delete" }
        @{ label = "← Back";            cmd = "back"   }
    )

    $selected = 0

    while ($true) {
        $meta = Join-Path $ROOT $name "meta.json"
        $lang = "?"; $created = ""
        if (Test-Path $meta) {
            $data    = Get-Content $meta | ConvertFrom-Json
            $lang    = $data.lang
            $created = $data.created
        }
        $icon  = Get-LangIcon $lang
        $color = Get-LangColor $lang

        Clear-Host
        Show-UIHeader

        Write-Host -NoNewline "  $icon  "
        Write-Host $name -ForegroundColor $color
        Write-Host "     lang: $lang   created: $created" -ForegroundColor DarkGray
        Write-Host ""
        Write-Color "  $('─' * 44)" "DarkGray"
        Write-Host ""

        for ($i = 0; $i -lt $actions.Count; $i++) {
            $a = $actions[$i]
            if ($i -eq $selected) {
                Write-Host -NoNewline "  "
                Write-Host " ❯ $($a.label)  " -ForegroundColor Black -BackgroundColor Cyan
            } else {
                Write-Color "     $($a.label)" "White"
            }
        }

        Write-Host ""
        Write-Color "  ↑↓ navigate   Enter select   Esc back" "DarkGray"

        $key = Read-ArrowKey

        switch ($key) {
            "UP"    { if ($selected -gt 0) { $selected-- } else { $selected = $actions.Count - 1 } }
            "DOWN"  { if ($selected -lt $actions.Count - 1) { $selected++ } else { $selected = 0 } }
            "ESC"   { return "OK" }
            "ENTER" {
                $cmd = $actions[$selected].cmd
                switch ($cmd) {
                    "run" {
                        Clear-Host; Write-Host ""
                        Run-Project $name
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "edit" { Edit-Project $name }
                    "info" {
                        Clear-Host
                        Info-Project $name
                        Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "open" {
                        Clear-Host
                        Open-Project $name
                        Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "deps" {
                        Clear-Host
                        Install-Deps $name
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "init" {
                        Clear-Host
                        Init-Git $name
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "export" {
                        Clear-Host; Write-Host ""
                        Export-Project $name
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "note" {
                        Clear-Host; Write-Host ""
                        Set-Note $name
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "tag" {
                        Clear-Host; Write-Host ""
                        Write-Color "  🏷️  Tag for '$name'" "Cyan"
                        Write-Color "  Add: work   Remove: -work   Enter to view" "DarkGray"
                        Write-Host -NoNewline "  ❯ "
                        $t = Read-Host
                        Set-Tag $name $t
                        Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                        Read-ArrowKey | Out-Null
                    }
                    "rename" {
                        Clear-Host; Write-Host ""
                        Write-Color "  New name for '$name':" "Cyan"
                        Write-Host -NoNewline "  ❯ "
                        $newName = Read-Host
                        if ($newName) {
                            Rename-Project $name $newName
                            Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                            Read-ArrowKey | Out-Null
                            return "REFRESH"
                        }
                    }
                    "delete" {
                        Clear-Host; Write-Host ""
                        Write-Warn "Delete '$name'? (y/n)"
                        Write-Host -NoNewline "  ❯ "
                        $confirm = Read-Host
                        if ($confirm -eq "y" -or $confirm -eq "yes") {
                            Remove-Item (Join-Path $ROOT $name) -Recurse -Force
                            Write-History "DELETED" "$name"
                            Write-Success "Deleted: $name"
                            Write-Host ""; Write-Color "  Press Enter to continue..." "DarkGray"
                            Read-ArrowKey | Out-Null
                            return "REFRESH"
                        } else { Write-Info "Cancelled" }
                    }
                    "back" { return "OK" }
                }
            }
        }
    }
}

# -------------------------
# STARTUP MODE PICKER
# -------------------------
function Show-ModePicker {
    Clear-Host
    Write-Host ""
    Write-Color "  ╔══════════════════════════════════════════╗" "Cyan"
    Write-Color "  ║                                          ║" "Cyan"
    Write-Color "  ║        MAKE MULTI CLI  🚀  v1.2          ║" "Cyan"
    Write-Color "  ║   scaffold · run · manage · ship fast    ║" "DarkCyan"
    Write-Color "  ║                                          ║" "Cyan"
    Write-Color "  ╚══════════════════════════════════════════╝" "Cyan"
    Write-Host ""
    Write-Color "  Choose your mode:" "Yellow"
    Write-Host ""

    $selected = 0
    $modes = @(
        @{ label = "🎮  UI Mode    — arrow-key navigation" }
        @{ label = "⌨️   Text Mode  — classic CLI commands" }
    )

    while ($true) {
        [Console]::SetCursorPosition(0, 9)
        for ($i = 0; $i -lt $modes.Count; $i++) {
            if ($i -eq $selected) {
                Write-Host -NoNewline "  "
                Write-Host " ❯ $($modes[$i].label)  " -ForegroundColor Black -BackgroundColor Cyan
            } else {
                Write-Color "     $($modes[$i].label)" "White"
            }
        }
        Write-Host ""
        Write-Color "  ↑↓ choose   Enter confirm   " "DarkGray"

        $raw = [Console]::ReadKey($true)
        if ($raw.Key -eq "UpArrow")   { $selected = 0 }
        if ($raw.Key -eq "DownArrow") { $selected = 1 }
        if ($raw.Key -eq "Enter") {
            if ($selected -eq 0) { return "ui" } else { return "text" }
        }
    }
}

$startMode = Show-ModePicker

if ($startMode -eq "ui") {
    Show-ProjectList-UI
}

Show-Banner

# -------------------------
# CLI LOOP
# -------------------------
while ($true) {
    Write-Host ""
    Write-Host -NoNewline "  "
    Write-Host -NoNewline "make" -ForegroundColor Cyan
    Write-Host -NoNewline " ❯ " -ForegroundColor DarkGray
    $userInput = Read-Host
    $parts = $userInput.Trim() -split "\s+"
    $cmd   = $parts[0].ToLower()
    $arg1  = if ($parts.Count -gt 1) { $parts[1] } else { $null }
    $arg2  = if ($parts.Count -gt 2) { $parts[2] } else { $null }
    # Tuki monisanaisille noteille: "notes myproject tämä on pitkä teksti"
    $rest  = if ($parts.Count -gt 2) { ($parts[2..($parts.Count-1)] -join " ") } else { $null }

    switch ($cmd) {
        "project" { New-Template $arg1 $arg2 }
        "clone"   { Clone-Project $arg1 $arg2 }
        "search"  { Search-Projects $arg1 }
        "recent"  { Show-Recent 5 }
        "export"  { Export-Project $arg1 }
        "list"    { List-Projects }
        "info"    { Info-Project $arg1 }
        "open"    { Open-Project $arg1 }
        "edit"    { Edit-Project $arg1 }
        "run"     { Run-Project $arg1 }
        "rename"  { Rename-Project $arg1 $arg2 }
        "delete"  { Delete-Project $arg1 }
        "init"    { Init-Git $arg1 }
        "deps"    { Install-Deps $arg1 }
        "notes"   { Set-Note $arg1 $rest }
        "tag"     { Set-Tag $arg1 $arg2 }
        "history" {
            if ($arg1 -eq "clear") { Clear-History }
            else                   { Show-History $arg1 }
        }
        "help"    { Help }
        "ui"      { Show-ProjectList-UI; Show-Banner }
        "exit"    { Write-Host ""; Write-Color "  👋  Bye!" "Cyan"; Write-Host ""; exit }
        ""        { }
        default   { Write-Error "Unknown command '$cmd' — type 'help' for usage" }
    }
}
