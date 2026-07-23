extends Node2D

const tile_size: Vector2 = Vector2(32, 32)
var move_time: float = 1.0
var dir: Vector2 = Vector2(0, 1)
var life_span: int = 4

func _process(delta: float) -> void:
	if move_time <= 0:
		_move(dir)
		move_time = 1.0
	else:
		move_time = move_time - delta
	
func _move(bullet_dir: Vector2):
	if life_span == 0:
		queue_free()
	else:
		global_position += bullet_dir * tile_size
		life_span = life_span - 1
