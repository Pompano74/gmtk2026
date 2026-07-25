extends Node



#===============================================================================================#
#==========================================variable=============================================#
#===============================================================================================#
signal beat_signal
signal beat_win
signal beat_failed
signal player_skipped_beat

var game_progress: int = 0

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

@export var level_select_win: String
@export var level_select_lose: String
var level_is_switching: bool = true
var level_is_restarting: bool = true 
var can_beat: bool = false
var can_transition: bool = false

#ui transition
@onready var ui: Control = $Control
@onready var ui_label: Label = $Control/Label
@onready var label_start: Label = $Control/label_start
@onready var label_reset: Label = $Control/label_reset
@onready var label_lvl_select_start: Label = $Control/label_lvl_select_start


#===============================================================================================#
#==========================================variable=============================================#
#===============================================================================================#

func _ready() -> void:
	
	ui.visible = false
	ui_label.visible = false
	label_start.visible = true
	label_reset.visible = false
	label_lvl_select_start.visible = false
	 #set beat tempo
	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value
	combo_timer.wait_time = beat_inital_value + beat_inital_value / 10

func _process(delta: float) -> void:
	if get_tree().current_scene.name == "level_select":
		coutdown_value = 21
	
	
	if get_tree().get_first_node_in_group("player") !=null:
		ui.global_position = get_tree().get_first_node_in_group("player").global_position
	
	if coutdown_value <= 0:
		#print("failed")
		pass
	if Input.is_anything_pressed() and can_transition == true:
		game_progress += 1
		get_tree().change_scene_to_file(level_select_win)
#beat functions
func _beat_failed():
	beat_streak = 0
	beat_win.emit()

func _beat():
	#win loose condition
	if total_target != 0:
		if current_target == 0:
			level_win()
		if coutdown_value == 0:
			level_failed()
	
		
		#coutdown
		coutdown_value -= 1
		if coutdown_value < 1:
			coutdown_value = 0
		
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

	#emit signal for other scripts
	beat_signal.emit()
func _beat_win():
	combo_timer.start()
	beat_streak += 1
	if beat_streak > 15:
		beat_streak = 15 
		coutdown_value += 2
	beat_win.emit()

func _on_timer_timeout() -> void:
	_beat()
func _on_combo_timer_timeout() -> void:
	beat_streak = 0

#win and loose call (called in _beat() when reach 0 of coutdown or current target
func level_win():
	if level_is_switching == false:
		level_is_switching = true
		timer.stop()
		ui.visible = true
		ui_label.visible = true
		await get_tree().create_timer(0.5).timeout
		can_transition = true


func level_failed():
	if level_is_restarting == false:
		timer.stop()
		level_is_restarting = true
		can_beat = false
		ui.visible = true
		label_reset.visible = true
		#espace transition
		await get_tree().create_timer(beat_inital_value * 4.5).timeout
		coutdown_value = 20
		get_tree().change_scene_to_file(level_select_lose)
		print("FAILED LEVEL")
