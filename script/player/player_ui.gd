extends Control

@export var beat_left: Array[Sprite2D]
@export var beat_right: Array[Sprite2D]
@export var beat_middle: Sprite2D

@onready var coutdown: AnimatedSprite2D = $coutdown
@onready var beats: AnimatedSprite2D = $beats
var beat_int_loop: int = 0
@onready var target_count: Label = $target_count
@onready var w: AnimatedSprite2D = $WASD_Keys/w
@onready var a: AnimatedSprite2D = $WASD_Keys/A
@onready var s: AnimatedSprite2D = $WASD_Keys/S
@onready var d: AnimatedSprite2D = $WASD_Keys/D
@onready var arrow_up: AnimatedSprite2D = $ARROWS_Keys/ArrowUp
@onready var arrow_left: AnimatedSprite2D = $ARROWS_Keys/ArrowLeft
@onready var arrow_down: AnimatedSprite2D = $ARROWS_Keys/ArrowDown
@onready var arrow_right: AnimatedSprite2D = $ARROWS_Keys/ArrowRight
@onready var ui_pausing: AnimatedSprite2D = $UI_Pausing
@onready var ui_exist_button: AnimatedSprite2D = $UI_Exist_Button

@onready var are_you_sure_2: Node2D = $AreYouSure2




func _ready() -> void:
	visible = true
	coutdown.frame = 20
	TempoGlobal.beat_signal.connect(on_beat_called)
	target_count.text = str(TempoGlobal.current_target) + "/" + str(TempoGlobal.total_target)
	beats.frame = 0
	ui_exist_button.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_count.text = str(TempoGlobal.current_target) + "/" + str(TempoGlobal.total_target)

func on_beat_called():
	coutdown.frame = TempoGlobal.coutdown_value
	
	if beat_int_loop == 0:
		beat_int_loop = 1
	elif beat_int_loop == 4:
		beat_int_loop = 1
	else:
		beat_int_loop += 1
	
	beats.frame = beat_int_loop

func _input(event: InputEvent) -> void:
		if Input.is_key_pressed(KEY_ESCAPE) and are_you_sure_2.is_visible_in_tree():
			get_tree().quit()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			are_you_sure_2.visible = false
			Engine.time_scale = 1.0
		if Input.is_key_pressed(KEY_ESCAPE):
				ui_exist_button.play("default")
				await ui_exist_button.animation_finished
				Engine.time_scale = 0.1
				are_you_sure_2.visible = true 
				
