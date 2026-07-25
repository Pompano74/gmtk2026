extends InteractionTile
#TempoGlobal

@export_range(1, 4) var plus_value: int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.frame = plus_value - 1
	
	plus_value += 1
	destroy_on_interaction = true
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true
	
func on_player_enters_tile(player: PlayerCharacter) -> void:
	TempoGlobal.coutdown_value += plus_value
	super(player)

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	TempoGlobal.coutdown_value += plus_value
	bullet.get_parent().bullet_hit()
	super(bullet)

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	super(enemy)
