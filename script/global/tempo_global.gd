extends Node


signal beat_signal

@export var bpm: float = 120.0
var beat_timer: float
var beat_inital_value: float
@onready var metronom: FmodEventEmitter2D = $metronom
@onready var music: FmodEventEmitter2D = $music
@onready var music_started: bool = false
@onready var timer: Timer = $Timer




func _ready() -> void:
	_beat()
	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value

func _process(delta: float) -> void:
	pass
	
func _beat():
	print("beat")
	beat_signal.emit()
	metronom.play()
func _on_timer_timeout() -> void:
	_beat()
