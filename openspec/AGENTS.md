# OpenSpec for Game Development

Instructions for AI coding assistants using OpenSpec for Godot 4.6 game development.

## TL;DR Quick Checklist

- Search existing work: `openspec spec list --long`, `openspec list`
- Decide scope: new gameplay feature vs modify existing system
- Pick a unique `change-id`: kebab-case, verb-led (`add-`, `update-`, `remove-`, `refactor-`)
- Scaffold: `proposal.md`, `tasks.md`, `design.md` (for complex features), and delta specs
- Write deltas: use `## ADDED|MODIFIED|REMOVED Requirements`; include scenarios with GIVEN/WHEN/THEN
- Validate: `openspec validate [change-id] --strict --no-interactive`
- Request approval: Do not start implementation until proposal is approved

## Game Development Workflow

### Stage 1: Creating Feature Proposals

Create a proposal when you need to:
- Add new gameplay mechanics or systems
- Add new enemies, weapons, or items
- Change core game loop or balance
- Add new UI/UX features
- Modify existing system behavior
- Add new levels or content

**Skip proposal for:**
- Bug fixes (restore intended behavior)
- Typos, formatting, comments
- Asset imports without code changes
- Minor parameter tuning
- Non-breaking configuration changes

**Workflow:**
1. Review `openspec/project.md` for game context and conventions
2. Check `openspec list` and `openspec list --specs` for existing systems
3. Choose a unique verb-led `change-id` (e.g., `add-player-dash`, `update-enemy-ai`)
4. Create directory: `openspec/changes/<change-id>/`
5. Write `proposal.md` with gameplay impact and technical considerations
6. Create spec deltas in `specs/<system>/spec.md`
7. Add `design.md` for complex features (new mechanics, AI, etc.)
8. Create `tasks.md` with implementation checklist
9. Validate: `openspec validate <change-id> --strict --no-interactive`

### Stage 2: Implementing Features

Track these as TODOs and complete one by one:

1. **Read proposal.md** - Understand what's being built and why
2. **Read design.md** (if exists) - Review technical and game design decisions
3. **Read tasks.md** - Get implementation checklist
4. **Setup** - Create scenes, scripts, resources structure
5. **Core Implementation** - Build base functionality
6. **Polish & Feel** - Add juice (particles, audio, screen shake)
7. **Integration** - Connect to existing systems
8. **Testing & Balance** - Playtest and tune
9. **Cleanup** - Document and remove debug code

### Stage 3: Archiving Features

After feature is complete and tested:
- Move `changes/<name>/` to `changes/archive/YYYY-MM-DD-<name>/`
- Update `specs/` if system behavior changed
- Run `openspec archive <change-id> --yes`
- Validate: `openspec validate --strict --no-interactive`

## Godot-Specific Guidelines

### Scene Structure
```
res://scenes/
├── player/
│   ├── player.tscn
│   └── player_weapon.tscn
├── enemies/
│   ├── enemy_base.tscn
│   └── enemy_boss.tscn
├── ui/
│   ├── hud.tscn
│   └── menu_main.tscn
└── levels/
    └── level_01.tscn
```

### Script Organization
```
res://scripts/
├── autoload/        # Global singletons
│   ├── game.gd
│   ├── events.gd
│   └── audio_manager.gd
├── components/      # Reusable behaviors
│   ├── health_component.gd
│   ├── hitbox_component.gd
│   └── movement_component.gd
└── utils/           # Utility functions
    └── math_utils.gd
```

### Code Patterns

**Composition over Inheritance:**
```gdscript
# Instead of inheriting, compose with components
class_name Enemy

@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent
@onready var ai: AIComponent = $AIComponent
```

**Signal-based Communication:**
```gdscript
# Define signals
signal health_changed(new_value: int)
signal died()

# Emit signals
func take_damage(amount: int) -> void:
    current_health -= amount
    health_changed.emit(current_health)
    if current_health <= 0:
        died.emit()
```

**State Machine Pattern:**
```gdscript
enum State { IDLE, CHASE, ATTACK, DEAD }
var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
    match current_state:
        State.IDLE: _handle_idle(delta)
        State.CHASE: _handle_chase(delta)
        State.ATTACK: _handle_attack(delta)
        State.DEAD: _handle_dead(delta)
```

### Performance Tips
- Use object pooling for bullets, particles, enemies
- Avoid `_process()` for rare events - use timers
- Use `@export` for designer-tunable values
- Profile before optimizing

## Directory Structure

```
openspec/
├── project.md              # Game context, conventions, systems
├── specs/                  # Current truth - implemented systems
│   └── [system]/           # e.g., player-movement, enemy-ai
│       ├── spec.md         # Requirements and scenarios
│       └── design.md       # Technical and game design
├── changes/                # Proposals - pending features
│   ├── [feature-name]/
│   │   ├── proposal.md     # Why, gameplay impact, scope
│   │   ├── tasks.md        # Implementation checklist
│   │   ├── design.md       # GDD + technical design
│   │   └── specs/          # Delta changes
│   │       └── [system]/
│   │           └── spec.md
│   └── archive/            # Completed features
└── schemas/
    └── game-dev/           # Game development templates
        └── templates/
            ├── project.md
            ├── proposal.md
            ├── spec.md
            ├── design.md
            └── tasks.md
```

## Spec Format for Games

### Requirement with Game Scenarios

```markdown
## ADDED Requirements

### Requirement: Player Dash
The player SHALL be able to dash quickly in the movement direction.

#### Scenario: Successful dash
- **GIVEN** player is on ground
- **WHEN** player presses dash button
- **THEN** player moves quickly in facing direction
- **AND** player is invulnerable during dash

#### Scenario: Dash cooldown
- **GIVEN** player has just dashed
- **WHEN** player presses dash button again
- **THEN** nothing happens until cooldown expires

#### Scenario: Dash resets on ground
- **GIVEN** player used dash in air
- **WHEN** player lands on ground
- **THEN** dash becomes available immediately
```

## CLI Commands

```bash
# Essential
openspec list                  # List active feature changes
openspec list --specs          # List game systems
openspec show [item]           # View change or spec details
openspec validate [item]       # Validate changes
openspec archive <change-id>   # Archive completed feature

# Debug
openspec show [change] --json --deltas-only
openspec validate [change] --strict --no-interactive
```

## Decision Tree

```
New feature request?
├─ Bug fix? → Fix directly
├─ Typo/minor tweak? → Fix directly
├─ New mechanic? → Create proposal
├─ New enemy/weapon? → Create proposal
├─ Balance change? → Create proposal (if significant)
├─ UI/UX change? → Create proposal
└─ Unclear? → Ask clarifying questions
```

## Common Game Systems

| System | Description | Typical Files |
|--------|-------------|---------------|
| player-movement | Locomotion, jumping, dashing | `player.gd`, `movement_component.gd` |
| player-combat | Attacks, combos, weapons | `weapon.gd`, `hitbox_component.gd` |
| health-system | HP, damage, death | `health_component.gd`, `hud.gd` |
| enemy-ai | Behavior, states, detection | `enemy_ai.gd`, `state_machine.gd` |
| enemy-spawning | Waves, triggers, pools | `spawner.gd`, `object_pool.gd` |
| inventory | Items, equipment, slots | `inventory.gd`, `item_resource.tres` |
| save-system | Progress, settings | `save_manager.gd` |
| audio | Music, SFX, ambience | `audio_manager.gd` |
| ui | HUD, menus, notifications | `hud.gd`, `menu.gd` |

## Best Practices

### Game Feel First
- Always playtest for "feel"
- Tune parameters with `@export`
- Add juice: particles, screenshake, audio
- Watch for frame drops

### Iterative Development
- Start simple, add complexity later
- Prototype before polishing
- Test early and often
- Balance last

### Clear Specs
- Use GIVEN/WHEN/THEN for scenarios
- Reference specific files: `player.gd:42`
- Include balance parameters
- Describe visual/audio feedback

### Component Naming
- Use descriptive names: `HealthComponent` not `Comp1`
- Group by function: `PlayerHealth`, `EnemyHealth`
- Keep components focused

## Error Recovery

### Merge Conflicts in Specs
1. Check `openspec list` for active changes
2. Coordinate with other changes affecting same system
3. Consider combining proposals

### Validation Failures
1. Run `--strict` mode
2. Check scenario format (GIVEN/WHEN/THEN)
3. Verify `#### Scenario:` headers (4 hashtags)
4. Check for required sections

### Implementation Blocked
1. Review design.md for alternatives
2. Check for missing dependencies
3. Break down into smaller tasks
4. Ask for clarification

## Quick Reference

| File | Purpose |
|------|---------|
| `proposal.md` | Why + gameplay impact + scope |
| `design.md` | GDD + technical design |
| `tasks.md` | Implementation steps |
| `spec.md` | Requirements + scenarios |

| Stage | Location |
|-------|----------|
| Proposed | `changes/<name>/` |
| Implemented | `specs/<system>/` |
| Completed | `changes/archive/` |

Remember: Specs describe game behavior. Changes propose new gameplay. Keep playtesting!
