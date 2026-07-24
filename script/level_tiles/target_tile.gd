extends Node2D
class_name TargetTile
@onready var area = $Sprite2D/Area2D
const EXPLOSION_TILE = preload("res://scenes/level_tiles/explosion_tile.tscn")

@export var BlowUp = true
var explosion_grid: Array[Node2D] = []

func _ready() -> void:
	_initialize_node2d_array()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("PlayerBullet")):
		var areaParent = area.get_parent()
		areaParent.queue_free()
		_explode()

func _initialize_node2d_array() -> void:
	explosion_grid.append($Explosion_BL)
	explosion_grid.append($Explosion_BC)
	explosion_grid.append($Explosion_BR)
	explosion_grid.append($Explosion_L)
	explosion_grid.append($Explosion_R)
	explosion_grid.append($Explosion_UL)
	explosion_grid.append($Explosion_UC)
	explosion_grid.append($Explosion_UR)

func _explode() -> void: #Spawns explosions at the right position
	print("functionCalled")
	for i in range(8):
		var explosion_instance = EXPLOSION_TILE.instantiate()
		explosion_instance.position = explosion_grid[i].global_position
		get_tree().root.add_child(explosion_instance)
