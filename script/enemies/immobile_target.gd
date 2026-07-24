extends InteractionTile



func _ready() -> void:
	destroy_on_interaction = true
	can_enemy_interact_by_landing_on_tile = true
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true
	
func on_player_enters_tile(player: PlayerCharacter) -> void:
	TempoGlobal._beat_failed()
	TempoGlobal.current_target -= 1
	super(player)

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	print("hit target")
	TempoGlobal.current_target -= 1
	bullet.get_parent().bullet_hit()
	super(bullet)

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	super(enemy)
