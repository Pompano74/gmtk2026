extends InteractionTile

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	TempoGlobal.beat_signal.connect(beat)
	destroy_on_interaction = true
	can_enemy_interact_by_landing_on_tile = true
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true
	
func on_player_enters_tile(player: PlayerCharacter) -> void:
	TempoGlobal.level_failed()

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	pass

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	pass

func beat():
	animated_sprite_2d.play("glitch animation", TempoGlobal.beat_inital_value, false)
