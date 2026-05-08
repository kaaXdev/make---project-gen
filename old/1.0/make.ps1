$ROOT = Join-Path $PWD "projects"

function Ensure-Root {
    if (!(Test-Path $ROOT)) {
        New-Item -ItemType Directory -Path $ROOT | Out-Null
    }
}

# -------------------------
# TEMPLATES
# -------------------------
function New-Template($lang, $name) {

    Ensure-Root
    $target = Join-Path $ROOT $name

    if (Test-Path $target) {
        Write-Host "❌ Project already exists"
        return
    }

    New-Item -ItemType Directory -Path $target | Out-Null

    switch ($lang) {

        "node" {
            "console.log('Node project $name');" | Set-Content "$target/index.js"
            @"
{
  "name": "$name",
  "type": "module"
}
"@ | Set-Content "$target/package.json"
        }

        "python" {
            "print('Python project $name')" | Set-Content "$target/main.py"
        }

        "react" {
            @"
import React from 'react';

export default function App() {
  return <h1>$name</h1>;
}
"@ | Set-Content "$target/App.jsx"
        }

        "go" {
            @"
package main

import "fmt"

func main() {
    fmt.Println("Go project $name")
}
"@ | Set-Content "$target/main.go"
        }

        "rust" {
            @"
fn main() {
    println!("Rust project $name");
}
"@ | Set-Content "$target/main.rs"
        }

        default {
            Write-Host "❌ Unknown language: $lang"
            return
        }
    }

    Write-Host "🚀 Created $lang project: $name"
}

# -------------------------
# DELETE
# -------------------------
function Delete-Project($name) {
    $target = Join-Path $ROOT $name

    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "🗑 deleted $name"
    } else {
        Write-Host "❌ not found"
    }
}

# -------------------------
# EDIT
# -------------------------
function Edit-Project($name) {
    $target = Join-Path $ROOT $name

    if (!(Test-Path $target)) {
        Write-Host "❌ not found"
        return
    }

    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process "code" $target
    } else {
        Start-Process $target
    }
}

# -------------------------
# HELP
# -------------------------
function Help {
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  project <lang> <name>"
    Write-Host "  delete <name>"
    Write-Host "  edit <name>"
    Write-Host "  exit"
    Write-Host ""
    Write-Host "Languages:"
    Write-Host "  node, python, react, go, rust"
    Write-Host ""
}

# -------------------------
# CLI LOOP
# -------------------------
Clear-Host
Write-Host "====================="
Write-Host " MAKE MULTI CLI 🚀"
Write-Host "====================="
Help

while ($true) {

    $input = Read-Host "make"

    $parts = $input -split " "
    $cmd = $parts[0]
    $lang = $parts[1]
    $name = $parts[2]

    switch ($cmd) {

        "project" { New-Template $lang $name }
        "delete"  { Delete-Project $lang }
        "edit"    { Edit-Project $lang }
        "help"    { Help }
        "exit"    { break }

        default { Write-Host "❌ unknown command" }
    }
}