extends Node

var banks:= Array()
@export var music: FmodEventEmitter2D = null
var music_playing: bool = false

func _ready() -> void:
	#reset value
	TempoGlobal.level_is_restarting = false
	
	music.play()
	music_playing = true
	await get_tree().create_timer(TempoGlobal.beat_inital_value * 6).timeout
	music.set_parameter("bootup", 1)
	
	print(FmodServer.get_system_dsp_buffer_length())
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	music.set_parameter("combo chain", TempoGlobal.beat_streak)
	if TempoGlobal.level_is_restarting:
		music.set_parameter("player condition", "dead")
	if TempoGlobal.level_is_switching:
		music.set_parameter("player condition", "success")
		music.set_parameter("next level", "on")
