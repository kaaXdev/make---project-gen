🧰 MAKE CLI

A simple interactive developer CLI for quickly creating, editing, and deleting projects in multiple programming languages.

🚀 What is this?

Make CLI is a lightweight terminal tool that helps you manage small development projects from a single command interface.

It provides fast project scaffolding and basic project management without extra setup or dependencies.

⚡ Features
🧱 Multi-language project generator
🖥️ Interactive CLI shell (make>)
📂 Automatic project folder handling
✏️ Open projects in VS Code or File Explorer
🗑️ Delete projects easily
📦 Supported languages
Node.js
Python
React
Go
Rust
📚 Commands
Create project
project <language> <name>

Examples:

project node api
project python bot
project react app
project go server
project rust cli
Edit project
edit <name>

Opens the project in VS Code or File Explorer.

Delete project
delete <name>

Removes the project folder.

Exit CLI
exit
📁 Project structure

Projects are stored locally in a simple folder structure:

projects/
 ├─ api/
 │   ├─ index.js
 │   ├─ package.json
 ├─ bot/
 │   ├─ main.py
🧠 Concept

Make CLI is designed to be a minimal developer productivity tool:

fast project creation
simple command interface
no setup complexity
local-first workflow
🚀 Example usage flow
make> project node api
make> project python bot
make> edit api
make> delete bot
make> exit
📄 License

MIT
