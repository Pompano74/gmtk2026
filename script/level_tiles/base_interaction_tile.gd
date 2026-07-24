extends Node2D
class_name InteractionTile

@onready var collision := $CollisionShape2D
@export var can_player_interact_by_landing_on_tile := false
@export var can_player_interact_by_shooting_tile := false
@export var can_enemy_interact_by_landing_on_tile := false
@export var destroy_on_interaction := true

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as PlayerCharacter
	if is_instance_valid(player):
		if can_player_interact_by_landing_on_tile:
			on_player_enters_tile(player)
			return
	if body.is_in_group("PlayerBullet"):
		if can_player_interact_by_shooting_tile:
			on_player_bullet_enters_tile(body)
			return
	var enemy = body as BaseEnemy
	if is_instance_valid(enemy):
		if can_enemy_interact_by_landing_on_tile:
			on_enemy_enters_tile(enemy)
			return

func on_player_enters_tile(player: PlayerCharacter) -> void:
	on_tile_interacted()

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	on_tile_interacted()

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	on_tile_interacted()

func on_tile_interacted() -> void:
	if destroy_on_interaction:
		$Sprite2D.visible = false
		can_player_interact_by_landing_on_tile = false
		can_player_interact_by_shooting_tile = false
		can_enemy_interact_by_landing_on_tile = false
		await get_tree().create_timer(TempoGlobal.beat_inital_value * 2).timeout
		queue_free()
