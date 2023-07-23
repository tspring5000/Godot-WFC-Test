extends Node2D
const size : int = 16 # Max for this method seems to be 23
const default : Array = [0,1,2,3,4]
const rules := {
	0: [0,1],
	1: [0,1,2],
	2: [1,2,3],
	3: [2,3,4],
	4: [3,4],
}
@onready var rng := RandomNumberGenerator.new()
var cells := {}

func _ready():
	rng.randomize()
	init_cells()
	run_wfc()

# WFC
func init_cells() -> void:
	for x in range(size):
		for y in range(size):
			cells[Vector2(x, y)] = default

func run_wfc():
	var done = is_finished()
	if done:
		draw_cells()
	else:
		var next = get_next_cell()
		collapse_cell(next)
		propagate(next)

func is_finished() -> bool:
	for key in cells:
		if cells[key].size() > 1:
			return false
	return true

func get_next_cell() -> Vector2:
	var smallest_size := default.size() + 1
	var smallest_key := Vector2()
	for key in cells:
		var cell_size = cells[key].size()
		if cell_size > 1 and cell_size < smallest_size:
			smallest_size = cell_size
			smallest_key = key
	return smallest_key

func collapse_cell(key: Vector2) -> void:
	cells[key] = [
		cells[key][randi() % cells[key].size()]
	]

func propagate(key: Vector2) -> void:
	var valid = rules[cells[key][0]]
	var neighbours = [
		key + Vector2(1, 0), key + Vector2(-1, 0),
		key + Vector2(0, 1), key + Vector2(0, -1),
		key + Vector2(1, 1), key + Vector2(-1, -1),
		key + Vector2(-1, 1), key + Vector2(1, -1),
	]
	for n in neighbours:
		if cells.has(n):
			var new_options = cells[n].duplicate(false)
			for option in cells[n]:
				if option not in valid:
					new_options.erase(option)
			
			# Defaults to 0 if no other option
			if new_options.size() == 0:
				new_options = [0]
			cells[n] = new_options
	run_wfc()

# DRAWING
func draw_cells() -> void:
	var tileObj = load("res://tile.tscn")
	for key in cells:
		var inst = tileObj.instantiate()
		inst.position = key * 8
		inst.frame = cells[key][0]
		add_child(inst)
