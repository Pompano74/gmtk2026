extends Node


signal beat_signal

#tempo
@export var bpm: float = 120.0
@onready var timer: Timer = $Timer

#beat system
var beat_inital_value: float
var beat_timer: float
var beat_streak: int = 0
var streak_multiplayier: int = 1

#coutdown system
var coutdown_value: int = 20

func _ready() -> void:

	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value

func _process(delta: float) -> void:
	if coutdown_value <= 0:
		#print("failed")
		pass

func _beat_failed():
	if coutdown_value != 0:
		coutdown_value -= 1
	else:
		coutdown_value = 0

func _beat():
	#signal for other scripts
	beat_signal.emit()
	
	#beat value update
	print("-----------------------------------")
	print("coutdown:",coutdown_value)
	print("beat_streak:", beat_streak)
	print("streak_multiplayier:", streak_multiplayier)
	print("-----------------------------------")
	if coutdown_value != 0:
		coutdown_value -= 1
	else:
		coutdown_value = 0
	
func _beat_win():
	if coutdown_value != 20:
		coutdown_value += 1
	elif coutdown_value > 20:
		coutdown_value = 20

func _on_timer_timeout() -> void:
	_beat()
