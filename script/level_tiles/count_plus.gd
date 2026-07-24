extends InteractionTile
#TempoGlobal

@export var plus_value: int = 0

func _ready() -> void:
	plus_value += 1
	destroy_on_interaction = true
	can_enemy_interact_by_landing_on_tile = true
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true
	
func on_player_enters_tile(player: PlayerCharacter) -> void:
	TempoGlobal.coutdown_value += plus_value
	super(player)

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	TempoGlobal.coutdown_value += plus_value
	super(bullet)

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	super(enemy)
