extends Node


signal beat_signal

@export var bpm: float = 120.0
var beat_inital_value: float
var beat_timer: float
@onready var timer: Timer = $Timer
var beat_streak: int = 0


func _ready() -> void:

	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value

func _process(delta: float) -> void:
	pass
	
func _beat():
	beat_signal.emit()
	
func _on_timer_timeout() -> void:
	print("BEAT")
	_beat()
