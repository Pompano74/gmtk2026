extends Node2D
@onready var fmod_event_emitter_2d: FmodEventEmitter2D = $FmodEventEmitter2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	TempoGlobal.beat_signal.connect(_on_beat)
	



func _process(delta: float) -> void:
	pass

func _on_beat():
	#fmod_event_emitter_2d.play()
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("TargetTile")):
		queue_free()
