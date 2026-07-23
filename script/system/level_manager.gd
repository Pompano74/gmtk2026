extends Node2D

@export var tilemap: TileMapLayer

@export var player_scene: PackedScene
@export var player_spawn: Node2D

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	spawn_player()

func spawn_player() -> void:
	if player_spawn:
		#var spawn_tracker_ref = get_child_of_class(player_spawn, "GridCoordTracker") as GridCoordTracker
		var spawn_tracker_ref := player_spawn.get_node_or_null("GridCoordTracker") as GridCoordTracker
		if spawn_tracker_ref:
			print (spawn_tracker_ref.grid_coord_to_local_pos())
			var player_ref: CharacterBody2D = player_scene.instantiate()
			add_sibling(player_ref)
			player_ref.reparent(tilemap)
			player_ref.position = spawn_tracker_ref.grid_coord_to_local_pos()

#func get_child_of_class(checked_node: Node, child_class: String) -> Node:
	#for child in checked_node.get_children():
		#if child.is_class(child_class):
			#return child
	#return null
