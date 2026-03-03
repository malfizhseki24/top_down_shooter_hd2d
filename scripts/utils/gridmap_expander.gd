## GridMap Expander Tool
## Run this script in Godot Editor to duplicate and expand the forest level map.
##
## Usage:
## 1. Open Godot Editor
## 2. Open forest_01.tscn
## 3. Run this script via: Editor → Run Script (or assign to toolbar)
## 4. The script will expand the map by the specified factor

@tool
extends EditorScript

## How many times to duplicate the map (2 = 2x larger, 3 = 3x larger, etc.)
const EXPAND_FACTOR := 3

## The size of the original pattern (detected automatically)
var pattern_width := 0
var pattern_height := 0

func _run() -> void:
	var scene := get_scene()
	if scene == null:
		push_error("No scene open!")
		return

	var ground_map: GridMap = scene.find_child("GridMap_Ground", false)
	var props_map: GridMap = scene.find_child("GridMap_Props", false)

	if ground_map == null or props_map == null:
		push_error("GridMap_Ground or GridMap_Props not found!")
		return

	print("=== GridMap Expander ===")
	print("Expanding map by factor: %d" % EXPAND_FACTOR)

	# Expand ground
	_expand_gridmap(ground_map)

	# Expand props
	_expand_gridmap(props_map)

	print("Done! Save the scene to apply changes.")


func _expand_gridmap(gridmap: GridMap) -> void:
	print("\nProcessing: %s" % gridmap.name)

	# Get all used cells
	var cells := gridmap.get_used_cells()
	if cells.is_empty():
		print("  No cells found!")
		return

	# Find the bounds of current map
	var min_x := 999999
	var max_x := -999999
	var min_z := 999999
	var max_z := -999999

	for cell in cells:
		min_x = mini(min_x, cell.x)
		max_x = maxi(max_x, cell.x)
		min_z = mini(min_z, cell.z)
		max_z = maxi(max_z, cell.z)

	var width := max_x - min_x + 1
	var height := max_z - min_z + 1

	print("  Current bounds: X[%d to %d], Z[%d to %d]" % [min_x, max_x, min_z, max_z])
	print("  Current size: %d x %d" % [width, height])
	print("  Cells: %d" % cells.size())

	# Store original cells data
	var cell_data := []
	for cell in cells:
		var item := gridmap.get_cell_item(cell)
		var orientation := gridmap.get_cell_item_orientation(cell)
		cell_data.append({
			"x": cell.x,
			"z": cell.z,
			"item": item,
			"orientation": orientation
		})

	# Duplicate the pattern
	var new_cells := 0
	for duplicate in range(1, EXPAND_FACTOR):
		var offset_x := width * duplicate
		var offset_z := height * duplicate

		# Duplicate in X direction
		for data in cell_data:
			var new_pos := Vector3i(data.x + offset_x, 0, data.z)
			if gridmap.get_cell_item(new_pos) == -1:
				gridmap.set_cell_item(new_pos, data.item, data.orientation)
				new_cells += 1

		# Duplicate in Z direction
		for data in cell_data:
			var new_pos := Vector3i(data.x, 0, data.z + offset_z)
			if gridmap.get_cell_item(new_pos) == -1:
				gridmap.set_cell_item(new_pos, data.item, data.orientation)
				new_cells += 1

		# Duplicate diagonally
		for data in cell_data:
			var new_pos := Vector3i(data.x + offset_x, 0, data.z + offset_z)
			if gridmap.get_cell_item(new_pos) == -1:
				gridmap.set_cell_item(new_pos, data.item, data.orientation)
				new_cells += 1

	print("  Added %d new cells" % new_cells)

	# Report new bounds
	var new_cells_list := gridmap.get_used_cells()
	var new_min_x := 999999
	var new_max_x := -999999
	var new_min_z := 999999
	var new_max_z := -999999
	for cell in new_cells_list:
		new_min_x = mini(new_min_x, cell.x)
		new_max_x = maxi(new_max_x, cell.x)
		new_min_z = mini(new_min_z, cell.z)
		new_max_z = maxi(new_max_z, cell.z)

	print("  New bounds: X[%d to %d], Z[%d to %d]" % [new_min_x, new_max_x, new_min_z, new_max_z])
	print("  New total cells: %d" % new_cells_list.size())
