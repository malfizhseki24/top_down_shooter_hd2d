## GridMapPainter.gd
## @tool script untuk paint GridMap dari ASCII map files.
## Memungkinkan AI-augmented level design dengan text-based map editing.
## Support random variants untuk props diversity.
##
## Usage:
## 1. Attach script ke Node3D di scene
## 2. Configure map_file path dan legend mapping di Inspector
## 3. Klik "Paint Map" button di Inspector
## 4. GridMap akan di-populate sesuai ASCII map

@tool
extends Node3D
class_name GridMapPainter

## Path ke ASCII map file (relative to res://)
@export_file("*.txt") var ground_map_file: String = ""
@export_file("*.txt") var props_map_file: String = ""

## GridMap nodes untuk di-populate
@export var ground_gridmap: GridMap
@export var props_gridmap: GridMap

## MeshLibrary untuk lookup item indices
@export var mesh_library: MeshLibrary

## ASCII Legend Configuration
## Format: ASCII char -> MeshLibrary item name
@export var ground_legend: Dictionary = {
	"G": "GroundGrass",
	"S": "GroundPathOpen",
	"D": "GroundPathStraight",
	"P": "PathStone",
}
@export var props_legend: Dictionary = {
	"T": "TreeTallDark",
	"O": "TreeOakDark",
	"R": "RockLargeA",
	"r": "RockSmallA",
	"B": "BushSmallDarkA",
	"F": "FenceLog",
}

## Random Variants Configuration
## Format: variant_group_name -> Array of mesh names
## Gunakan "@group_name" di props_legend untuk reference variant group
@export var prop_variants: Dictionary = {
	"trees": ["TreeTallDark", "TreeOakDark", "TreeDefaultDark", "TreeDetailedDark"],
	"rocks_large": ["RockLargeA", "RockLargeB", "RockLargeC", "RockLargeD"],
	"rocks_small": ["RockSmallA", "RockSmallB", "RockSmallC", "RockSmallD"],
	"bushes": ["BushSmallDarkA", "BushSmallDarkB", "BushSmallDarkC"],
}

## Seed untuk random (set -1 untuk random setiap kali)
@export var random_seed: int = -1

## Offset posisi map (center point di world space)
@export var map_offset: Vector3i = Vector3i.ZERO

## Clear existing cells before painting
@export var clear_before_paint: bool = true

## Generate invisible collision walls at map edges
@export var generate_boundary_walls: bool = true

## Wall height for boundary collision
@export var boundary_wall_height: float = 3.0

## Button to trigger painting (Inspector button)
@export var paint_map: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_paint_all_maps()

## Cache untuk item name -> index lookup
var _item_cache: Dictionary = {}
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _map_columns: int = 0
var _map_rows: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		_build_item_cache()


func _build_item_cache() -> void:
	"""Build cache mapping item names to indices."""
	_item_cache.clear()
	if mesh_library == null:
		push_error("GridMapPainter: MeshLibrary not assigned!")
		return

	var item_list := mesh_library.get_item_list()
	for item_id in item_list:
		var item_name := mesh_library.get_item_name(item_id)
		_item_cache[item_name] = item_id

	print("GridMapPainter: Cached %d mesh items" % _item_cache.size())


func _paint_all_maps() -> void:
	"""Paint both ground and props maps."""
	print("GridMapPainter: Starting map paint...")

	_build_item_cache()
	_map_columns = 0
	_map_rows = 0

	# Initialize RNG
	if random_seed >= 0:
		_rng.seed = random_seed
	else:
		_rng.randomize()

	if ground_map_file != "" and ground_gridmap != null:
		_paint_map(ground_map_file, ground_gridmap, ground_legend, {}, 0)
	else:
		push_warning("GridMapPainter: Ground map or GridMap not configured")

	if props_map_file != "" and props_gridmap != null:
		_paint_map(props_map_file, props_gridmap, props_legend, prop_variants, 1)
	else:
		push_warning("GridMapPainter: Props map or GridMap not configured")

	if generate_boundary_walls:
		_generate_boundary_walls()

	print("GridMapPainter: Map painting complete!")


func _paint_map(map_file: String, gridmap: GridMap, legend: Dictionary, variants: Dictionary, layer: int) -> void:
	"""Parse ASCII map file and paint to GridMap."""
	var full_path := "res://" + map_file
	var file := FileAccess.open(full_path, FileAccess.READ)

	if file == null:
		push_error("GridMapPainter: Cannot open file: %s" % full_path)
		return

	if clear_before_paint:
		gridmap.clear()

	var content := file.get_as_text()
	file.close()

	var lines := content.split("\n")
	var z := 0
	var max_x := 0

	for line in lines:
		if line.strip_edges() == "":
			continue

		var x := 0
		for char in line:
			if char != " " and char != "\t":
				_paint_cell(gridmap, legend, variants, x, z, char)
			x += 1
		if x > max_x:
			max_x = x
		z += 1

	# Track map dimensions for boundary wall generation
	_map_columns = maxi(_map_columns, max_x)
	_map_rows = maxi(_map_rows, z)

	print("GridMapPainter: Painted %s map (%d cols x %d rows)" % [map_file.get_file(), max_x, z])


func _paint_cell(gridmap: GridMap, legend: Dictionary, variants: Dictionary, x: int, z: int, char: String) -> void:
	"""Paint single cell based on ASCII character with random variant support."""
	if not legend.has(char):
		return  # Skip unknown characters (like '.' for empty)

	var item_name: String = legend[char]

	# Check if this references a variant group (starts with @)
	if item_name.begins_with("@"):
		var group_name := item_name.substr(1)
		if variants.has(group_name):
			var options: Array = variants[group_name]
			item_name = options[_rng.randi() % options.size()]
		else:
			push_warning("GridMapPainter: Variant group not found: %s" % group_name)
			return

	if not _item_cache.has(item_name):
		push_warning("GridMapPainter: Item not found: %s (char: %s)" % [item_name, char])
		return

	var item_id: int = _item_cache[item_name]
	var cell_pos := Vector3i(x + map_offset.x, map_offset.y, z + map_offset.z)

	gridmap.set_cell_item(cell_pos, item_id)


func _generate_boundary_walls() -> void:
	"""Generate invisible collision walls around the map edges."""
	# Remove old walls if they exist
	var old_bounds := get_parent().get_node_or_null("MapBounds")
	if old_bounds:
		old_bounds.queue_free()

	# Calculate world-space bounds from map dimensions + offset
	var x_min := float(map_offset.x)
	var x_max := float(map_offset.x + _map_columns)
	var z_min := float(map_offset.z)
	var z_max := float(map_offset.z + _map_rows)
	var width := x_max - x_min
	var depth := z_max - z_min
	var center_x := (x_min + x_max) / 2.0
	var center_z := (z_min + z_max) / 2.0
	var half_h := boundary_wall_height / 2.0
	var thickness := 0.5

	var bounds_node := Node3D.new()
	bounds_node.name = "MapBounds"

	# Wall definitions: [position, box_size]
	var walls := {
		"WallNorth": [Vector3(center_x, half_h, z_min - thickness / 2.0), Vector3(width + thickness, boundary_wall_height, thickness)],
		"WallSouth": [Vector3(center_x, half_h, z_max + thickness / 2.0), Vector3(width + thickness, boundary_wall_height, thickness)],
		"WallWest":  [Vector3(x_min - thickness / 2.0, half_h, center_z), Vector3(thickness, boundary_wall_height, depth + thickness)],
		"WallEast":  [Vector3(x_max + thickness / 2.0, half_h, center_z), Vector3(thickness, boundary_wall_height, depth + thickness)],
	}

	for wall_name in walls:
		var pos: Vector3 = walls[wall_name][0]
		var box_size: Vector3 = walls[wall_name][1]

		var body := StaticBody3D.new()
		body.name = wall_name
		body.position = pos
		body.collision_layer = 1
		body.collision_mask = 0

		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = box_size
		shape.shape = box
		body.add_child(shape)

		bounds_node.add_child(body)

	get_parent().add_child(bounds_node)
	bounds_node.owner = get_tree().edited_scene_root

	# Set owner for all children so they save with the scene
	for wall in bounds_node.get_children():
		wall.owner = get_tree().edited_scene_root
		for child in wall.get_children():
			child.owner = get_tree().edited_scene_root

	print("GridMapPainter: Generated boundary walls (%.0f x %.0f, from [%.0f,%.0f] to [%.0f,%.0f])" % [width, depth, x_min, z_min, x_max, z_max])


## Get legend documentation as string
func get_legend_docs() -> String:
	var docs := "=== ASCII MAP LEGEND ===\n\n"
	docs += "GROUND LAYER:\n"
	for char in ground_legend:
		docs += "  %s = %s\n" % [char, ground_legend[char]]
	docs += "\nPROPS LAYER:\n"
	for char in props_legend:
		docs += "  %s = %s\n" % [char, props_legend[char]]
	docs += "\nVARIANT GROUPS (use @group_name in legend):\n"
	for group in prop_variants:
		docs += "  @%s = %s\n" % [group, prop_variants[group]]
	docs += "\n  . = empty (no prop)\n"
	return docs
