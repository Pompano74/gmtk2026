extends Node2D
class_name BaseEnemy

@export var tilemap: LevelTileMap
@onready var coord_tracker: GridCoordTracker = $GridCoordTracker
var initial_coord : Vector2i

@export var health: int = 1:
	set(new_health):
		health = new_health
		if health <= 0 and !invincible:
			on_death()
@export var perform_action_every_x_beat: int = 1
var beat_cooldown_counter := perform_action_every_x_beat
var is_on_cooldown := false
@export var damage: int = 1
@export var invincible := false

var current_path: Array[Vector2i]
var path_affects_navigation := true
var current_tile_weight: int = 2

var timer : Timer

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	TempoGlobal.beat_win.connect(on_player_beat_win)
	TempoGlobal.player_skipped_beat.connect(on_player_skipped_beat)
	timer = TempoGlobal.timer
	coord_tracker.is_blocking_pathfinding = false
	initial_coord = coord_tracker.grid_coord

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as PlayerCharacter
	if is_instance_valid(player):
		TempoGlobal.coutdown_value -= damage
		if !invincible:
			health = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	var bullet = area.owner as PlayerBullet
	if is_instance_valid(bullet):
		if !invincible:
			health -= 1
		bullet.bullet_hit()
	elif area.collision_layer == 1: # if enemy is in wall
		if !invincible:
			health = 0

func on_player_beat_win() -> void:
	perform_action()

func on_player_skipped_beat() -> void:
	perform_action()

func perform_action() -> void:
	tilemap.update_pathfinding()
	beat_cooldown_counter -= 1
	if beat_cooldown_counter > 0:
		is_on_cooldown = true
	else:
		beat_cooldown_counter = perform_action_every_x_beat
		is_on_cooldown = false

func update_current_path(start: Vector2i, goal: Vector2i) -> void:
	update_path_navigation()
	current_path = get_a_star_path(start, goal)
	
	if path_affects_navigation:
		if current_path.size() > 1:
			tilemap.enemy_path_blocked_coords[self] = current_path[1]
		tilemap.enemy_path_weighted_coords[self] = Vector3i(
			coord_tracker.grid_coord.x,
			coord_tracker.grid_coord.y,
			current_tile_weight
		)

func update_path_navigation() -> void:
	if path_affects_navigation:
		if tilemap.enemy_path_blocked_coords.has(self):
			tilemap.astargrid.set_point_solid(tilemap.enemy_path_blocked_coords[self], false)
			tilemap.enemy_path_blocked_coords.erase(self)
		
		if tilemap.enemy_path_weighted_coords.has(self):
			tilemap.astargrid.set_point_weight_scale(Vector2i(
				tilemap.enemy_path_weighted_coords[self].x,
				tilemap.enemy_path_weighted_coords[self].y),
				tilemap.enemy_path_weighted_coords[self].z)
			tilemap.enemy_path_weighted_coords.erase(self)

func get_a_star_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	return tilemap.astargrid.get_id_path(start, goal)

func on_beat_called() -> void:
	pass

func on_death() -> void:
	update_path_navigation()
	coord_tracker.pop_from_pathfinding_array()
	
	if is_in_group("target_objectif"):
		var target_array_index = TempoGlobal.target_array.find(self)
		if target_array_index != -1:
			TempoGlobal.target_array.pop_at(target_array_index)
			print(TempoGlobal.target_array.size(), " targets left!")
