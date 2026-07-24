extends Node2D
class_name BaseEnemy

@export var tilemap: LevelTileMap
@onready var coord_tracker: GridCoordTracker = $GridCoordTracker

@export var health : int = 1:
	set(new_health):
		health = new_health
		if health <= 0:
			on_death()

var current_path: Array[Vector2i]

var timer : Timer

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	timer = TempoGlobal.timer
	coord_tracker.is_blocking_pathfinding = true

func on_beat_called() -> void:
	pass

func on_death() -> void:
	if is_in_group("target_objectif"):
		var target_array_index = TempoGlobal.target_array.find(self)
		if target_array_index != -1:
			TempoGlobal.target_array.pop_at(target_array_index)
	print(TempoGlobal.target_array.size(), " targets left!")
