extends Node
# level manager concept and _load_level function from ChatGPT with prompt: 
# "how can I manage navigating between levels/scenes in Godot"

const levels = [
	"res://scenes/game.tscn",
	"res://scenes/level_2.tscn"
]

var current_level = 0

func start_game():
	current_level = 0
	_load_level()

func next_level():
	current_level += 1
	if current_level >= levels.size():
		print('out of levels')
		current_level = 0
	else:
		call_deferred("_load_level")

func _load_level():
	get_tree().change_scene_to_file(levels[current_level])
