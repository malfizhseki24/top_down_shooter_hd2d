# Design: add-object-pooling

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     ObjectPool (Autoload)                    │
├─────────────────────────────────────────────────────────────┤
│  _pools: Dictionary[String, Pool]                           │
│                                                             │
│  + acquire(type: String) -> Node                            │
│  + release(type: String, node: Node) -> void                │
│  + prewarm(type: String, scene: PackedScene, count: int)    │
└─────────────────────────────────────────────────────────────┘
          ▲                                    │
          │ acquire("Arrow")                   │ release("Arrow", arrow)
          │                                    ▼
┌─────────────────────┐              ┌─────────────────────┐
│  PlayerController   │              │       Arrow         │
├─────────────────────┤              ├─────────────────────┤
│  _shoot()           │──────────────│  reset()            │
│    pool.acquire()   │              │  _lifetime_timer    │
└─────────────────────┘              │  set_direction()    │
                                     └─────────────────────┘
```

## Pool Data Structure

```gdscript
class_name Pool extends RefCounted
var _scene: PackedScene
var _available: Array[Node] = []
var _in_use: Array[Node] = []

func acquire() -> Node:
    if _available.is_empty():
        _expand_pool()
    var node := _available.pop_back()
    _in_use.append(node)
    return node

func release(node: Node) -> void:
    var idx := _in_use.find(node)
    if idx >= 0:
        _in_use.remove_at(idx)
        node.reset()  # Assumes pooled objects have reset()
        _available.append(node)
```

## Integration Points

### 1. ObjectPool.gd (Autoload)
- Registered in Project Settings as singleton
- Initialized with arrow pool on `_ready()`
- Provides global access via `ObjectPool.acquire("Arrow")`

### 2. Arrow.gd Modifications
- Add `reset()` method to clear state
- Change despawn from `queue_free()` to `ObjectPool.release("Arrow", self)`
- Timer reset handled in `reset()`

### 3. PlayerController.gd Modifications
- Replace `arrow_scene.instantiate()` with `ObjectPool.acquire("Arrow")`
- Remove direct `arrow_scene` dependency (pool handles it)

## Configuration

```gdscript
# object_pool.gd
@export var initial_arrow_pool_size: int = 20
@export var max_pool_size: int = 100
@export var auto_expand: bool = true
```

## Performance Considerations

| Scenario | Current (instantiate) | Pooled |
|----------|----------------------|--------|
| 50 arrows spawned | ~50 allocations | 0 allocations |
| Rapid fire (10/sec) | 10 allocs/sec | 0 allocs/sec |
| Memory fragmentation | High | Low |

## Trade-offs

**Chosen: Simple Dictionary-based Pool**
- Pros: Easy to implement, type-safe, minimal overhead
- Cons: Not generic for all objects (requires reset() interface)

**Alternatives Considered:**
1. **Node-based Pool (add_child/remove_child)**
   - Rejected: More overhead, requires scene tree manipulation

2. **Fully Generic Pool (no reset interface)**
   - Rejected: Would require reflection or duck typing, less type-safe

## Error Handling

1. **Pool Exhaustion**
   - If `auto_expand = true`: Create new instance with warning
   - If `auto_expand = false`: Return null, log error

2. **Release Non-Pooled Object**
   - Log warning, ignore object

3. **Double Release**
   - Log warning, ignore (check if already in available)
