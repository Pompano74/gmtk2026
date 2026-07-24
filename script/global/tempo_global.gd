extends Node


signal beat_signal

#tempo
@export var bpm: float = 120.0
@onready var timer: Timer = $Timer
@onready var combo_timer: Timer = $combo_timer

#beat system
var beat_inital_value: float
var beat_timer: float
var beat_streak: int = 0
var streak_addition: int = 1
var infinite_mode: bool = false
var beat_nbr: int = 0

#block le spam in buffer zone
var pressed_late: bool = false

#coutdown system
var coutdown_value: int = 20

func _ready() -> void:

	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value
	combo_timer.wait_time = beat_inital_value + beat_inital_value / 10

func _process(delta: float) -> void:
	if coutdown_value <= 0:
		#print("failed")
		pass

func _beat_failed():
	print("missed")
	beat_streak = 0
	
	coutdown_value -= 1
	if coutdown_value < 1:
		coutdown_value = 0

func _beat():
	#beet incremantion of 1-4
	if beat_nbr < 4:
		beat_nbr += 1
	else:
		beat_nbr = 1
	print("beat_nbr:", beat_nbr)
	
	#signal for other scripts
	beat_signal.emit()
	
	if beat_streak >= 15:
		infinite_mode = true
	else:
		infinite_mode = false
		
	coutdown_value -= 2
	if coutdown_value < 1:
		coutdown_value = 0
	
	print("coutdown:", coutdown_value)
	
func _beat_win():
	print("win")
	
	combo_timer.start()
	beat_streak += 1
	if beat_streak > 15:
		beat_streak = 15 
		coutdown_value += 2
	
	if beat_nbr == 4 or beat_nbr == 3 and beat_streak >= 7 and beat_streak < 15:
		coutdown_value += 2
	else:
		coutdown_value += 1
	if coutdown_value > 20:
		coutdown_value = 20
	
	

func _on_timer_timeout() -> void:
	_beat()

func _on_combo_timer_timeout() -> void:
	beat_streak = 0
