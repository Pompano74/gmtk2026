extends InteractionTile

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var check: bool = false
var player_var
func _ready() -> void:
	TempoGlobal.beat_signal.connect(beat)
	destroy_on_interaction = true
	can_enemy_interact_by_landing_on_tile = true
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true
	
func on_player_enters_tile(player: PlayerCharacter) -> void:
	TempoGlobal.ui.global_position = player.global_position
	player.set_process_input(false)
	check = true
	

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	pass

func on_enemy_enters_tile(enemy: BaseEnemy) -> void:
	pass

func beat():
	if check:
		TempoGlobal.level_failed()
	animated_sprite_2d.play("glitch animation", TempoGlobal.beat_inital_value, false)
