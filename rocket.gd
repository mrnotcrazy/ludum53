extends RigidBody2D
var health =1
@export var speed = 250
var player
const ExplosionScene = preload("res://explode.tscn")
var is_active = false

func activate():
	player = get_tree().current_scene.playerShip
	is_active = true
	freeze=false
	$fuel.start(10)
	$Timer.start(3)
	

func _physics_process(delta):
	if is_active:
		var direction = (player.position - position).normalized()
		rotation = atan2(direction.y, direction.x)
		apply_central_impulse(direction * speed * delta)
	if health<=0:
		destruct()


func _on_timer_timeout():
	collision_mask = 1|2 
	collision_layer  = 1 |2 
	pass # Replace with function body.

func destruct():
	var explosion_instance = ExplosionScene.instantiate()
	explosion_instance.global_position = self.global_position
	get_tree().get_current_scene().add_child(explosion_instance)
	queue_free()
	#$Timer2.start()
	pass



func damage(val):
	health=health-val

func _on_timer_2_timeout():
	queue_free()
	pass # Replace with function body.


func _on_fuel_timeout():
	destruct()
	pass # Replace with function body.
