extends RigidBody2D
# Customize these variables to your needs
@export var acceleration = 1000.0
@export var rotation_speed = 4
@export var max_velocity = 150.0
@export var auto_centering_speed = 2.0
var hit = false
var exhaust_left
var exhaust_right
var sheildEnabled=true
signal damage_taken(damage_amount, is_shield)
# Emit the signal when the shields or health take damage
func take_damage(amount, is_sheilds):
	# Subtract the damage from the shields or health
	
	# Emit the damage_taken signal with the damage amount and is_shield parameter
	emit_signal("damage_taken", amount, is_sheilds)


func _ready():
	exhaust_left = $left
	exhaust_right = $right
	#$AnimationPlayer.play_backwards("sheildshit")
	
# Custom function to clamp the length of a Vector2
func clamp_vector_length(v: Vector2, max_length: float) -> Vector2:
	if v.length() > max_length:
		return v.normalized() * max_length
	return v

func _physics_process(delta):
	var input_vector = Vector2()
	var rotating = false
	# Get input for movement and rotation
	if Input.is_action_pressed("jump"):
		input_vector.y -= 1
		exhaust_left.set_emission(true)
		exhaust_right.set_emission(true)
	else:
		exhaust_left.set_emission(false)
		exhaust_right.set_emission(false)
	if Input.is_action_pressed("down"):
		$down.set_emission(true)
		input_vector.y += 1
	else:
		$down.set_emission(false)
	if Input.is_action_pressed("left"):
		#rotate(rotation_speed * delta) 
		apply_torque_impulse(-rotation_speed * delta)
		rotating = true
	if Input.is_action_pressed("right"):
		#rotate(-rotation_speed * delta) 
		apply_torque_impulse(rotation_speed * delta)
		rotating = true
 # Auto-center the rotation when the keys are released
	if not rotating:
		var torque = -rotation * auto_centering_speed
		apply_torque_impulse(torque * delta)
	# Normalize the input vector to avoid faster diagonal movement
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	# Apply force to move the ship
	var force = Vector2(0, input_vector.y * acceleration).rotated(rotation)
	apply_central_force(force)

	# Clamp the ship's velocity to the maximum allowed
	linear_velocity = clamp_vector_length(linear_velocity, max_velocity)

	#Optionally, apply some drag to the ship when not moving forward
	if input_vector.y == 0:
		apply_central_force(-linear_velocity * 0.1)


func _on_area_2d_body_entered(body):
	if sheildEnabled:
		if body.is_in_group("rocket"):
			body.damage(250)
			$AnimationPlayer.play("sheildshit")
			hit=true
			take_damage(10, true)
		elif body.is_in_group("enemy"):
			body.damage(250)
			$AnimationPlayer.play("sheildshit")
			hit=true
			take_damage(10, true)
		elif body.is_in_group("enemypart"):
			body.owner.damage(250)
			$AnimationPlayer.play("sheildshit")
			hit=true
			take_damage(10, true)		
		
	else:
		if body.is_in_group("rocket"):
			body.damage(250)
		elif body.is_in_group("enemy"):
			body.damage(250)
		take_damage(10, false)
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if hit ==true:
		hit=false
		$AnimationPlayer.play_backwards("sheildshit")
	pass # Replace with function body.


func updateHealth():
	pass
