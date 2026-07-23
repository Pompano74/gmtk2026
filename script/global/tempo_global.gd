extends Node


signal beat_signal

@export var bpm: float = 120
var beat_timer: float
@onready var sound: FmodEventEmitter2D = $FmodEventEmitter2D




func _ready() -> void:
	beat_timer = 1 / (bpm / 60)

func _process(delta: float) -> void:
	
	if beat_timer <= 0.0:
		_beat()
		sound.play()
		beat_timer = 1 / (bpm / 60)
	else:
		beat_timer = beat_timer - delta
func _beat():
	beat_signal.emit()
	print("beat")
