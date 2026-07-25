extends Node2D
class_name BaseEnemy

@export var tilemap: LevelTileMap
@onready var coord_tracker: GridCoordTracker = $GridCoordTracker

@export var health: int = 1:
	set(new_health):
		health = new_health
		if health <= 0:
			on_death()
@export var perform_action_every_x_beat: int = 1
var beat_cooldown_counter := perform_action_every_x_beat
var is_on_cooldown := false
@export var damage: int = 1

var current_path: Array[Vector2i]

var timer : Timer

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	TempoGlobal.beat_win.connect(on_player_beat_win)
	TempoGlobal.player_skipped_beat.connect(on_player_skipped_beat)
	timer = TempoGlobal.timer
	coord_tracker.is_blocking_pathfinding = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as PlayerCharacter
	if is_instance_valid(player):
		TempoGlobal.coutdown_value -= damage
		print("ouch")
		health = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		var bullet = area
		health -= 1
		bullet.bullet_hit()
	elif area.collision_layer == 1: # if enemy is in wall
		health = 0

func on_player_beat_win() -> void:
	perform_action()

func on_player_skipped_beat() -> void:
	perform_action()

func perform_action() -> void:
	beat_cooldown_counter -= 1
	if beat_cooldown_counter > 0:
		is_on_cooldown = true
	else:
		beat_cooldown_counter = perform_action_every_x_beat
		is_on_cooldown = false

func update_current_path(start: Vector2i, goal: Vector2i) -> void:
	current_path = get_a_star_path(start, goal)

func get_a_star_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	return tilemap.astargrid.get_id_path(start, goal)

func on_beat_called() -> void:
	pass

func on_death() -> void:
	coord_tracker.pop_from_pathfinding_array()
	if is_in_group("target_objectif"):
		var target_array_index = TempoGlobal.target_array.find(self)
		if target_array_index != -1:
			TempoGlobal.target_array.pop_at(target_array_index)
			print(TempoGlobal.target_array.size(), " targets left!")
