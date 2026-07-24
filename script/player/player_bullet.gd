extends Node2D

const tile_size: Vector2 = Vector2(32, 32)
var move_time: float = TempoGlobal.beat_inital_value
var dir: Vector2 = Vector2(0, 1)
var life_span: int = 4
var on_twos: bool = true

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	if on_twos == true:
		_move(dir)
		on_twos = false
	elif on_twos == false:
		on_twos = true
	
func _move(bullet_dir: Vector2):
	if life_span == 0:
		queue_free()
	else:
		global_position += bullet_dir * tile_size
		life_span = life_span - 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("remove health")
	if body.is_in_group("destruct_wall"):
		body._remove_health()
		queue_free() # Replace with function body.


#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if (area.is_in_group("TargetTile")):
		#var areaParent = area.get_parent()
		#areaParent.queue_free()
		#queue_free()
