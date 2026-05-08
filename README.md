Make Multi CLI 🚀

Epic project scaffolding tool for developers — built in PowerShell.

Features

Two modes — classic text CLI or full arrow-key UI navigator
7 languages — Node, Python, React, Go, Rust, TypeScript, Bun
Smart scaffolding — generates README, .gitignore, package.json and more per language
Project management — run, edit, rename, clone, delete, export
Git integration — one command to init a repo and make the first commit
Dependency install — auto-detects language and runs the right package manager
Arrow-key UI — browse projects with a live preview panel, color-coded by language
Recent projects — shown on every startup automatically


UI Mode 🎮
Launch with arrow keys at startup, or type ui in text mode.
KeyAction↑ / ↓Navigate projectsEnterOpen project actionsNCreate new project (with language picker)EscGo back / exit UI mode
Each project shows a live preview panel with language, creation date, file count, size, and file list.

Text Mode ⌨️
Commands
CommandDescriptionproject <lang> <name>Create a new projectclone <name> <new>Clone an existing projectsearch <keyword>Search by name or languagerecentShow recently modified projectsexport <name>Export project as .ziplistList all projectsinfo <name>Show project detailsopen <name>Show project file treeedit <name>Open in VS Coderun <name>Run the projectrename <old> <new>Rename a projectdelete <name>Delete a project (with confirmation)init <name>Git init + first commitdeps <name>Install dependenciesuiSwitch to UI modehelpShow helpexitQuit
Examples
powershellmake ❯ project node my-api
make ❯ project react dashboard
make ❯ clone dashboard dashboard-v2
make ❯ run my-api
make ❯ export my-api
make ❯ search react

Supported Languages
IconLanguageEntry fileRun command🟩nodeindex.jsnode index.js🐍pythonmain.pypython main.py⚛️reactApp.jsxnpm run dev🐹gomain.gogo run main.go🦀rustmain.rsrustc + run🔷tsindex.tsts-node index.ts🍞bunindex.tsbun run index.ts
Each project is created with:

Language entry file
README.md
.gitignore tailored for the language
package.json / tsconfig.json where applicable
meta.json storing name, language and creation date


Tips

In UI mode, press N anywhere in the project list to open the new project wizard
export uses the built-in .NET zip library — no external tools needed
deps auto-detects bun if installed, falls back to npm
init creates a git repo and makes the first commit in one step
Exiting UI mode drops you back into text mode automatically


Made with PowerShell 💙
