extends Node2D

@export var tilemap: LevelTileMap



@export var level_select_win: String = "res://scenes/levels/game_levels/level_select.tscn"
@export var level_select_lose: String
@export var int_level: int = 0


@export var spawn_array: Array[Node2D]
@export var layer_array: Array[LevelTileMap]
@onready var layer_1: LevelTileMap = $level_progress/layer_1

@onready var player: PlayerCharacter = $Player
func _ready() -> void:
	TempoGlobal.int_level = int_level
	
	if spawn_array != null and layer_array != null:
		for x in spawn_array.size():
			if spawn_array[TempoGlobal.game_progress] !=null:
				TempoGlobal.ui.global_position = spawn_array[TempoGlobal.game_progress].global_position
				player.global_position = spawn_array[TempoGlobal.game_progress].global_position
				layer_array[TempoGlobal.game_progress].visible = true
				if TempoGlobal.game_progress != 0:
					layer_array[TempoGlobal.game_progress - 1].visible = false
					layer_array[TempoGlobal.game_progress - 1].collision_enabled = false
			else:
				TempoGlobal.ui.global_position = spawn_array[spawn_array.size()].global_position
				player.global_position = spawn_array[spawn_array.size()].global_position
	
	TempoGlobal.level_select_win = level_select_win
	TempoGlobal.level_select_lose = level_select_lose
	TempoGlobal.coutdown_value = 20
	TempoGlobal.can_transition = false
	TempoGlobal.ui.visible = true
	TempoGlobal.ui_label.visible = false
	TempoGlobal.label_start.visible = true
	TempoGlobal.label_reset.visible = false
	TempoGlobal.timer.stop()
	TempoGlobal.timer.wait_time = TempoGlobal.beat_inital_value
	TempoGlobal.total_target = 0
	TempoGlobal.current_target = 0
	
	
	for x in get_tree().get_nodes_in_group("target_objectif"):
		TempoGlobal.total_target += 1
		TempoGlobal.current_target += 1
	
	#await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	#spawn_player()
	
	await get_tree().create_timer(TempoGlobal.beat_inital_value * 3).timeout
	TempoGlobal.ui.visible = false
	TempoGlobal.label_start.visible = false
	TempoGlobal.level_is_restarting = false
	TempoGlobal.level_is_switching = false
	TempoGlobal.timer.start()
	TempoGlobal.can_beat = true

#func spawn_player() -> void:
	#if player_spawn:
		##var spawn_tracker_ref = get_child_of_class(player_spawn, "GridCoordTracker") as GridCoordTracker
		#var spawn_tracker_ref := player_spawn.get_node_or_null("GridCoordTracker") as GridCoordTracker
		#if spawn_tracker_ref:
			#var player_ref: PlayerCharacter = player_scene.instantiate()
			#add_sibling(player_ref)
			#player_ref.reparent(tilemap)
			#player_ref.position = spawn_tracker_ref.grid_coord_to_local_pos()
			#if tilemap != null:
				#tilemap.player = player_ref
			#else:
				#pass

#func get_child_of_class(checked_node: Node, child_class: String) -> Node:
	#for child in checked_node.get_children():
		#if child.is_class(child_class):
			#return child
	#return null
