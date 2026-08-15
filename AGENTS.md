# Repository Guidelines

## Project Overview

**Coin Catcher** is a Godot 4.7 2D arcade game. Move a blue square with WASD / Arrow keys to collect gold coins while avoiding red enemies. Press **R** or click **Restart** to play again.

- **Viewport:** 800 x 600 px
- **Renderer:** GL Compatibility
- **Main scene:** scenes/main.tscn

---

## Project Structure

```
project.godot          # Project settings (edit via Godot Editor UI)
scenes/
  main.tscn            # Root scene - loads GameManager
  player.tscn          # Player entity (CharacterBody2D, 32x32)
  coin.tscn            # Collectible coin (Area2D, 24x24 circle)
  enemy.tscn           # Enemy entity (CharacterBody2D, 36x36)
scripts/
  game_manager.gd      # Core game loop, UI, spawning, scoring
  player.gd            # Player movement and collision
  coin.gd              # Coin collection logic
  enemy.gd             # Enemy chase AI and screen wrapping
.godot/                # Godot editor cache - do not commit
```

---

## Build & Run

1. Open project.godot in **Godot 4.7+**.
2. Press **F5** to run from the main scene.
3. Package via **Project -> Export**.

---

## Coding Conventions

- **Language:** GDScript (see [Godot 4 style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)).
- **Indentation:** 4 spaces (no tabs).
- **Naming:**
  - Script/scene files: snake_case.gd / snake_case.tscn
  - Node names: PascalCase
  - Constants: UPPER_SNAKE_CASE
- **Variables:** Declare with ar at class body top; use @export for Inspector-editable properties.
- **Groups:** Use dd_to_group() / is_in_group() for cross-entity communication (e.g., the player group).
- **Cleanup:** Use queue_free() instead of ree().

---

## Adding New Content

- **New entity:** Create a .tscn in scenes/ and matching .gd in scripts/. Register it in game_manager.gd.
- **New scenes:** Reference via 
es://scenes/... paths. Keep names lowercase with underscores.
- **New constants:** Add to game_manager.gd near the top const block.

---

## Editor Notes

- .godot/ is auto-generated — never edit or commit it.
- Edit project.godot via the Editor UI (**Project -> Project Settings**) when possible.

---

## Testing

No automated tests. Verify changes by playtesting in the Godot Editor.
