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

#block le spam in buffer zone
var pressed_late: bool = false

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
	print("missed")
	coutdown_value -= 1
	if coutdown_value < 1:
		coutdown_value = 0

func _beat():
	print("normal")
	#signal for other scripts
	beat_signal.emit()
	
	#beat value update
	print("--------------global-------------")
	print("coutdown:",coutdown_value)
	print("beat_streak:", beat_streak)
	print("streak_multiplayier:", streak_multiplayier)
	print("-----------------------------------")
	
	coutdown_value -= 1
	if coutdown_value < 1:
		coutdown_value = 0
	
func _beat_win():
	
	print("win")
	coutdown_value += 1
	if coutdown_value > 20:
		coutdown_value = 20

func _on_timer_timeout() -> void:
	_beat()
