extends Area2D

@export var force = 1000  # Adjust this value to control the strength of the explosion

func explode():
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			var direction = (body.global_position - global_position).normalized()
			body.apply_impulse(Vector2.ZERO, direction * force)

# Optional: If you want the explosion to occur when the particles finish playing,
# connect the "particles_animation_finished" signal of the Particles2D node to this function:

func _ready():
	$Sprite2D.play("default")
	

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
