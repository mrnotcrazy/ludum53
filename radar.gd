extends Control

@export var player_path ="../../../player"
@export var radar_range = 1000.0
@export var radar_scale = 0.04

@onready var player = get_node(player_path)

func create_enemy_blip(enemy, arrow = false):
	var blip = Sprite2D.new()
	#if arrow:
	#	blip.texture = preload("res://arrow.png")
#	blip.modulate = Color(1, 1, 1, 0)  # Make the arrow initially invisible
	#else:
	blip.texture = preload("res://blip.png")
	blip.position = (enemy.global_position - player.global_position) * radar_scale
	add_child(blip)
	return blip
	
var enemy_blips = {}

func _process(delta):
	pass
	
func remove_all_blips():
	for blip in enemy_blips.values():
		blip.queue_free()
		enemy_blips.clear()
	
func ping():
	remove_all_blips()

	# Get a list of all enemies in the current scene
	var enemies = get_tree().get_current_scene().get_tree().get_nodes_in_group("enemy")
	#print(enemies)
	# Iterate through the enemies and create/update blips
	for enemy in enemies:
			var distance_to_player = enemy.global_position.distance_to(player.global_position)
			if distance_to_player <= radar_range:
				if enemy in enemy_blips:
					enemy_blips[enemy].position = (enemy.global_position - player.global_position) * radar_scale
				else:
					enemy_blips[enemy] = create_enemy_blip(enemy)
			elif enemy in enemy_blips:
				enemy_blips[enemy].queue_free()
				enemy_blips.erase(enemy)
			
	


func _on_pingtimer_timeout():
	ping()
	pass # Replace with function body.
