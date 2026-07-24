extends Node



#===============================================================================================#
#==========================================variable=============================================#
#===============================================================================================#
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
var coutdown_is_paused: bool = false
var coutdown_value: int = 20

#game objective
var total_target: int = 0
var current_target: int = 0

const level_select = preload("uid://c0y1in3yfpic1")

#===============================================================================================#
#==========================================variable=============================================#
#===============================================================================================#

func _ready() -> void:
	 #set beat tempo
	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value
	combo_timer.wait_time = beat_inital_value + beat_inital_value / 10

func _process(delta: float) -> void:
	if coutdown_value <= 0:
		#print("failed")
		pass

#beat functions
func _beat_failed():
	
	beat_streak = 0
	
	coutdown_value -= 1
	if coutdown_value < 1:
		coutdown_value = 0
func _beat():
	#win loose condition
	#if current_target == 0:
		#level_win()
	#if coutdown_value == 0:
		#level_failed()
	
	#beet incremantion of 1-4
	if beat_nbr < 4:
		beat_nbr += 1
	else:
		beat_nbr = 1
	
	#beat_streak
	if beat_streak >= 15:
		infinite_mode = true
	else:
		infinite_mode = false
	
	#coutdown
	coutdown_value -= 1
	if coutdown_value < 1:
		coutdown_value = 0
		
	#emit signal for other scripts
	beat_signal.emit()
func _beat_win():
	combo_timer.start()
	beat_streak += 1
	if beat_streak > 15:
		beat_streak = 15 
		coutdown_value += 2
func _on_timer_timeout() -> void:
	if coutdown_is_paused == false:
		_beat()
func _on_combo_timer_timeout() -> void:
	beat_streak = 0

#win and loose call (called in _beat() when reach 0 of coutdown or current target
#func level_win():
	#await get_tree().create_timer(beat_inital_value * 4).timeout
	#get_tree().change_scene_to_packed(level_select)
#func level_failed():
	#print("FAILED LEVEL")
