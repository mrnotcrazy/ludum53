extends RigidBody2D
const ExplosionScene = preload("res://explode.tscn")
@export var health = 500
var dead = false
@export var move_speed: float = 1000.0
@export var rush_speed: float =  3000.0
@export var rotation_speed: float = 10.0
var player
var initial_position: Vector2
@export var target_position: Vector2 = Vector2(4000, 223)
@export var value = 0
var separation_force = 500

func _ready():
	initial_position = position
	
func damage(val):
	health=health-val

func setinitialize(target):
	player=target

func _physics_process(delta):
	if !dead:
		var speed=move_speed
		# Calculate the direction towards the player
		var direction_to_target = (player.global_position - global_position).normalized()
		player = get_tree().current_scene.playerShip
		var distance_to_player = global_position.distance_to(player.global_position)
		# Calculate the separation force
		if distance_to_player >= 2000:
			speed= rush_speed
			pass
		var separation = Vector2.ZERO
		var nearby_objects = $avoidance.get_overlapping_bodies()
		for obj in nearby_objects:
			if obj != self and obj.is_in_group("enemy"):
				var diff = global_position - obj.global_position
				var dist = diff.length()
				separation += diff.normalized() * (separation_force / dist)
				push_away_from(obj.global_position, 50)

		# Combine the forces
		var total_force = direction_to_target * speed + separation
		

		# Apply the force
		apply_central_force(total_force)

		# Rotate towards the player
		var target_angle = atan2(direction_to_target.y, direction_to_target.x)
		var angle_diff = target_angle - rotation
		angle_diff = fmod(angle_diff + PI, 2 * PI) - PI
		rotation += clamp(angle_diff, -delta * speed, delta * speed)
		
		
			
		if distance_to_player >= 4000:
			destruct()
		if health <= 0:
			destruct()
		



func map_value_to_volume(value):
	var min_value = 0
	var max_value = 1500
	var min_volume = -40
	var max_volume = -5
	var ratio = (value - min_value) / (max_value - min_value)
	return lerp(min_volume, max_volume, ratio)

func _on_area_2d_body_entered(body):
	#print(body)
	if body.is_in_group("ball"):
		
		var speed = body.linear_velocity.length()
		#print("Speed of the colliding object:", speed)
		if speed>100:
			health-=speed
			#print(health)
			$AudioStreamPlayer.set_volume_db(map_value_to_volume(speed))
			$AudioStreamPlayer.play()
	
	if body.is_in_group("rocket"):
		body.destruct()
		health-=250
	if body.is_in_group("enemy"):
		var speed = body.linear_velocity.length()
		health-=speed+20
		
	pass # Replace with function body.


func fireRockets():
	player = get_tree().current_scene.playerShip
	var distance_to_player = global_position.distance_to(player.global_position)
	#print(distance_to_player)
	if distance_to_player <= 700:
		if $rockets.get_child_count()!=0:
			var rockets=$rockets.get_children()
			launch_rocket(rockets[0])
			pass
		pass

func launch_rocket(rocket):
	rocket.get_parent().remove_child(rocket)
	

	# Replace "YourSceneName" with the name of your scene root node
	get_tree().current_scene.add_child(rocket)
	rocket.global_position= global_position
	rocket.activate()


func _on_salvo_timeout():
	fireRockets()
	pass # Replace with function body.


func _on_explode_timeout():
	$GPUParticles2D.emitting=true
	$explode2.start(1)
	
	pass # Replace with function body.


func _on_explode_2_timeout():
	
	var explosion_instance = ExplosionScene.instantiate()
	explosion_instance.global_position = self.global_position
	get_tree().get_current_scene().add_child(explosion_instance)
	get_tree().get_current_scene().addScore(value)
	queue_free()
	pass # Replace with function body.

func destruct():
	dead=true
	$"dying particles".set_emitting(true)
	$dyingsmoke.set_emitting(true)
	target_position=Vector2(2000,5000)
	set_gravity_scale(.05) 
	collision_mask = 5 # this will set the collision mask to the first and third layers
	collision_layer  = 5 # this will set the collision mask to the first and third layers
	$explode.start(1)
	
func push_away_from(position: Vector2, push_force: float = 1000):
	var direction = (global_position - position).normalized()
	apply_central_impulse(direction * push_force)
