# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Coin Catcher** — Godot 4.7 2D arcade game. Move a blue square (WASD/Arrows) to collect gold coins while avoiding red enemies. Press R or click Restart to replay.

Viewport: 800×600, GL Compatibility renderer.

## Commands

**Run the game** — open `project.godot` in Godot 4.7+ and press F5. Main scene: `scenes/main.tscn`.

**Run tests** — execute the PowerShell script:
```powershell
powershell -ExecutionPolicy Bypass -File run_tests.ps1
```
This launches Godot headless, runs GUT against all tests under `tests/`, and writes logs to `test_results/`.

**Run a single test file** — call Godot directly:
```powershell
& "C:\Users\Administrator\Godot\Godot_v4.7.1-stable_win64_console.exe" --headless --path . -s tests/unit/game_manager_test_test.gd -- --gut=1
```
Replace the path to the `.gd` file as needed. Tests extend `GutTest`.

**Export / package** — via Godot Editor: Project → Export.

## Architecture

**Central orchestrator: `scripts/game_manager.gd`**
The `Main` node (root of `main.tscn`) is a `Node2D` that drives everything: spawns player/coins/enemies, handles the physics-based coin collection loop, manages score, and triggers game-over. It exposes public state (`score`, `game_over`, `coins`, `enemies`) that tests read directly.

**Entity scripts** (all under `scripts/`):
- `player.gd` — `CharacterBody2D`, joined to group `'player'`, clamped to viewport bounds.
- `enemy.gd` — `CharacterBody2D`, chases the player node via `/root/Main`, wraps at screen edges (0/800 x 0/600), calls `_end_game()` on collision.
- `coin.gd` — `Area2D`, credits score to `/root/Main` on `body_entered`, then `queue_free()`.
- `game_manager.gd` — also does proximity-based coin collection in `_physics_process` as a fallback path.

**Scenes** (`scenes/`): `main.tscn` (root), `player.tscn`, `coin.tscn`, `enemy.tscn`. Loaded via `preload()` and `instantiate()` in `game_manager.gd`.

**Testing** (`tests/`, GUT 9.7.1 addon in `addons/gut/`):
- `tests/unit/` — tests that inspect `GameManager` state after `start_game()` (counts, score, groups).
- `tests/functional/` — verifies scenes and scripts load correctly.
- `tests/integration/` — instantiates scene trees and checks node structure (collision shapes, detection areas).
- All test files extend `GutTest` and use `setup()`/`teardown()` for scene lifecycle.

**UI**: All UI is created procedurally in `game_manager.gd._setup_ui()` (no separate UI scene). CanvasLayer holds Score label, Hint label, GameOver panel with restart button.

## Conventions

- GDScript, 4-space indent. Files: `snake_case.gd` / `snake_case.tscn`. Node names: `PascalCase`. Constants: `UPPER_SNAKE_CASE`.
- Prefer `queue_free()` over `free()`.
- Cross-entity communication via groups (`add_to_group('player')`) and direct node references through `/root/Main`.
- `.godot/` is editor cache — do not edit or commit. Edit `project.godot` via the Editor UI when possible.
