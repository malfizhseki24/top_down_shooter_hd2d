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

## Button to trigger painting (Inspector button)
@export var paint_map: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_paint_all_maps()

## Cache untuk item name -> index lookup
var _item_cache: Dictionary = {}
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


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

	for line in lines:
		if line.strip_edges() == "":
			continue

		var x := 0
		for char in line:
			if char != " " and char != "\t":
				_paint_cell(gridmap, legend, variants, x, z, char)
			x += 1
		z += 1

	print("GridMapPainter: Painted %s map (%d rows)" % [map_file.get_file(), z])


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
