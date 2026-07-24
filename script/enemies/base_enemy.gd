extends Node2D
class_name BaseEnemy

@export var tilemap: LevelTileMap
@onready var coord_tracker: GridCoordTracker = $GridCoordTracker
var current_path: Array[Vector2i]

var timer : Timer

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	timer = TempoGlobal.timer

func on_beat_called() -> void:
	pass
